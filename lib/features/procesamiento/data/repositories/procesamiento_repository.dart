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

  Future<List<Procesamiento>> listar({int page = 1, int pageSize = 20}) async {
    final dtos = await _remoteDataSource.listar(page: page, pageSize: pageSize);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> anular(String id) => _remoteDataSource.anular(id);
}
