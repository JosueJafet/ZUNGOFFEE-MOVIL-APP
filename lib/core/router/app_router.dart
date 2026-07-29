import 'package:go_router/go_router.dart';

import '../services/auth_session_service.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';
import 'go_router_refresh_stream.dart';
import 'route_paths.dart';

/// Construye el [GoRouter] de la aplicación, protegido según la sesión
/// activa de [AuthSessionService] (Task 2 del Sprint 2).
///
/// En Sprint 1, `AppRouter` era un `static final` sin dependencias. Ahora
/// necesita saber si hay sesión activa para decidir sus redirects, así
/// que pasa a ser un builder: quien ensambla la app (bootstrap, próxima
/// tarea) decide cuándo construirlo, una vez que Supabase ya esté
/// inicializado — el resto de la arquitectura (`RouteNames`,
/// `RoutePaths`, `AppRoutes.routes`) no cambia.
abstract final class AppRouter {
  const AppRouter._();

  /// [currentRol] lee el rol del perfil ya cargado (o `null` si `GET
  /// /perfil` sigue en vuelo) de forma síncrona, para el guard de rol de
  /// [AuthRedirect]. Opcional: si se omite, el guard de rol simplemente
  /// no aplica (equivalente a que `currentRol` siempre devuelva `null`).
  static GoRouter build(
    AuthSessionService authSessionService, {
    String? Function()? currentRol,
  }) {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(
        authSessionService.onAuthStateChange,
      ),
      redirect: (context, state) => AuthRedirect.resolve(
        isAuthenticated: authSessionService.isAuthenticated,
        location: state.matchedLocation,
        rol: currentRol?.call(),
      ),
      routes: AppRoutes.routes,
    );
  }
}
