import '../constants/app_role.dart';
import 'route_paths.dart';

/// Lógica pura de redirect según sesión y rol: dado si hay una sesión
/// activa, el rol del perfil (si ya se cargó) y a qué ruta se intenta
/// navegar, decide si hay que redirigir a otra parte (o dejar pasar la
/// navegación).
///
/// Aislada de `GoRouter`/`AuthSessionService` a propósito, para poder
/// probar todas las combinaciones con valores simples (`bool`, `String`),
/// sin depender de Supabase ni de un `BuildContext` real.
abstract final class AuthRedirect {
  const AuthRedirect._();

  /// Rutas de negocio por bodega — `super_admin` no ve ninguna
  /// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 2: "No ve proveedores,
  /// clientes, compras, ventas, inventario ni procesamiento").
  static const Set<String> _operationalPaths = {
    RoutePaths.proveedores,
    RoutePaths.proveedorFormulario,
    RoutePaths.compraFormulario,
    RoutePaths.existencias,
    RoutePaths.clientes,
    RoutePaths.clienteFormulario,
    RoutePaths.ventaFormulario,
    RoutePaths.procesamientoFormulario,
    RoutePaths.historialCompras,
    RoutePaths.historialVentas,
    RoutePaths.historialProcesamiento,
  };

  /// Rutas de administración de la plataforma — solo `super_admin` las
  /// ve (`CONTEXTO-PLATAFORMA-WEB.md`, secciones 8.12-8.14).
  static const Set<String> _superAdminOnlyPaths = {
    RoutePaths.bodegas,
    RoutePaths.bodegaFormulario,
    RoutePaths.solicitudes,
    RoutePaths.pagos,
    RoutePaths.pagoHistorial,
    RoutePaths.pagoFormulario,
  };

  /// `null` significa "no redirigir, dejar pasar la navegación tal cual".
  ///
  /// Reglas:
  /// - Sin sesión y no va a login → redirige a login.
  /// - Con sesión y va a login o al splash (`/`) → redirige a home (no
  ///   tiene sentido mostrarle el login a alguien que ya inició sesión,
  ///   ni dejarlo pegado en el splash — un usuario que vuelve a abrir la
  ///   app con la sesión de Supabase ya persistida entra directo acá en
  ///   frío, y sin esta regla se queda atascado ahí para siempre: `/`
  ///   no es `login` así que la regla de arriba no aplica, y ninguna
  ///   otra regla de abajo cubre "autenticado, en cualquier otra ruta").
  /// - Con sesión, rol conocido y va a una ruta operativa siendo
  ///   `super_admin` → redirige a home.
  /// - Con sesión, rol conocido y va a una ruta de administración sin
  ///   ser `super_admin` → redirige a home.
  /// - `rol` nulo (perfil aún no cargó) no bloquea nada — evita falsos
  ///   redirects mientras `GET /perfil` está en vuelo. `notificaciones`
  ///   y `perfilEditar` no están en ninguno de los dos sets: los 3
  ///   roles los ven (`CONTEXTO-PLATAFORMA-WEB.md`, sección 2).
  /// - Cualquier otro caso → no redirige.
  static String? resolve({
    required bool isAuthenticated,
    required String location,
    String? rol,
  }) {
    final isGoingToLogin = location == RoutePaths.login;
    final isAtSplash = location == RoutePaths.splash;

    if (!isAuthenticated && !isGoingToLogin) {
      return RoutePaths.login;
    }
    if (isAuthenticated && (isGoingToLogin || isAtSplash)) {
      return RoutePaths.home;
    }
    if (isAuthenticated && rol != null) {
      final esSuperAdmin = rol == AppRole.superAdmin;
      if (esSuperAdmin && _operationalPaths.contains(location)) {
        return RoutePaths.home;
      }
      if (!esSuperAdmin && _superAdminOnlyPaths.contains(location)) {
        return RoutePaths.home;
      }
    }
    return null;
  }
}
