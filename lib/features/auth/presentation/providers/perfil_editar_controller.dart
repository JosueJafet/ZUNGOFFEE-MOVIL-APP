import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'perfil_providers.dart';

/// Controla la edición del perfil (`PATCH /perfil`).
///
/// No actualiza el estado de forma optimista: el datasource no parsea
/// el cuerpo de la respuesta (mismo criterio que `anular`, Sprint 9, y
/// `marcarLeida`, Sprint 10), así que al éxito simplemente invalida
/// `perfilProvider` — dispara un `GET /perfil` real que trae el
/// `nombre` actualizado.
///
/// `autoDispose`: mismo motivo que el resto de los controllers de la
/// app — el estado de un intento no debe sobrevivir a la pantalla que lo
/// disparó.
class PerfilEditarController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> actualizar(String nombre) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(perfilRepositoryProvider).actualizar(nombre);
      ref.invalidate(perfilProvider);
    });
  }
}

final perfilEditarControllerProvider =
    AsyncNotifierProvider.autoDispose<PerfilEditarController, void>(
      PerfilEditarController.new,
    );
