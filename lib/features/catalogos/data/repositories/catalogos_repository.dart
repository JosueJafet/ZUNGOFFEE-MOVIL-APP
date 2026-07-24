import '../datasources/catalogos_remote_datasource.dart';
import '../models/catalogos.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [CatalogosRemoteDataSource] — mismo patrón ya validado en
/// `ProveedorRepository`/`PerfilRepository`.
class CatalogosRepository {
  const CatalogosRepository(this._remoteDataSource);

  final CatalogosRemoteDataSource _remoteDataSource;

  Future<Catalogos> getCatalogos() async {
    final dto = await _remoteDataSource.getCatalogos();
    return dto.toDomain();
  }
}
