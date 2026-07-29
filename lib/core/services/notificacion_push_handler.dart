import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notificaciones/presentation/providers/notificaciones_providers.dart';
import '../../features/notificaciones/presentation/utils/notificacion_push_router.dart';
import 'local_notifications_service.dart';

/// Único punto al que apuntan los 4 disparadores posibles de un push:
/// FCM en foreground, FCM tocada desde background
/// (`onMessageOpenedApp`), FCM tocada desde terminated
/// (`getInitialMessage`), y la notificación local (mostrada a mano en
/// foreground) tocada.
///
/// No depende de `GoRouter` directo — recibe [onNavegar] como callback
/// simple, así los tests le pasan una función que solo graba llamadas,
/// sin levantar un router real ni un widget tree.
class NotificacionPushHandler {
  NotificacionPushHandler({
    required this.onNavegar,
    required this.container,
    required this.localNotificationsService,
  });

  final void Function(String path) onNavegar;
  final ProviderContainer container;
  final LocalNotificationsService localNotificationsService;

  /// La app está en foreground: FCM no muestra nada solo en este
  /// estado — se muestra a mano y se refresca la bandeja in-app.
  Future<void> manejarMensajeEnPrimerPlano(RemoteMessage message) async {
    container.invalidate(notificacionesProvider);
    await localNotificationsService.mostrar(
      titulo: message.notification?.title,
      cuerpo: message.notification?.body,
      payload: jsonEncode(message.data),
    );
  }

  /// El usuario tocó una notificación (nativa de background/terminated,
  /// o la local mostrada en foreground) — navega según `data.tipo` y
  /// marca la notificación como leída, best-effort.
  void manejarTap(Map<String, dynamic> data) {
    final tipo = data['tipo'] as String?;
    final ruta = tipo == null ? null : rutaParaTipoNotificacion(tipo);
    if (ruta != null) onNavegar(ruta);

    final notificacionId = data['notificacionId'] as String?;
    if (notificacionId == null) return;
    container
        .read(notificacionesRepositoryProvider)
        .marcarLeida(notificacionId)
        .catchError((Object e) {
          debugPrint('No se pudo marcar la notificación como leída: $e');
        });
  }
}
