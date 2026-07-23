import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'proveedor_providers.dart';

/// Controla el envío del formulario de crear/editar proveedor. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 5) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `proveedoresProvider` para que la lista (Task 4) refleje el
/// cambio en su próxima lectura — mismo patrón de invalidación ya usado
/// en Sprint 4 para `perfilProvider`.
///
/// `autoDispose`: `ProveedorFormScreen` (Task 5) se monta una vez por
/// cada intento de crear/editar. Sin `autoDispose`, el estado de un envío
/// fallido (`AsyncError`) sobrevive al cerrar esa pantalla y se filtra a
/// la siguiente vez que se abre el formulario (probado con un test de
/// regresión antes de aplicar este fix).
class ProveedorFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> crear({
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(proveedorRepositoryProvider)
          .crear(nombre: nombre, sexo: sexo, lugar: lugar, finca: finca, telefono: telefono);
      ref.invalidate(proveedoresProvider);
    });
  }

  Future<void> actualizar(
    int id, {
    String? nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(proveedorRepositoryProvider)
          .actualizar(id, nombre: nombre, sexo: sexo, lugar: lugar, finca: finca, telefono: telefono);
      ref.invalidate(proveedoresProvider);
    });
  }
}

final proveedorFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ProveedorFormController, void>(
      ProveedorFormController.new,
    );
