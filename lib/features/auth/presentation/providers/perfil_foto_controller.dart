import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'perfil_providers.dart';

/// Controla la subida (`POST /perfil/foto`) y el borrado
/// (`DELETE /perfil/foto`) de la foto de perfil.
///
/// A diferencia de [PerfilEditarController] (`PATCH /perfil`, que no trae
/// el cuerpo actualizado), acá ambas respuestas sí traen el `Perfil` con
/// `fotoUrl` ya actualizada (`null` tras un borrado) — igual se invalida
/// `perfilProvider` después del éxito, para que toda la app (Home,
/// drawer, etc.) lea la misma fuente y no quede una copia del perfil
/// desactualizada en otro lado.
///
/// `autoDispose`: mismo motivo que el resto de los controllers de la
/// app — el estado de un intento no debe sobrevivir a la pantalla que lo
/// disparó.
class PerfilFotoController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> subir({
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(perfilRepositoryProvider).subirFoto(
        bytes: bytes,
        nombreArchivo: nombreArchivo,
      );
      ref.invalidate(perfilProvider);
    });
  }

  Future<void> eliminar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(perfilRepositoryProvider).eliminarFoto();
      ref.invalidate(perfilProvider);
    });
  }
}

final perfilFotoControllerProvider =
    AsyncNotifierProvider.autoDispose<PerfilFotoController, void>(
      PerfilFotoController.new,
    );
