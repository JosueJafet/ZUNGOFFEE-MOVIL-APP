import '../datasources/pago_remote_datasource.dart';
import '../models/pago.dart';
import '../models/pagos_resumen.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [PagoRemoteDataSource] — mismo patrón ya validado en
/// `ApiClient`/`BodegaRepository`.
class PagoRepository {
  const PagoRepository(this._remoteDataSource);

  final PagoRemoteDataSource _remoteDataSource;

  Future<PagosResumen> getResumen() async {
    final dto = await _remoteDataSource.getResumen();
    return dto.toDomain();
  }

  Future<List<Pago>> getHistorialPorBodega(int tenantId) async {
    final dtos = await _remoteDataSource.getHistorialPorBodega(tenantId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> registrar({
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
  }) {
    return _remoteDataSource.registrar(
      tenantId: tenantId,
      periodo: periodo,
      monto: monto,
      fechaVencimiento: fechaVencimiento,
    );
  }

  Future<void> marcarPagado(int id) => _remoteDataSource.marcarPagado(id);
}
