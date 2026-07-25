import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_list_response.dart';
import '../dtos/venta_dto.dart';

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

  /// `GET /ventas` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 7). El contrato
  /// no da ningún ejemplo de JSON de respuesta — se parsea con
  /// [ApiListResponse.extractItems] en vez de asumir un shape (Sprint 9,
  /// Decisión 5).
  Future<List<VentaDto>> listar({int page = 1, int pageSize = 20}) async {
    final response = await _apiClient.get(
      '/ventas',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return ApiListResponse.extractItems(response.data)
        .map((item) => VentaDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// `PATCH /ventas/:id/anular` (sección 7): "siempre revierte saldo". No
  /// se parsea el cuerpo de la respuesta — el contrato tampoco confirma
  /// qué devuelve (Sprint 9, Decisión 5); quien llama refresca el
  /// historial con un `GET /ventas` real tras el éxito.
  Future<void> anular(int id) async {
    await _apiClient.patch('/ventas/$id/anular');
  }
}