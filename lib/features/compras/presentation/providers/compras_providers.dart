import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import '../../data/models/compra.dart';
import '../../data/repositories/compras_repository.dart';

/// Instancia única de [ComprasRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final comprasRepositoryProvider = Provider<ComprasRepository>((ref) {
  final dataSource = ComprasRemoteDataSource(ref.watch(apiClientProvider));
  return ComprasRepository(dataSource);
});

/// Historial de compras (`GET /compras`). Se invalida desde
/// `ComprasAnularController` tras un `anular` exitoso — mismo patrón que
/// `existenciasProvider`.
final comprasHistorialProvider = FutureProvider<List<Compra>>((ref) {
  return ref.watch(comprasRepositoryProvider).listar();
});
