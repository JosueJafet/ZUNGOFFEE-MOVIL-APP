import '../datasources/solicitud_remote_datasource.dart';
import '../models/solicitud.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [SolicitudRemoteDataSource] — mismo patrón ya validado en
/// `ApiClient`/`BodegaRepository`.
class SolicitudRepository {
  const SolicitudRepository(this._remoteDataSource);

  final SolicitudRemoteDataSource _remoteDataSource;

  Future<List<Solicitud>> getSolicitudes() async {
    final dtos = await _remoteDataSource.getSolicitudes();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> rechazar(int id) => _remoteDataSource.rechazar(id);
}
