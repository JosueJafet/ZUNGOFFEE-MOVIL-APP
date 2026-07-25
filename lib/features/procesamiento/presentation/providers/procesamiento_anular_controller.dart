import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import 'procesamiento_providers.dart';

/// Controla la anulación de un procesamiento (`PATCH
/// /procesamiento/:id/anular`).
///
/// No actualiza el ítem anulado de forma optimista: el datasource no
/// parsea el cuerpo de la respuesta (Sprint 9, Decisión 5), así que al
/// éxito simplemente invalida `procesamientoHistorialProvider` — dispara
/// un `GET /procesamiento` real — y `existenciasProvider`, porque anular
/// revierte el lote derivado que el procesamiento generó.
///
/// `autoDispose`: mismo motivo que `ProcesamientoFormController` — el
/// estado de un intento de anular no debe sobrevivir a la pantalla que lo
/// disparó.
class ProcesamientoAnularController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> anular(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(procesamientoRepositoryProvider).anular(id);
      ref.invalidate(procesamientoHistorialProvider);
      ref.invalidate(existenciasProvider);
    });
  }
}

final procesamientoAnularControllerProvider =
    AsyncNotifierProvider.autoDispose<ProcesamientoAnularController, void>(
      ProcesamientoAnularController.new,
    );
