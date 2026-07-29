import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pago_providers.dart';

/// Controla marcar un pago como pagado (`PATCH
/// /pagos/:id/marcar-pagado`).
///
/// No actualiza el ítem de forma optimista: el datasource no parsea el
/// cuerpo de la respuesta (`estado_calculado` no viene en esa respuesta —
/// ver `pago_remote_datasource.dart`), así que al éxito simplemente
/// invalida `pagosHistorialProvider(tenantId)` — mismo patrón que
/// `BodegaEstadoController`/`procesamiento_anular_controller.dart`.
///
/// `autoDispose`: mismo motivo que el resto de los controllers de acción.
class PagoMarcarPagadoController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> marcarPagado(int id, {required int tenantId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(pagoRepositoryProvider).marcarPagado(id);
      ref.invalidate(pagosHistorialProvider(tenantId));
      ref.invalidate(pagosResumenProvider);
    });
  }
}

final pagoMarcarPagadoControllerProvider =
    AsyncNotifierProvider.autoDispose<PagoMarcarPagadoController, void>(
      PagoMarcarPagadoController.new,
    );
