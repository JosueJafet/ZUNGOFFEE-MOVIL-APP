import '../../../../core/api/api_client.dart';
import '../dtos/bodega_dto.dart';

/// Fuente de datos remota de bodegas (tenants) — contrato confirmado por
/// Rubio, backend (no está en ningún `CONTEXTO-*.md`).
class BodegaRemoteDataSource {
  const BodegaRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<BodegaDto>> getBodegas() async {
    final response = await _apiClient.get('/tenants');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => BodegaDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea una bodega y su admin en un solo paso. `solicitudId` es
  /// opcional: si viene, marca esa Solicitud como procesada (ver
  /// `features/solicitudes`).
  Future<BodegaDto> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    final response = await _apiClient.post(
      '/tenants/onboarding',
      data: {
        'nombreBodega': nombreBodega,
        'emailAdmin': emailAdmin,
        'passwordAdmin': passwordAdmin,
        'nombreAdmin': nombreAdmin,
        if (solicitudId != null) 'solicitudId': solicitudId,
      },
    );
    final tenantJson =
        (response.data as Map<String, dynamic>)['tenant']
            as Map<String, dynamic>;
    return BodegaDto.fromJson(tenantJson);
  }

  Future<BodegaDto> actualizarNombre(int id, {required String nombre}) async {
    final response = await _apiClient.patch(
      '/tenants/$id',
      data: {'nombre': nombre},
    );
    return BodegaDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Descarta el body de la respuesta a propósito: quien dispara esto
  /// invalida y vuelve a pedir `bodegasProvider` para reflejar el cambio,
  /// mismo criterio ya documentado en
  /// `procesamiento_anular_controller.dart`.
  Future<void> suspender(int id) async {
    await _apiClient.patch('/pagos/tenant/$id/suspender');
  }

  Future<void> activar(int id) async {
    await _apiClient.patch('/pagos/tenant/$id/activar');
  }
}
