import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/services/auth_providers.dart';
import 'core/services/supabase_bootstrap.dart';
import 'core/theme/app_theme.dart';

// NOTA: este archivo es únicamente el punto de ensamblaje de la
// aplicación (Supabase + theme + router). No contiene lógica de negocio
// ni de ningún módulo (feature).

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initialize();

  // `ProviderContainer` se crea a mano (en vez de dejar que `ProviderScope`
  // cree el suyo) para poder leer `authSessionServiceProvider` aquí mismo y
  // construir el router con la misma instancia que el resto de la app
  // obtendrá vía Riverpod — nunca una instancia separada "de main.dart".
  final container = ProviderContainer();

  // El router se construye una única vez aquí (nunca dentro de `build`,
  // para no perder el historial de navegación ni resuscribirse al
  // stream de auth en cada rebuild) y se pasa hacia abajo por
  // constructor.
  final router = AppRouter.build(container.read(authSessionServiceProvider));

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: ZungofeeApp(router: router),
    ),
  );
}

class ZungofeeApp extends StatelessWidget {
  const ZungofeeApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zungofee Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
