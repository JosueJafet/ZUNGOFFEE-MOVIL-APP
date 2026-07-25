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
  static const String proveedores = '/proveedores';
  static const String proveedorFormulario = '/proveedores/formulario';
  static const String compraFormulario = '/compras/formulario';
  static const String existencias = '/inventario/existencias';
  static const String clientes = '/clientes';
  static const String clienteFormulario = '/clientes/formulario';
  static const String ventaFormulario = '/ventas/formulario';
  static const String procesamientoFormulario = '/procesamiento/formulario';
  static const String historialCompras = '/compras/historial';
  static const String historialVentas = '/ventas/historial';
  static const String historialProcesamiento = '/procesamiento/historial';
}
