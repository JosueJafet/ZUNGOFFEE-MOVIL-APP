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
}
