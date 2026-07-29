import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'solicitud_providers.dart';

/// Controla rechazar una solicitud (`PATCH
/// /solicitudes/:id/rechazar`).
///
/// No actualiza el ítem de forma optimista: el datasource no parsea el
/// cuerpo de la respuesta, así que al éxito simplemente invalida
/// `solicitudesProvider` — mismo patrón que
/// `BodegaEstadoController`/`procesamiento_anular_controller.dart`.
///
/// `autoDispose`: mismo motivo que el resto de los controllers de acción.
class SolicitudRechazarController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> rechazar(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(solicitudRepositoryProvider).rechazar(id);
      ref.invalidate(solicitudesProvider);
    });
  }
}

final solicitudRechazarControllerProvider =
    AsyncNotifierProvider.autoDispose<SolicitudRechazarController, void>(
      SolicitudRechazarController.new,
    );
