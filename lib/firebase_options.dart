import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Opciones de Firebase para esta app — escritas a mano a partir de
/// `android/app/google-services.json` (Sprint 16, notificaciones push),
/// no generadas con `flutterfire configure`: ese comando necesita
/// loguearse con la cuenta de Google del proyecto, algo que no puede
/// hacerse fuera de una sesión interactiva del dueño de la cuenta.
///
/// Solo Android está soportado por ahora (`CONTEXTO-PUSH-FCM-MOVIL.md`)
/// — cualquier otra plataforma lanza `UnsupportedError` explícito en vez
/// de un valor inventado.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions no están configuradas para Web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configuradas para '
          '$defaultTargetPlatform — este proyecto solo soporta '
          'notificaciones push en Android por ahora.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNMT6vPNvJdpno-bvBSJXc7cBp2hNyVnc',
    appId: '1:388538426003:android:bd84c601b0ed5f7f882366',
    messagingSenderId: '388538426003',
    projectId: 'zungoffee',
    storageBucket: 'zungoffee.firebasestorage.app',
  );
}
