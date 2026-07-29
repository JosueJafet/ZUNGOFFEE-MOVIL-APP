import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/bodega_remote_datasource.dart';
import '../../data/models/bodega.dart';
import '../../data/repositories/bodega_repository.dart';

/// Instancia única de [BodegaRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final bodegaRepositoryProvider = Provider<BodegaRepository>((ref) {
  final dataSource = BodegaRemoteDataSource(ref.watch(apiClientProvider));
  return BodegaRepository(dataSource);
});

/// Lista de bodegas (`GET /tenants`, solo `super_admin`). Se invalida
/// manualmente desde [BodegaFormController]/[BodegaEstadoController] tras
/// un `crear`/`actualizarNombre`/`suspender`/`activar` exitoso.
final bodegasProvider = FutureProvider<List<Bodega>>((ref) {
  return ref.watch(bodegaRepositoryProvider).getBodegas();
});
