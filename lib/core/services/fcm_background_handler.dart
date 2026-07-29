import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Handler de mensajes FCM con la app en background/terminated.
///
/// Requisito de `firebase_messaging`, no diseño propio: debe ser una
/// función top-level (nunca un método de clase ni una función anónima)
/// porque corre en un isolate separado, sin acceso al estado de la app.
/// `@pragma('vm:entry-point')` evita que el compilador la elimine por
/// "no usada" (nunca se la llama directo desde Dart, la invoca el SO).
///
/// No hace nada de negocio: en este estado el sistema operativo ya
/// muestra la notificación solo (`CONTEXTO-PUSH-FCM-MOVIL.md`, sección
/// 4) — el mapeo `data.tipo` → pantalla solo aplica cuando el usuario
/// toca la notificación, y eso pasa en el isolate principal
/// (`NotificacionPushHandler`), no acá.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Push recibido en background: ${message.messageId}');
}
