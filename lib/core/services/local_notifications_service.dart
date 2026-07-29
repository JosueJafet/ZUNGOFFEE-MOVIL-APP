import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Canal único para las notificaciones push mostradas en foreground —
/// mismo id/nombre siempre, Android lo crea una sola vez y lo reutiliza.
const _canalId = 'push_notificaciones';
const _canalNombre = 'Notificaciones';

/// Envuelve `flutter_local_notifications` (paquete externo) para
/// mostrar a mano las notificaciones que FCM no muestra solo con la app
/// en foreground (`CONTEXTO-PUSH-FCM-MOVIL.md`, sección 4) — mismo
/// criterio que `FcmService`/`FotoPickerService`.
class LocalNotificationsService {
  LocalNotificationsService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Crea el canal de Android y registra [onTap] para cuando el usuario
  /// toca una notificación local. Sin efecto fuera de Android — mismo
  /// guard que `FotoPickerService` usa para Windows Desktop en dev.
  Future<void> inicializar({
    required void Function(String? payload) onTap,
  }) async {
    if (!Platform.isAndroid) return;

    const androidChannel = AndroidNotificationChannel(
      _canalId,
      _canalNombre,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) => onTap(response.payload),
    );
  }

  /// Muestra una notificación nativa con [titulo]/[cuerpo] y [payload]
  /// (el `data` del push, ya serializado — ver `NotificacionPushHandler`).
  Future<void> mostrar({String? titulo, String? cuerpo, String? payload}) async {
    if (!Platform.isAndroid) return;

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: titulo,
      body: cuerpo,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _canalId,
          _canalNombre,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }
}
