import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/procesamiento_remote_datasource.dart';
import '../../data/models/procesamiento.dart';
import '../../data/repositories/procesamiento_repository.dart';

/// Instancia única de [ProcesamientoRepository] para toda la app,
/// construida sobre el mismo `apiClientProvider` (`core/api`) que usa el
/// resto de la app.
final procesamientoRepositoryProvider = Provider<ProcesamientoRepository>((
  ref,
) {
  final dataSource = ProcesamientoRemoteDataSource(
    ref.watch(apiClientProvider),
  );
  return ProcesamientoRepository(dataSource);
});

/// Historial de procesamiento (`GET /procesamiento`). Se invalida desde
/// `ProcesamientoAnularController` tras un `anular` exitoso — mismo
/// patrón que `existenciasProvider`.
final procesamientoHistorialProvider = FutureProvider<List<Procesamiento>>((
  ref,
) {
  return ref.watch(procesamientoRepositoryProvider).listar();
});
