import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pago_providers.dart';

/// Controla el envío del formulario de "Nuevo pago" (`POST /pagos`).
/// Expone loading/error/success como `AsyncValue<void>`, mismo patrón
/// que `BodegaFormController`.
///
/// `autoDispose`: el estado de un intento de registrar no debe
/// sobrevivir a la pantalla que lo disparó.
class PagoFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> registrar({
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(pagoRepositoryProvider)
          .registrar(
            tenantId: tenantId,
            periodo: periodo,
            monto: monto,
            fechaVencimiento: fechaVencimiento,
          );
      ref.invalidate(pagosHistorialProvider(tenantId));
      ref.invalidate(pagosResumenProvider);
    });
  }
}

final pagoFormControllerProvider =
    AsyncNotifierProvider.autoDispose<PagoFormController, void>(
      PagoFormController.new,
    );
