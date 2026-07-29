import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/services/auth_providers.dart';
import 'core/services/fcm_background_handler.dart';
import 'core/services/fcm_providers.dart';
import 'core/services/notificacion_push_handler.dart';
import 'core/services/supabase_bootstrap.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_providers.dart' as auth;
import 'features/auth/presentation/providers/perfil_providers.dart';
import 'features/notificaciones/presentation/providers/notificaciones_providers.dart';
import 'firebase_options.dart';

// NOTA: este archivo es únicamente el punto de ensamblaje de la
// aplicación (Supabase + Firebase + theme + router). No contiene lógica
// de negocio ni de ningún módulo (feature) — la lógica de qué hacer con
// un push vive en `NotificacionPushHandler`.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // `ProviderContainer` se crea a mano (en vez de dejar que `ProviderScope`
  // cree el suyo) para poder leer `authSessionServiceProvider` aquí mismo y
  // construir el router con la misma instancia que el resto de la app
  // obtendrá vía Riverpod — nunca una instancia separada "de main.dart".
  final container = ProviderContainer();

  // El router se construye una única vez aquí (nunca dentro de `build`,
  // para no perder el historial de navegación ni resuscribirse al
  // stream de auth en cada rebuild) y se pasa hacia abajo por
  // constructor.
  final router = AppRouter.build(
    container.read(authSessionServiceProvider),
    currentRol: () => container.read(perfilProvider).valueOrNull?.rol,
  );

  await _configurarNotificacionesPush(container, router);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: ZungofeeApp(router: router),
    ),
  );
}

/// Wiring de FCM: notificaciones locales, re-registro del token cuando
/// Firebase lo rota, y los 3 disparadores de "el usuario tocó el push"
/// (foreground, background, terminated) — todos delegan en
/// `NotificacionPushHandler`, único lugar con la lógica de qué hacer.
Future<void> _configurarNotificacionesPush(
  ProviderContainer container,
  GoRouter router,
) async {
  final fcmService = container.read(fcmServiceProvider);
  final localNotificationsService = container.read(
    localNotificationsServiceProvider,
  );
  final handler = NotificacionPushHandler(
    onNavegar: router.go,
    container: container,
    localNotificationsService: localNotificationsService,
  );

  await localNotificationsService.inicializar(
    onTap: (payload) {
      if (payload == null) return;
      handler.manejarTap(jsonDecode(payload) as Map<String, dynamic>);
    },
  );

  // Re-registra el token cuando Firebase lo rota — solo si hay sesión
  // activa (si no, no hay a quién asociarlo).
  fcmService.onTokenRefresh.listen((nuevoToken) {
    if (!container.read(auth.isAuthenticatedProvider)) return;
    container
        .read(notificacionesRepositoryProvider)
        .registrarDispositivo(token: nuevoToken, plataformaId: 2)
        .catchError((Object e) {
          debugPrint('No se pudo re-registrar el token FCM: $e');
        });
  });

  fcmService.onMensajeEnPrimerPlano.listen(handler.manejarMensajeEnPrimerPlano);
  fcmService.onMensajeAbrioApp.listen((message) => handler.manejarTap(message.data));

  final mensajeInicial = await fcmService.obtenerMensajeInicial();
  if (mensajeInicial != null) handler.manejarTap(mensajeInicial.data);
}

class ZungofeeApp extends StatelessWidget {
  const ZungofeeApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zungoffee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
