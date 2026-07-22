import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'route_paths.dart';

/// Punto unico de acceso al [GoRouter] de la aplicacion.
///
/// El resto del proyecto (p. ej. `MaterialApp.router`) debe consumir
/// `AppRouter.router` en lugar de instanciar su propio `GoRouter`.
abstract final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: AppRoutes.routes,
  );
}
