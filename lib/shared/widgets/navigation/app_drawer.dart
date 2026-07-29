import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_role.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/auth/presentation/providers/perfil_providers.dart';
import '../../../features/notificaciones/presentation/providers/notificaciones_providers.dart';
import '../brand/zungoffee_wordmark.dart';

/// Menú de navegación (drawer) reutilizado en todas las pantallas de la
/// app — no solo en Home, para poder saltar de un módulo a otro sin
/// volver antes a Home (pedido explícito del usuario).
///
/// Navega con `context.go` (no `context.push`): saltar de módulo en
/// módulo desde un menú persistente no debe apilar pantallas
/// indefinidamente, a diferencia de las acciones "crear"/"editar" que
/// cada pantalla sigue disparando con `context.push`.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  void _ir(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final perfil = perfilAsync.asData?.value;
    final esSuperAdmin = perfil?.rol == AppRole.superAdmin;
    final notificacionesAsync = ref.watch(notificacionesProvider);
    final tieneNotificacionesSinLeer =
        notificacionesAsync.asData?.value.any((n) => !n.leida) ?? false;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ZungoffeeWordmark(),
                  if (perfil != null) ...[
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      perfil.nombre,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(AppRole.etiquetaDe(perfil.rol)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Inicio'),
                    onTap: () => _ir(context, RoutePaths.home),
                  ),
                  if (esSuperAdmin)
                    ..._administracion(context)
                  else ...[
                    ..._inventario(context),
                    ..._comprasYVentas(context),
                    ..._produccion(context),
                  ],
                  ..._cuenta(context, tieneNotificacionesSinLeer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezado(BuildContext context, String emoji, String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space2,
      ),
      child: Text(
        '$emoji $titulo',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  List<Widget> _inventario(BuildContext context) => [
        _encabezado(context, '📦', 'Inventario'),
        ListTile(
          leading: const Icon(Icons.storefront),
          title: const Text('Proveedores'),
          onTap: () => _ir(context, RoutePaths.proveedores),
        ),
        ListTile(
          leading: const Icon(Icons.inventory_2_outlined),
          title: const Text('Ver existencias'),
          onTap: () => _ir(context, RoutePaths.existencias),
        ),
      ];

  List<Widget> _comprasYVentas(BuildContext context) => [
        _encabezado(context, '🛒', 'Compras y Ventas'),
        ListTile(
          leading: const Icon(Icons.shopping_cart_outlined),
          title: const Text('Registrar compra'),
          onTap: () => _ir(context, RoutePaths.compraFormulario),
        ),
        ListTile(
          leading: const Icon(Icons.people_outline),
          title: const Text('Clientes'),
          onTap: () => _ir(context, RoutePaths.clientes),
        ),
        ListTile(
          leading: const Icon(Icons.point_of_sale_outlined),
          title: const Text('Registrar venta'),
          onTap: () => _ir(context, RoutePaths.ventaFormulario),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Historial de compras'),
          onTap: () => _ir(context, RoutePaths.historialCompras),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Historial de ventas'),
          onTap: () => _ir(context, RoutePaths.historialVentas),
        ),
      ];

  List<Widget> _produccion(BuildContext context) => [
        _encabezado(context, '☕', 'Producción'),
        ListTile(
          leading: const Icon(Icons.local_fire_department_outlined),
          title: const Text('Procesar café'),
          onTap: () => _ir(context, RoutePaths.procesamientoFormulario),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Historial de procesamiento'),
          onTap: () => _ir(context, RoutePaths.historialProcesamiento),
        ),
      ];

  List<Widget> _administracion(BuildContext context) => [
        _encabezado(context, '🏢', 'Administración'),
        ListTile(
          leading: const Icon(Icons.apartment_outlined),
          title: const Text('Bodegas'),
          onTap: () => _ir(context, RoutePaths.bodegas),
        ),
        ListTile(
          leading: const Icon(Icons.inbox_outlined),
          title: const Text('Solicitudes'),
          onTap: () => _ir(context, RoutePaths.solicitudes),
        ),
        ListTile(
          leading: const Icon(Icons.payments_outlined),
          title: const Text('Pagos'),
          onTap: () => _ir(context, RoutePaths.pagos),
        ),
      ];

  List<Widget> _cuenta(BuildContext context, bool tieneNotificacionesSinLeer) =>
      [
        _encabezado(context, '👤', 'Cuenta'),
        ListTile(
          leading: Badge(
            isLabelVisible: tieneNotificacionesSinLeer,
            smallSize: 8,
            child: const Icon(Icons.notifications_outlined),
          ),
          title: const Text('Notificaciones'),
          onTap: () => _ir(context, RoutePaths.notificaciones),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Editar perfil'),
          onTap: () => _ir(context, RoutePaths.perfilEditar),
        ),
      ];
}
