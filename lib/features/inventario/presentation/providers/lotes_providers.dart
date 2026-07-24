import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/lotes_remote_datasource.dart';
import '../../data/models/lote.dart';
import '../../data/repositories/lotes_repository.dart';

/// Instancia única de [LotesRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final lotesRepositoryProvider = Provider<LotesRepository>((ref) {
  final dataSource = LotesRemoteDataSource(ref.watch(apiClientProvider));
  return LotesRepository(dataSource);
});

/// Existencias actuales (`GET /lotes/existencias`). Se invalida
/// manualmente desde `CompraFormController` tras un `crear` exitoso —
/// registrar una compra genera lotes nuevos.
final existenciasProvider = FutureProvider<List<Lote>>((ref) {
  return ref.watch(lotesRepositoryProvider).getExistencias();
});
