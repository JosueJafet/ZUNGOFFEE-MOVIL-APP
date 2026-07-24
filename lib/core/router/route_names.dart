/// Nombres de ruta usados con `GoRoute(name: ...)` y con navegacion
/// por nombre (`context.goNamed`, `context.pushNamed`).
///
/// Centralizar los nombres aqui evita strings repetidos/errores de tipeo
/// entre `app_routes.dart` y el codigo que navegue en el futuro.
abstract final class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String home = 'home';
  static const String login = 'login';
  static const String proveedores = 'proveedores';
  static const String proveedorFormulario = 'proveedorFormulario';
  static const String compraFormulario = 'compraFormulario';
  static const String existencias = 'existencias';
}
