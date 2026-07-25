import '../datasources/ventas_remote_datasource.dart';
import '../models/venta.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [VentasRemoteDataSource] — mismo patrón ya validado en
/// `ComprasRepository` (Sprint 6). En particular, un `400` con "Saldo
/// insuficiente en lote X" (sección 6.5) llega como cualquier otro
/// `ApiException`, sin manejo especial.
class VentasRepository {
  const VentasRepository(this._remoteDataSource);

  final VentasRemoteDataSource _remoteDataSource;

  Future<Venta> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    final dto = await _remoteDataSource.crear(
      clienteId: clienteId,
      metodoPagoId: metodoPagoId,
      lineas: lineas,
    );
    return dto.toDomain();
  }

  Future<List<Venta>> listar({int page = 1, int pageSize = 20}) async {
    final dtos = await _remoteDataSource.listar(page: page, pageSize: pageSize);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> anular(int id) => _remoteDataSource.anular(id);
}