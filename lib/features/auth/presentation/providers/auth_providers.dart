import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/auth_providers.dart';
import '../../data/repositories/auth_repository.dart';

/// Instancia única de [AuthRepository] para toda la app, construida sobre
/// el mismo `authSessionServiceProvider` (`core/services`) que usa el
/// resto de la app.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authSessionServiceProvider));
});

/// Estado de sesión reactivo (login, logout, refresh de token). El router
/// ya reacciona a este mismo cambio por su cuenta vía
/// `GoRouterRefreshStream`; este provider expone el mismo evento a
/// cualquier widget que necesite reaccionar a él con Riverpod.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChange;
});

/// `true` si hay una sesión activa. Antes de que `authStateProvider`
/// emita su primer evento, refleja el valor sincrónico ya disponible en
/// `AuthRepository.isAuthenticated`.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.session != null,
    orElse: () => ref.watch(authRepositoryProvider).isAuthenticated,
  );
});
