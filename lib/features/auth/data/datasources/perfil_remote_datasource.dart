import '../../../../core/api/api_client.dart';
import '../dtos/perfil_dto.dart';

/// Fuente de datos remota del perfil del usuario autenticado
/// (`GET /perfil`, `CONTEXTO-MOVIL-FLUTTER.md` sección 6.8).
class PerfilRemoteDataSource {
  const PerfilRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PerfilDto> getPerfil() async {
    final response = await _apiClient.get('/perfil');
    return PerfilDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `PATCH /perfil` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.8): único
  /// campo editable es `nombre`. El contrato no muestra ningún ejemplo
  /// de JSON de respuesta (solo "→ 200 OK") — no se parsea el cuerpo,
  /// mismo criterio ya aplicado en `anular` (Sprint 9) y `marcarLeida`
  /// (Sprint 10); quien llama refresca con un `GET /perfil` real tras
  /// el éxito.
  Future<void> actualizar(String nombre) async {
    await _apiClient.patch('/perfil', data: {'nombre': nombre});
  }
}
