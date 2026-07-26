import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notificaciones_providers.dart';

/// Controla marcar una notificación como leída (`PATCH
/// /notificaciones/:id/leida`).
///
/// No actualiza el ítem de forma optimista: el datasource no parsea el
/// cuerpo de la respuesta (mismo criterio que `anular`, Sprint 9), así
/// que al éxito simplemente invalida `notificacionesProvider` — dispara
/// un `GET /notificaciones` real que trae el estado `leida` actualizado.
///
/// `autoDispose`: mismo motivo que el resto de los controllers de la
/// app — el estado de un intento no debe sobrevivir a la pantalla que lo
/// disparó.
class NotificacionMarcarLeidaController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> marcarLeida(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notificacionesRepositoryProvider).marcarLeida(id);
      ref.invalidate(notificacionesProvider);
    });
  }
}

final notificacionMarcarLeidaControllerProvider = AsyncNotifierProvider
    .autoDispose<NotificacionMarcarLeidaController, void>(
      NotificacionMarcarLeidaController.new,
    );
