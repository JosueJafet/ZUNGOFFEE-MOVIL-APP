import 'route_paths.dart';

/// Lógica pura de redirect según sesión: dado si hay una sesión activa y
/// a qué ruta se intenta navegar, decide si hay que redirigir a otra
/// parte (o dejar pasar la navegación).
///
/// Aislada de `GoRouter`/`AuthSessionService` a propósito, para poder
/// probar las 4 combinaciones posibles con valores simples (`bool`,
/// `String`), sin depender de Supabase ni de un `BuildContext` real.
abstract final class AuthRedirect {
  const AuthRedirect._();

  /// `null` significa "no redirigir, dejar pasar la navegación tal cual".
  ///
  /// Reglas (únicas rutas relevantes para el guard: todo lo que no sea
  /// login se considera protegido):
  /// - Sin sesión y no va a login → redirige a login.
  /// - Con sesión y va a login → redirige a home (no tiene sentido
  ///   mostrarle el login a alguien que ya inició sesión).
  /// - Cualquier otro caso → no redirige.
  static String? resolve({
    required bool isAuthenticated,
    required String location,
  }) {
    final isGoingToLogin = location == RoutePaths.login;

    if (!isAuthenticated && !isGoingToLogin) {
      return RoutePaths.login;
    }
    if (isAuthenticated && isGoingToLogin) {
      return RoutePaths.home;
    }
    return null;
  }
}
