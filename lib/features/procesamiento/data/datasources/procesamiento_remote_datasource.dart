import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_list_response.dart';
import '../dtos/procesamiento_dto.dart';

/// Fuente de datos remota de procesamiento (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.6).
class ProcesamientoRemoteDataSource {
  const ProcesamientoRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `loteOrigenId` se declara `String` (coincide con `Lote.id`,
  /// `BigIntId`) y se manda tal cual — mismo criterio que
  /// `LineaVentaInput.loteId` (Sprint 7): el contrato acepta tanto número
  /// como string para IDs de lote.
  Future<ProcesamientoDto> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    final response = await _apiClient.post(
      '/procesamiento',
      data: {
        'loteOrigenId': loteOrigenId,
        'estadoDestinoId': estadoDestinoId,
        'cantidadEntrada': cantidadEntrada,
        'cantidadSalida': cantidadSalida,
      },
    );
    return ProcesamientoDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `GET /procesamiento` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 7). El
  /// contrato no da ningún ejemplo de JSON de respuesta — se parsea con
  /// [ApiListResponse.extractItems] en vez de asumir un shape (Sprint 9,
  /// Decisión 5).
  Future<List<ProcesamientoDto>> listar({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      '/procesamiento',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return ApiListResponse.extractItems(response.data)
        .map((item) => ProcesamientoDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// `PATCH /procesamiento/:id/anular` (sección 7): "400 si el lote
  /// derivado ya se movió". No se parsea el cuerpo de la respuesta — el
  /// contrato tampoco confirma qué devuelve (Sprint 9, Decisión 5); quien
  /// llama refresca el historial con un `GET /procesamiento` real tras el
  /// éxito.
  Future<void> anular(String id) async {
    await _apiClient.patch('/procesamiento/$id/anular');
  }
}
