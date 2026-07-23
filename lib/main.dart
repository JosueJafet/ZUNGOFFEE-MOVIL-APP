import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/services/auth_session_service.dart';
import 'core/services/supabase_bootstrap.dart';
import 'core/theme/app_theme.dart';

// NOTA: este archivo es únicamente el punto de ensamblaje de la
// aplicación (Supabase + theme + router). No contiene lógica de negocio
// ni de ningún módulo (feature).

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initialize();

  // El router se construye una única vez aquí (nunca dentro de `build`,
  // para no perder el historial de navegación ni resuscribirse al
  // stream de auth en cada rebuild) y se pasa hacia abajo por
  // constructor.
  final authSessionService = AuthSessionService(Supabase.instance.client);
  final router = AppRouter.build(authSessionService);

  runApp(ProviderScope(child: ZungofeeApp(router: router)));
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
