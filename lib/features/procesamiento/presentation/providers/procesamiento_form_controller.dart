import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventario/presentation/providers/lotes_providers.dart';
import 'procesamiento_providers.dart';

/// Controla el envío del formulario de registrar procesamiento. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 4) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `existenciasProvider` (`features/inventario`): un
/// procesamiento reduce el saldo del lote origen y crea un lote nuevo
/// (destino), así que la lista de existencias, si ya está cargada, debe
/// reflejar el cambio en su próxima lectura — mismo patrón que
/// `CompraFormController`/`VentaFormController`.
///
/// `autoDispose`: `ProcesamientoFormScreen` (Task 4) se monta una vez por
/// cada intento de registrar un procesamiento. Sin `autoDispose`, el
/// estado de un envío fallido sobreviviría al cerrar esa pantalla y se
/// filtraría a la siguiente vez que se abre el formulario — mismo motivo
/// exacto que `CompraFormController`/`VentaFormController`.
class ProcesamientoFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(procesamientoRepositoryProvider)
          .crear(
            loteOrigenId: loteOrigenId,
            estadoDestinoId: estadoDestinoId,
            cantidadEntrada: cantidadEntrada,
            cantidadSalida: cantidadSalida,
          );
      ref.invalidate(existenciasProvider);
    });
  }
}

final procesamientoFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ProcesamientoFormController, void>(
      ProcesamientoFormController.new,
    );
