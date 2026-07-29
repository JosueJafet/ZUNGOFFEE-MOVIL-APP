import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/fcm_providers.dart';
import '../../../notificaciones/presentation/providers/notificaciones_providers.dart';
import 'auth_providers.dart';

/// Plataforma Android en el catálogo de `dispositivos_push` del backend
/// (`CONTEXTO-PUSH-FCM-MOVIL.md`, sección 6) — la app solo soporta
/// Android por ahora.
const _plataformaIdAndroid = 2;

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
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signIn(email: email, password: password);
      await _registrarDispositivo();
    });
  }

  /// Pide permiso de notificaciones y registra el token FCM del
  /// dispositivo — "después del login", como pide
  /// `CONTEXTO-PUSH-FCM-MOVIL.md`. Best-effort: un fallo acá (sin red,
  /// token nulo, permiso denegado) no debe bloquear un login exitoso —
  /// el endpoint es upsert, así que se reintenta solo en el próximo
  /// login o `onTokenRefresh` (`main.dart`).
  Future<void> _registrarDispositivo() async {
    try {
      final fcmService = ref.read(fcmServiceProvider);
      await fcmService.solicitarPermiso();
      final token = await fcmService.obtenerToken();
      if (token == null) return;

      await ref
          .read(notificacionesRepositoryProvider)
          .registrarDispositivo(token: token, plataformaId: _plataformaIdAndroid);
    } catch (e) {
      debugPrint('No se pudo registrar el token FCM: $e');
    }
  }
}

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);
