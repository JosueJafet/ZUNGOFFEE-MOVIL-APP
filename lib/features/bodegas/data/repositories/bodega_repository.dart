import '../datasources/bodega_remote_datasource.dart';
import '../models/bodega.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [BodegaRemoteDataSource] — mismo patrón ya validado en
/// `ApiClient`/`ProveedorRepository`.
class BodegaRepository {
  const BodegaRepository(this._remoteDataSource);

  final BodegaRemoteDataSource _remoteDataSource;

  Future<List<Bodega>> getBodegas() async {
    final dtos = await _remoteDataSource.getBodegas();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<Bodega> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    final dto = await _remoteDataSource.onboarding(
      nombreBodega: nombreBodega,
      emailAdmin: emailAdmin,
      passwordAdmin: passwordAdmin,
      nombreAdmin: nombreAdmin,
      solicitudId: solicitudId,
    );
    return dto.toDomain();
  }

  Future<Bodega> actualizarNombre(int id, {required String nombre}) async {
    final dto = await _remoteDataSource.actualizarNombre(id, nombre: nombre);
    return dto.toDomain();
  }

  Future<void> suspender(int id) => _remoteDataSource.suspender(id);

  Future<void> activar(int id) => _remoteDataSource.activar(id);
}
