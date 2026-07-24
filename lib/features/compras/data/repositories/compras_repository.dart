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
}
