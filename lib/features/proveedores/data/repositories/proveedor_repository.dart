import '../datasources/proveedor_remote_datasource.dart';
import '../models/proveedor.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [ProveedorRemoteDataSource] — mismo patrón ya validado en
/// `ApiClient`/`PerfilRepository`: sin envolver ni perder información del
/// error original.
class ProveedorRepository {
  const ProveedorRepository(this._remoteDataSource);

  final ProveedorRemoteDataSource _remoteDataSource;

  Future<List<Proveedor>> getProveedores() async {
    final dtos = await _remoteDataSource.getProveedores();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<Proveedor> crear({
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    final dto = await _remoteDataSource.crear(
      nombre: nombre,
      sexo: sexo,
      lugar: lugar,
      finca: finca,
      telefono: telefono,
    );
    return dto.toDomain();
  }

  Future<Proveedor> actualizar(
    int id, {
    String? nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    final dto = await _remoteDataSource.actualizar(
      id,
      nombre: nombre,
      sexo: sexo,
      lugar: lugar,
      finca: finca,
      telefono: telefono,
    );
    return dto.toDomain();
  }
}
