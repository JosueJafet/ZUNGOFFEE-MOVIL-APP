import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/perfil_remote_datasource.dart';
import '../../data/models/perfil.dart';
import '../../data/repositories/perfil_repository.dart';
import 'auth_providers.dart';

/// Instancia única de [PerfilRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final perfilRepositoryProvider = Provider<PerfilRepository>((ref) {
  final dataSource = PerfilRemoteDataSource(ref.watch(apiClientProvider));
  return PerfilRepository(dataSource);
});

/// Perfil del usuario autenticado (`GET /perfil`). Se reevalúa cada vez
/// que cambia el estado de sesión (`authStateProvider`) para no dejar en
/// caché el perfil de un usuario anterior tras un logout.
final perfilProvider = FutureProvider<Perfil>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(perfilRepositoryProvider).getPerfil();
});
