import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import 'ventas_providers.dart';

/// Controla la anulación de una venta (`PATCH /ventas/:id/anular`).
///
/// No actualiza el ítem anulado de forma optimista: el datasource no
/// parsea el cuerpo de la respuesta (Sprint 9, Decisión 5), así que al
/// éxito simplemente invalida `ventasHistorialProvider` — dispara un
/// `GET /ventas` real que trae el estado `anulada` actualizado — y
/// `existenciasProvider`, porque anular "siempre revierte saldo"
/// (sección 7) del lote vendido.
///
/// `autoDispose`: mismo motivo que `VentaFormController` — el estado de
/// un intento de anular no debe sobrevivir a la pantalla que lo disparó.
class VentasAnularController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> anular(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(ventasRepositoryProvider).anular(id);
      ref.invalidate(ventasHistorialProvider);
      ref.invalidate(existenciasProvider);
    });
  }
}

final ventasAnularControllerProvider =
    AsyncNotifierProvider.autoDispose<VentasAnularController, void>(
      VentasAnularController.new,
    );
