import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import '../../data/datasources/ventas_remote_datasource.dart';
import 'ventas_providers.dart';

/// Controla el envío del formulario de registrar venta. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 10) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `existenciasProvider` (`features/inventario`): una venta
/// reduce el saldo de los lotes vendidos, así que la lista de existencias,
/// si ya está cargada, debe reflejar el cambio en su próxima lectura —
/// mismo patrón de invalidación que `CompraFormController` (Sprint 6).
///
/// `autoDispose`: `VentaFormScreen` (Task 10) se monta una vez por cada
/// intento de registrar una venta. Sin `autoDispose`, el estado de un
/// envío fallido sobreviviría al cerrar esa pantalla y se filtraría a la
/// siguiente vez que se abre el formulario — mismo motivo exacto que
/// `CompraFormController` (Sprint 6).
class VentaFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(ventasRepositoryProvider)
          .crear(clienteId: clienteId, metodoPagoId: metodoPagoId, lineas: lineas);
      ref.invalidate(existenciasProvider);
    });
  }
}

final ventaFormControllerProvider =
    AsyncNotifierProvider.autoDispose<VentaFormController, void>(
      VentaFormController.new,
    );