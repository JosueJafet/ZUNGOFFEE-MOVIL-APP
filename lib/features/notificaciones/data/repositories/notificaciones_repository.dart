import '../datasources/notificaciones_remote_datasource.dart';
import '../models/notificacion.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [NotificacionesRemoteDataSource] — mismo patrón ya validado en
/// `ComprasRepository`/`VentasRepository`/`ProcesamientoRepository`.
class NotificacionesRepository {
  const NotificacionesRepository(this._remoteDataSource);

  final NotificacionesRemoteDataSource _remoteDataSource;

  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) async {
    final dtos = await _remoteDataSource.listar(page: page, pageSize: pageSize);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> marcarLeida(String id) => _remoteDataSource.marcarLeida(id);
}
