import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import 'compras_providers.dart';

/// Controla la anulación de una compra (`PATCH /compras/:id/anular`).
///
/// No actualiza el ítem anulado de forma optimista: el datasource no
/// parsea el cuerpo de la respuesta (Sprint 9, Decisión 5), así que al
/// éxito simplemente invalida `comprasHistorialProvider` — dispara un
/// `GET /compras` real que trae el estado `anulada` actualizado — y
/// `existenciasProvider`, porque anular revierte el/los lote(s) que la
/// compra generó.
///
/// `autoDispose`: mismo motivo que `CompraFormController` — el estado de
/// un intento de anular no debe sobrevivir a la pantalla que lo disparó.
class ComprasAnularController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> anular(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(comprasRepositoryProvider).anular(id);
      ref.invalidate(comprasHistorialProvider);
      ref.invalidate(existenciasProvider);
    });
  }
}

final comprasAnularControllerProvider =
    AsyncNotifierProvider.autoDispose<ComprasAnularController, void>(
      ComprasAnularController.new,
    );
