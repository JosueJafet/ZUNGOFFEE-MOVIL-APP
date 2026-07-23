import '../datasources/perfil_remote_datasource.dart';
import '../models/perfil.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [PerfilRemoteDataSource] — mismo patrón ya validado en
/// `ApiClient`: sin envolver ni perder información del error original.
class PerfilRepository {
  const PerfilRepository(this._remoteDataSource);

  final PerfilRemoteDataSource _remoteDataSource;

  Future<Perfil> getPerfil() async {
    final dto = await _remoteDataSource.getPerfil();
    return dto.toDomain();
  }
}
