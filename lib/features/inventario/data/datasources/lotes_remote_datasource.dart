import '../../../../core/api/api_client.dart';
import '../../../../core/constants/pagination_limits.dart';
import '../dtos/lote_dto.dart';

/// Fuente de datos remota de lotes/existencias
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.4).
class LotesRemoteDataSource {
  const LotesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<LoteDto>> getExistencias({
    int page = 1,
    int pageSize = PaginationLimits.defaultPageSize,
  }) async {
    final response = await _apiClient.get(
      '/lotes/existencias',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((json) => LoteDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
