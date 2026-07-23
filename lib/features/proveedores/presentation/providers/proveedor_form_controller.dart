import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'proveedor_providers.dart';

/// Controla el envío del formulario de crear/editar proveedor. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 5) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `proveedoresProvider` para que la lista (Task 4) refleje el
/// cambio en su próxima lectura — mismo patrón de invalidación ya usado
/// en Sprint 4 para `perfilProvider`.
class ProveedorFormController extends AsyncNotifier<void> {
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
    AsyncNotifierProvider<ProveedorFormController, void>(
      ProveedorFormController.new,
    );
