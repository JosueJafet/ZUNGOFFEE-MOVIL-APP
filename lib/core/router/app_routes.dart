import 'package:go_router/go_router.dart';

import 'route_names.dart';
import 'route_paths.dart';
import 'screens/home_placeholder_screen.dart';
import 'screens/login_placeholder_screen.dart';
import 'screens/splash_placeholder_screen.dart';

/// Lista centralizada de rutas de la aplicacion.
///
/// Para agregar una ruta nueva (p. ej. la de un modulo en `features/`):
/// 1. Agrega su nombre en [RouteNames] y su path en [RoutePaths].
/// 2. Agrega una entrada a [routes] con esos dos valores.
/// `app_router.dart` no necesita cambios.
abstract final class AppRoutes {
  const AppRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      name: RouteNames.splash,
      path: RoutePaths.splash,
      builder: (context, state) => const SplashPlaceholderScreen(),
    ),
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      builder: (context, state) => const HomePlaceholderScreen(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginPlaceholderScreen(),
    ),
  ];
}
