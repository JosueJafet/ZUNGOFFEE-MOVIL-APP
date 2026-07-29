import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_list_response.dart';
import '../dtos/notificacion_dto.dart';

/// Fuente de datos remota de notificaciones (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.7).
class NotificacionesRemoteDataSource {
  const NotificacionesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `GET /notificaciones`. `pageSize` por defecto es **50**, no 20 —
  /// única excepción documentada a la paginación estándar (sección 5). El
  /// contrato no da ningún ejemplo de JSON de respuesta más allá del
  /// array — se parsea con [ApiListResponse.extractItems] en vez de
  /// asumir un shape (mismo criterio que Sprint 9, Decisión 5).
  Future<List<NotificacionDto>> listar({
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await _apiClient.get(
      '/notificaciones',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return ApiListResponse.extractItems(response.data)
        .map((item) => NotificacionDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// `PATCH /notificaciones/:id/leida`. No se parsea el cuerpo de la
  /// respuesta — el contrato tampoco confirma qué devuelve (mismo
  /// criterio que `anular`, Sprint 9); quien llama refresca la bandeja
  /// con un `GET /notificaciones` real tras el éxito.
  Future<void> marcarLeida(String id) async {
    await _apiClient.patch('/notificaciones/$id/leida');
  }

  /// `POST /notificaciones/dispositivos` (`CONTEXTO-PUSH-FCM-MOVIL.md`,
  /// sección 6) — registra/actualiza el token FCM del dispositivo.
  /// Upsert por `token` (no por usuario): reintentarlo no genera
  /// duplicados. No se parsea el cuerpo de la respuesta — la doc no da
  /// ejemplo de JSON de respuesta, mismo criterio que `marcarLeida`.
  Future<void> registrarDispositivo({
    required String token,
    required int plataformaId,
  }) async {
    await _apiClient.post(
      '/notificaciones/dispositivos',
      data: {'token': token, 'plataformaId': plataformaId},
    );
  }

  /// `DELETE /notificaciones/dispositivos` — marca el token como
  /// `activo: false` (no borra la fila). Idempotente y con scope al
  /// propio usuario.
  Future<void> desregistrarDispositivo(String token) async {
    await _apiClient.delete('/notificaciones/dispositivos', data: {'token': token});
  }
}
