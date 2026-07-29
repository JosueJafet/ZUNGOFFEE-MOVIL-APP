import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_list_response.dart';
import '../../../../shared/data/dtos/resumen_diario_dto.dart';
import '../dtos/compra_dto.dart';
import '../dtos/compra_historial_dto.dart';

/// Una línea de una compra a registrar (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.3). Solo se manda, nunca se recibe — por eso no es un DTO con
/// `fromJson`, solo un `toJson()` propio.
class LineaCompraInput {
  const LineaCompraInput({
    required this.estadoCafeId,
    required this.variedadId,
    required this.alturaId,
    this.humedad,
    required this.cantidad,
    required this.costoUnitario,
  });

  final int estadoCafeId;
  final int variedadId;
  final int alturaId;

  /// `null` para líneas en estado `uva` — el backend no la exige en esa
  /// etapa (recién cosechada, todavía no hay pergamino que medir).
  final double? humedad;
  final double cantidad;
  final double costoUnitario;

  Map<String, dynamic> toJson() => {
    'estadoCafeId': estadoCafeId,
    'variedadId': variedadId,
    'alturaId': alturaId,
    if (humedad != null) 'humedad': humedad,
    'cantidad': cantidad,
    'costoUnitario': costoUnitario,
  };
}

/// Fuente de datos remota de compras (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.3).
class ComprasRemoteDataSource {
  const ComprasRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `metodoPagoId` es opcional según la documentación del endpoint: solo
  /// se incluye en el body si no es nulo, mismo patrón de body parcial ya
  /// usado en `ProveedorRemoteDataSource.actualizar` (Sprint 5).
  Future<CompraDto> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    final response = await _apiClient.post(
      '/compras',
      data: {
        'proveedorId': proveedorId,
        if (metodoPagoId != null) 'metodoPagoId': metodoPagoId,
        'lineas': lineas.map((linea) => linea.toJson()).toList(),
      },
    );
    return CompraDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `GET /compras`. Forma confirmada contra la API real (curl): un shape
  /// completamente distinto al de `POST /compras` — de ahí
  /// `CompraHistorialDto` en vez de `CompraDto`. Se sigue usando
  /// [ApiListResponse.extractItems] en vez de asumir el shape del
  /// envoltorio (Sprint 9, Decisión 5).
  Future<List<CompraHistorialDto>> listar({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/compras',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return ApiListResponse.extractItems(response.data)
        .map(
          (item) => CompraHistorialDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// `PATCH /compras/:id/anular` (sección 7): "400 si algún lote ya se
  /// movió". No se parsea el cuerpo de la respuesta — el contrato tampoco
  /// confirma qué devuelve (Sprint 9, Decisión 5); quien llama refresca
  /// el historial con un `GET /compras` real tras el éxito.
  Future<void> anular(int id) async {
    await _apiClient.patch('/compras/$id/anular');
  }

  /// `GET /compras/resumen`, solo `admin_bodega`. Devuelve un `groupBy`
  /// de Prisma (un total por fecha con actividad), no un total ya
  /// agregado — ver el comentario de `ResumenDiarioDto`. No manda
  /// `?desde&hasta`: el endpoint los ignora (verificado en producción).
  Future<List<ResumenDiarioDto>> getResumen() async {
    final response = await _apiClient.get('/compras/resumen');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => ResumenDiarioDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
