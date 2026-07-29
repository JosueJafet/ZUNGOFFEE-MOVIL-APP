import '../../../../core/api/api_client.dart';
import '../dtos/solicitud_dto.dart';

/// Fuente de datos remota de solicitudes de acceso — contrato confirmado
/// por Rubio, backend (no está en ningún `CONTEXTO-*.md`).
class SolicitudRemoteDataSource {
  const SolicitudRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SolicitudDto>> getSolicitudes() async {
    final response = await _apiClient.get('/solicitudes');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => SolicitudDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Descarta el body de la respuesta a propósito — mismo criterio que
  /// `BodegaRemoteDataSource.suspender`/`activar`: quien dispara esto
  /// invalida y vuelve a pedir `solicitudesProvider`.
  Future<void> rechazar(int id) async {
    await _apiClient.patch('/solicitudes/$id/rechazar');
  }
}
