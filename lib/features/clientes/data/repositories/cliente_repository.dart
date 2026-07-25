import '../datasources/cliente_remote_datasource.dart';
import '../models/cliente.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [ClienteRemoteDataSource] — mismo patrón ya validado en
/// `ProveedorRepository` (Sprint 5).
class ClienteRepository {
  const ClienteRepository(this._remoteDataSource);

  final ClienteRemoteDataSource _remoteDataSource;

  Future<List<Cliente>> getClientes() async {
    final dtos = await _remoteDataSource.getClientes();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<Cliente> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    final dto = await _remoteDataSource.crear(
      nombre: nombre,
      tipoId: tipoId,
      lugar: lugar,
      telefono: telefono,
    );
    return dto.toDomain();
  }

  Future<Cliente> actualizar(
    int id, {
    String? nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    final dto = await _remoteDataSource.actualizar(
      id,
      nombre: nombre,
      tipoId: tipoId,
      lugar: lugar,
      telefono: telefono,
    );
    return dto.toDomain();
  }
}