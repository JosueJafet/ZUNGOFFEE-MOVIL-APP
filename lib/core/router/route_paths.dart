/// Paths de ruta usados con `GoRoute(path: ...)` y con navegacion por
/// ubicacion (`context.go`, `router.go`).
///
/// Centralizar los paths aqui evita strings repetidos/errores de tipeo
/// entre `app_routes.dart` y el codigo que navegue en el futuro.
abstract final class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
}
