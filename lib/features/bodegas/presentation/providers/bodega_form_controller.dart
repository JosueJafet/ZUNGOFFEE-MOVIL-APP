import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../solicitudes/presentation/providers/solicitud_providers.dart';
import 'bodega_providers.dart';

/// Controla el envío del formulario de crear/editar bodega. Expone
/// loading/error/success como `AsyncValue<void>`, mismo patrón que
/// `ProveedorFormController`.
///
/// `autoDispose`: el estado de un intento de crear/editar no debe
/// sobrevivir a la pantalla que lo disparó.
class BodegaFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// `solicitudId` no nulo cuando la bodega se crea desde una Solicitud
  /// pendiente (`features/solicitudes`) — al tener éxito, además de
  /// `bodegasProvider`, invalida `solicitudesProvider` porque esa
  /// Solicitud pasa a estar procesada.
  Future<void> crear({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(bodegaRepositoryProvider)
          .onboarding(
            nombreBodega: nombreBodega,
            emailAdmin: emailAdmin,
            passwordAdmin: passwordAdmin,
            nombreAdmin: nombreAdmin,
            solicitudId: solicitudId,
          );
      ref.invalidate(bodegasProvider);
      if (solicitudId != null) ref.invalidate(solicitudesProvider);
    });
  }

  Future<void> actualizarNombre(int id, {required String nombre}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bodegaRepositoryProvider).actualizarNombre(
        id,
        nombre: nombre,
      );
      ref.invalidate(bodegasProvider);
    });
  }
}

final bodegaFormControllerProvider =
    AsyncNotifierProvider.autoDispose<BodegaFormController, void>(
      BodegaFormController.new,
    );
