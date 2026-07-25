import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cliente_providers.dart';

/// Controla el envío del formulario de crear/editar cliente. Expone
/// loading/error/success como `AsyncValue<void>` para que la pantalla
/// (Task 6) solo tenga que escuchar este estado. Al terminar con éxito,
/// invalida `clientesProvider` para que la lista (Task 5) refleje el
/// cambio en su próxima lectura — mismo patrón de invalidación que
/// `ProveedorFormController` (Sprint 5).
///
/// `autoDispose`: `ClienteFormScreen` (Task 6) se monta una vez por cada
/// intento de crear/editar. Sin `autoDispose`, el estado de un envío
/// fallido sobrevive al cerrar esa pantalla y se filtra a la siguiente vez
/// que se abre el formulario — mismo motivo exacto que
/// `ProveedorFormController` (Sprint 5).
class ClienteFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(clienteRepositoryProvider)
          .crear(nombre: nombre, tipoId: tipoId, lugar: lugar, telefono: telefono);
      ref.invalidate(clientesProvider);
    });
  }

  Future<void> actualizar(
    int id, {
    String? nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(clienteRepositoryProvider)
          .actualizar(id, nombre: nombre, tipoId: tipoId, lugar: lugar, telefono: telefono);
      ref.invalidate(clientesProvider);
    });
  }
}

final clienteFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ClienteFormController, void>(
      ClienteFormController.new,
    );