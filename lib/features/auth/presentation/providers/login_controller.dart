import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// Controla el envío del formulario de login. Expone loading/error/success
/// como `AsyncValue<void>` para que la pantalla (Task 5) solo tenga que
/// escuchar este estado — nunca navega ni dispara ningún redirect: el
/// cambio de sesión que reporta `AuthSessionService` sigue siendo el único
/// mecanismo que hace que `AppRouter` reevalúe sus redirects.
class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(authRepositoryProvider).signIn(email: email, password: password);
    });
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);
