import '../../../../core/constants/pagination_limits.dart';
import '../datasources/lotes_remote_datasource.dart';
import '../models/lote.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [LotesRemoteDataSource] — mismo patrón ya validado en
/// `ProveedorRepository`/`ComprasRepository`.
class LotesRepository {
  const LotesRepository(this._remoteDataSource);

  final LotesRemoteDataSource _remoteDataSource;

  Future<List<Lote>> getExistencias({
    int page = 1,
    int pageSize = PaginationLimits.defaultPageSize,
  }) async {
    final dtos = await _remoteDataSource.getExistencias(
      page: page,
      pageSize: pageSize,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
