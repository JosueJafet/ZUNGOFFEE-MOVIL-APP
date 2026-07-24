import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/compras/presentation/screens/compra_form_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/inventario/presentation/screens/existencias_list_screen.dart';
import '../../features/proveedores/data/models/proveedor.dart';
import '../../features/proveedores/presentation/screens/proveedor_form_screen.dart';
import '../../features/proveedores/presentation/screens/proveedores_list_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';
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
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: RouteNames.proveedores,
      path: RoutePaths.proveedores,
      // La navegación de esta feature vive aquí, no en
      // `ProveedoresListScreen` (que no importa `go_router` — ver Sprint
      // 5, Task 4).
      builder: (context, state) => ProveedoresListScreen(
        onCrear: () => context.push(RoutePaths.proveedorFormulario),
        onEditar: (proveedor) => context.push(
          RoutePaths.proveedorFormulario,
          extra: proveedor,
        ),
      ),
    ),
    GoRoute(
      name: RouteNames.proveedorFormulario,
      path: RoutePaths.proveedorFormulario,
      // `extra` es el `Proveedor` a editar (modo editar) o `null` (modo
      // crear) — enviado por el `onEditar`/`onCrear` de arriba.
      builder: (context, state) => ProveedorFormScreen(
        proveedorExistente: state.extra as Proveedor?,
        onGuardado: () => context.pop(),
      ),
    ),
    GoRoute(
      name: RouteNames.compraFormulario,
      path: RoutePaths.compraFormulario,
      builder: (context, state) =>
          CompraFormScreen(onGuardado: () => context.pop()),
    ),
    GoRoute(
      name: RouteNames.existencias,
      path: RoutePaths.existencias,
      // Solo lectura, sin callbacks — ver Sprint 6, Task 6.
      builder: (context, state) => const ExistenciasListScreen(),
    ),
  ];
}
