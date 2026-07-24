import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import '../../data/repositories/compras_repository.dart';

/// Instancia única de [ComprasRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final comprasRepositoryProvider = Provider<ComprasRepository>((ref) {
  final dataSource = ComprasRemoteDataSource(ref.watch(apiClientProvider));
  return ComprasRepository(dataSource);
});
