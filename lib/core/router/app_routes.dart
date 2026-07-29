import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/perfil_editar_screen.dart';
import '../../features/bodegas/data/models/bodega.dart';
import '../../features/bodegas/presentation/screens/bodega_form_screen.dart';
import '../../features/bodegas/presentation/screens/bodegas_list_screen.dart';
import '../../features/clientes/data/models/cliente.dart';
import '../../features/clientes/presentation/screens/cliente_form_screen.dart';
import '../../features/clientes/presentation/screens/clientes_list_screen.dart';
import '../../features/compras/presentation/screens/compra_form_screen.dart';
import '../../features/compras/presentation/screens/compras_historial_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/inventario/presentation/screens/existencias_list_screen.dart';
import '../../features/notificaciones/presentation/screens/notificaciones_list_screen.dart';
import '../../features/pagos/presentation/screens/pago_form_screen.dart';
import '../../features/pagos/presentation/screens/pago_historial_screen.dart';
import '../../features/pagos/presentation/screens/pagos_resumen_screen.dart';
import '../../features/proveedores/data/models/proveedor.dart';
import '../../features/proveedores/presentation/screens/proveedor_form_screen.dart';
import '../../features/procesamiento/presentation/screens/procesamiento_form_screen.dart';
import '../../features/procesamiento/presentation/screens/procesamiento_historial_screen.dart';
import '../../features/proveedores/presentation/screens/proveedores_list_screen.dart';
import '../../features/solicitudes/data/models/solicitud.dart';
import '../../features/solicitudes/presentation/screens/solicitudes_list_screen.dart';
import '../../features/ventas/presentation/screens/venta_form_screen.dart';
import '../../features/ventas/presentation/screens/ventas_historial_screen.dart';
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
      // `pageBuilder` en vez de `builder`: transición de fade suave al
      // entrar/salir (rediseño visual), sin tocar `path`/`name` ni a
      // dónde lleva la ruta.
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
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
    GoRoute(
      name: RouteNames.clientes,
      path: RoutePaths.clientes,
      // Misma navegación de la capa de routing que Proveedores (Sprint 5):
      // ClientesListScreen no importa go_router.
      builder: (context, state) => ClientesListScreen(
        onCrear: () => context.push(RoutePaths.clienteFormulario),
        onEditar: (cliente) =>
            context.push(RoutePaths.clienteFormulario, extra: cliente),
      ),
    ),
    GoRoute(
      name: RouteNames.clienteFormulario,
      path: RoutePaths.clienteFormulario,
      // `extra` es el `Cliente` a editar (modo editar) o `null` (modo
      // crear) — enviado por el `onEditar`/`onCrear` de arriba.
      builder: (context, state) => ClienteFormScreen(
        clienteExistente: state.extra as Cliente?,
        onGuardado: () => context.pop(),
      ),
    ),
    GoRoute(
      name: RouteNames.ventaFormulario,
      path: RoutePaths.ventaFormulario,
      builder: (context, state) =>
          VentaFormScreen(onGuardado: () => context.pop()),
    ),
    GoRoute(
      name: RouteNames.procesamientoFormulario,
      path: RoutePaths.procesamientoFormulario,
      builder: (context, state) =>
          ProcesamientoFormScreen(onGuardado: () => context.pop()),
    ),
    GoRoute(
      name: RouteNames.historialCompras,
      path: RoutePaths.historialCompras,
      // Solo lectura + anular in-place, sin callbacks — mismo criterio
      // que `ExistenciasListScreen` (Sprint 6).
      builder: (context, state) => const ComprasHistorialScreen(),
    ),
    GoRoute(
      name: RouteNames.historialVentas,
      path: RoutePaths.historialVentas,
      builder: (context, state) => const VentasHistorialScreen(),
    ),
    GoRoute(
      name: RouteNames.historialProcesamiento,
      path: RoutePaths.historialProcesamiento,
      builder: (context, state) => const ProcesamientoHistorialScreen(),
    ),
    GoRoute(
      name: RouteNames.notificaciones,
      path: RoutePaths.notificaciones,
      // Solo lectura + marcar-como-leída in-place, sin callbacks — mismo
      // criterio que las pantallas de historial (Sprint 9).
      builder: (context, state) => const NotificacionesListScreen(),
    ),
    GoRoute(
      name: RouteNames.perfilEditar,
      path: RoutePaths.perfilEditar,
      builder: (context, state) =>
          PerfilEditarScreen(onGuardado: () => context.pop()),
    ),
    GoRoute(
      name: RouteNames.bodegas,
      path: RoutePaths.bodegas,
      // Solo `super_admin` llega aquí (guard de rol, Sprint 14) — mismo
      // criterio de navegación que `proveedores`: la pantalla no importa
      // `go_router`.
      builder: (context, state) => BodegasListScreen(
        onCrear: () => context.push(RoutePaths.bodegaFormulario),
        onEditar: (bodega) =>
            context.push(RoutePaths.bodegaFormulario, extra: bodega),
      ),
    ),
    GoRoute(
      name: RouteNames.bodegaFormulario,
      path: RoutePaths.bodegaFormulario,
      // `extra` es la `Bodega` a editar (modo editar), la `Solicitud`
      // pendiente desde la que se crea (modo crear, prellenado — ver
      // `SolicitudesListScreen`) o `null` (modo crear, formulario en
      // blanco).
      builder: (context, state) => BodegaFormScreen(
        bodegaExistente: state.extra is Bodega ? state.extra as Bodega : null,
        solicitudOrigen:
            state.extra is Solicitud ? state.extra as Solicitud : null,
        onGuardado: () => context.pop(),
      ),
    ),
    GoRoute(
      name: RouteNames.solicitudes,
      path: RoutePaths.solicitudes,
      // Solo `super_admin` llega aquí (guard de rol, Sprint 14).
      builder: (context, state) => SolicitudesListScreen(
        onCrearBodega: (solicitud) =>
            context.push(RoutePaths.bodegaFormulario, extra: solicitud),
      ),
    ),
    GoRoute(
      name: RouteNames.pagos,
      path: RoutePaths.pagos,
      // Solo `super_admin` llega aquí (guard de rol, Sprint 14). Reutiliza
      // `bodegasProvider` de `features/bodegas` para listar las bodegas.
      builder: (context, state) => PagosResumenScreen(
        onVerHistorial: (bodega) =>
            context.push(RoutePaths.pagoHistorial, extra: bodega),
      ),
    ),
    GoRoute(
      name: RouteNames.pagoHistorial,
      path: RoutePaths.pagoHistorial,
      // `extra` es la `Bodega` cuyo historial se muestra — enviada por
      // `onVerHistorial` de arriba.
      builder: (context, state) => PagoHistorialScreen(
        bodega: state.extra as Bodega,
        onNuevoPago: () =>
            context.push(RoutePaths.pagoFormulario, extra: state.extra),
      ),
    ),
    GoRoute(
      name: RouteNames.pagoFormulario,
      path: RoutePaths.pagoFormulario,
      // `extra` es la `Bodega` para la que se registra el pago —
      // enviada por `onNuevoPago` de arriba.
      builder: (context, state) => PagoFormScreen(
        bodega: state.extra as Bodega,
        onGuardado: () => context.pop(),
      ),
    ),
  ];
}
