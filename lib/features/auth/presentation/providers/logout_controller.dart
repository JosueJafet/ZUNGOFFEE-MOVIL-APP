import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// Controla el cierre de sesión. Expone loading/error/success como
/// `AsyncValue<void>` para que cualquier pantalla (p. ej. `HomeScreen`)
/// solo tenga que escuchar este estado — nunca navega ni dispara ningún
/// redirect: el cambio de sesión que reporta `AuthSessionService` sigue
/// siendo el único mecanismo que hace que `AppRouter` reevalúe sus
/// redirects.
class LogoutController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(authRepositoryProvider).signOut();
    });
  }
}

final logoutControllerProvider = AsyncNotifierProvider<LogoutController, void>(
  LogoutController.new,
);
