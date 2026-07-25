import '../datasources/compras_remote_datasource.dart';
import '../models/compra.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [ComprasRemoteDataSource] — mismo patrón ya validado en
/// `ProveedorRepository`/`PerfilRepository`.
class ComprasRepository {
  const ComprasRepository(this._remoteDataSource);

  final ComprasRemoteDataSource _remoteDataSource;

  Future<Compra> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    final dto = await _remoteDataSource.crear(
      proveedorId: proveedorId,
      metodoPagoId: metodoPagoId,
      lineas: lineas,
    );
    return dto.toDomain();
  }

  Future<List<Compra>> listar({int page = 1, int pageSize = 20}) async {
    final dtos = await _remoteDataSource.listar(page: page, pageSize: pageSize);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> anular(int id) => _remoteDataSource.anular(id);
}
