import '../datasources/procesamiento_remote_datasource.dart';
import '../models/procesamiento.dart';

/// Deja pasar tal cual cualquier `ApiException`/`NetworkException` que
/// lance [ProcesamientoRemoteDataSource] — mismo patrón ya validado en
/// `ComprasRepository`/`VentasRepository`. En particular, un `400` con
/// "Transición de estado no permitida para este lote" llega como
/// cualquier otro `ApiException`, sin manejo especial.
class ProcesamientoRepository {
  const ProcesamientoRepository(this._remoteDataSource);

  final ProcesamientoRemoteDataSource _remoteDataSource;

  Future<Procesamiento> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    final dto = await _remoteDataSource.crear(
      loteOrigenId: loteOrigenId,
      estadoDestinoId: estadoDestinoId,
      cantidadEntrada: cantidadEntrada,
      cantidadSalida: cantidadSalida,
    );
    return dto.toDomain();
  }
}
