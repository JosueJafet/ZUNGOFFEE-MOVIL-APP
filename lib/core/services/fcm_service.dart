import 'package:firebase_messaging/firebase_messaging.dart';

/// Envuelve `firebase_messaging` (paquete externo) para que el resto de
/// la app dependa de un tipo propio, testeable sin tocar el platform
/// channel real — mismo criterio que `AuthSessionService` (Supabase) y
/// `FotoPickerService` (`image_picker`/`image_cropper`).
class FcmService {
  FcmService([FirebaseMessaging? messaging])
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// `true` si el usuario autorizó las notificaciones (autorización
  /// provisional cuenta como autorizada — en Android no existe ese
  /// estado, pero el mismo código sirve si algún día se agrega iOS).
  Future<bool> solicitarPermiso() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> obtenerToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Mensajes recibidos con la app en foreground — FCM no los muestra
  /// solo en este estado, hay que mostrarlos a mano
  /// (`LocalNotificationsService`).
  Stream<RemoteMessage> get onMensajeEnPrimerPlano => FirebaseMessaging.onMessage;

  /// El usuario tocó una notificación que el sistema operativo ya
  /// mostró solo (app en background).
  Stream<RemoteMessage> get onMensajeAbrioApp => FirebaseMessaging.onMessageOpenedApp;

  /// No nulo si la app arrancó desde cero porque el usuario tocó una
  /// notificación (app estaba terminated).
  Future<RemoteMessage?> obtenerMensajeInicial() => _messaging.getInitialMessage();
}
