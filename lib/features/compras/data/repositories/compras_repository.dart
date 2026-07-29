import '../../../../shared/data/models/resumen_diario.dart';
import '../datasources/compras_remote_datasource.dart';
import '../models/compra.dart';
import '../models/compra_historial.dart';

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

  Future<List<CompraHistorial>> listar({int page = 1, int pageSize = 20}) async {
    final dtos = await _remoteDataSource.listar(page: page, pageSize: pageSize);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> anular(int id) => _remoteDataSource.anular(id);

  Future<List<ResumenDiario>> getResumen() async {
    final dtos = await _remoteDataSource.getResumen();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
