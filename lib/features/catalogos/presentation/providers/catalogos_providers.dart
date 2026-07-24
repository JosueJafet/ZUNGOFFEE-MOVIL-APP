import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/catalogos_remote_datasource.dart';
import '../../data/models/catalogos.dart';
import '../../data/repositories/catalogos_repository.dart';

/// Instancia única de [CatalogosRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final catalogosRepositoryProvider = Provider<CatalogosRepository>((ref) {
  final dataSource = CatalogosRemoteDataSource(ref.watch(apiClientProvider));
  return CatalogosRepository(dataSource);
});

/// Catálogos compartidos (`GET /catalogos`) — se resuelve una sola vez y
/// se cachea, igual que `perfilProvider`; no depende de ningún estado de
/// sesión ni se invalida desde ningún controller (los catálogos no
/// cambian durante la sesión del usuario).
final catalogosProvider = FutureProvider<Catalogos>((ref) {
  return ref.watch(catalogosRepositoryProvider).getCatalogos();
});
