import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bodega_providers.dart';

/// Controla suspender/activar una bodega (`PATCH
/// /pagos/tenant/:id/suspender`/`activar`).
///
/// No actualiza el ítem de forma optimista: el datasource no parsea el
/// cuerpo de la respuesta (ver `bodega_remote_datasource.dart`), así que
/// al éxito simplemente invalida `bodegasProvider` — mismo patrón que
/// `procesamiento_anular_controller.dart`.
///
/// `autoDispose`: mismo motivo que `BodegaFormController`.
class BodegaEstadoController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> suspender(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bodegaRepositoryProvider).suspender(id);
      ref.invalidate(bodegasProvider);
    });
  }

  Future<void> activar(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bodegaRepositoryProvider).activar(id);
      ref.invalidate(bodegasProvider);
    });
  }
}

final bodegaEstadoControllerProvider =
    AsyncNotifierProvider.autoDispose<BodegaEstadoController, void>(
      BodegaEstadoController.new,
    );
