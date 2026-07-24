import '../../../../core/api/api_client.dart';
import '../dtos/catalogos_dto.dart';

/// Fuente de datos remota de catálogos (`CONTEXTO-MOVIL-FLUTTER.md`,
/// `GET /catalogos`).
class CatalogosRemoteDataSource {
  const CatalogosRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<CatalogosDto> getCatalogos() async {
    final response = await _apiClient.get('/catalogos');
    return CatalogosDto.fromJson(response.data as Map<String, dynamic>);
  }
}
