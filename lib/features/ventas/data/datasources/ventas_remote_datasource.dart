import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_list_response.dart';
import '../../../../shared/data/dtos/resumen_diario_dto.dart';
import '../dtos/venta_dto.dart';
import '../dtos/venta_historial_dto.dart';

/// Una línea de una venta a registrar (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.5). Solo se manda, nunca se recibe — por eso no es un DTO con
/// `fromJson`, solo un `toJson()` propio. `loteId` se declara `String`
/// (no `int`) porque coincide con `Lote.id` (`features/inventario`,
/// `BigIntId`) — el contrato acepta tanto número como string, así que se
/// manda tal cual sin parseo.
class LineaVentaInput {
  const LineaVentaInput({
    required this.loteId,
    required this.cantidad,
    required this.precioUnitario,
  });

  final String loteId;
  final double cantidad;
  final double precioUnitario;

  Map<String, dynamic> toJson() => {
    'loteId': loteId,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
  };
}

/// Fuente de datos remota de ventas (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.5).
class VentasRemoteDataSource {
  const VentasRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `metodoPagoId` es opcional según la documentación del endpoint —
  /// mismo patrón de body parcial que `ComprasRemoteDataSource.crear`
  /// (Sprint 6).
  Future<VentaDto> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    final response = await _apiClient.post(
      '/ventas',
      data: {
        'clienteId': clienteId,
        if (metodoPagoId != null) 'metodoPagoId': metodoPagoId,
        'lineas': lineas.map((linea) => linea.toJson()).toList(),
      },
    );
    return VentaDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `GET /ventas`. Forma confirmada contra la API real (curl): un shape
  /// completamente distinto al de `POST /ventas` — de ahí
  /// `VentaHistorialDto` en vez de `VentaDto`. Se sigue usando
  /// [ApiListResponse.extractItems] en vez de asumir el shape del
  /// envoltorio (Sprint 9, Decisión 5).
  Future<List<VentaHistorialDto>> listar({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/ventas',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return ApiListResponse.extractItems(response.data)
        .map(
          (item) => VentaHistorialDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// `PATCH /ventas/:id/anular` (sección 7): "siempre revierte saldo". No
  /// se parsea el cuerpo de la respuesta — el contrato tampoco confirma
  /// qué devuelve (Sprint 9, Decisión 5); quien llama refresca el
  /// historial con un `GET /ventas` real tras el éxito.
  Future<void> anular(int id) async {
    await _apiClient.patch('/ventas/$id/anular');
  }

  /// `GET /ventas/resumen`, solo `admin_bodega`. Mismo shape/gotchas que
  /// `ComprasRemoteDataSource.getResumen` — ver `ResumenDiarioDto`.
  Future<List<ResumenDiarioDto>> getResumen() async {
    final response = await _apiClient.get('/ventas/resumen');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => ResumenDiarioDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}