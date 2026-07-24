import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import 'compras_providers.dart';

/// Controla el envío del formulario de registrar compra. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 7) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `existenciasProvider` (`features/inventario`): una compra
/// genera lotes nuevos, así que la lista de existencias, si ya está
/// cargada, debe reflejar el cambio en su próxima lectura — mismo patrón
/// de invalidación ya usado en Sprint 5 para `proveedoresProvider`.
///
/// `autoDispose`: `CompraFormScreen` (Task 7) se monta una vez por cada
/// intento de registrar una compra. Sin `autoDispose`, el estado de un
/// envío fallido sobreviviría al cerrar esa pantalla y se filtraría a la
/// siguiente vez que se abre el formulario — mismo motivo exacto que
/// `ProveedorFormController` en Sprint 5.
class CompraFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(comprasRepositoryProvider)
          .crear(proveedorId: proveedorId, metodoPagoId: metodoPagoId, lineas: lineas);
      ref.invalidate(existenciasProvider);
    });
  }
}

final compraFormControllerProvider =
    AsyncNotifierProvider.autoDispose<CompraFormController, void>(
      CompraFormController.new,
    );
