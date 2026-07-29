import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/brand/zungoffee_wordmark.dart';
import '../../../../shared/widgets/cards/kpi_grid.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../auth/presentation/providers/logout_controller.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../../compras/presentation/providers/compras_providers.dart';
import '../../../inventario/data/models/lote.dart';
import '../../../inventario/presentation/providers/lotes_providers.dart';
import '../../../pagos/presentation/providers/pago_providers.dart';
import '../../../ventas/presentation/providers/ventas_providers.dart';

/// Pantalla real de inicio: dashboard de KPIs por rol, replicando el
/// alcance del panel web (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.1) —
/// `super_admin` ve KPIs de la plataforma (bodegas/ingresos, reutiliza
/// `pagosResumenProvider`), `admin_bodega`/`empleado` ven KPIs de su
/// bodega (compras/ventas de 30 días — solo `admin_bodega` — y lotes en
/// existencia) más una vista previa del inventario disponible. La
/// navegación a cada módulo vive en `AppDrawer` (Sprint 14) — Home ya no
/// es un launcher de módulos.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget _centeredLoading() => const Center(
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.space6),
      child: CircularProgressIndicator(),
    ),
  );

  /// KPIs + vista previa de inventario para `admin_bodega`/`empleado`.
  /// Compras/Ventas (30 días) solo aplican a `admin_bodega`
  /// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.1: "empleado: igual pero
  /// sin los KPIs de compras/ventas").
  Widget _bodyOperativo(BuildContext context, WidgetRef ref, bool esAdminBodega) {
    final existenciasAsync = ref.watch(existenciasProvider);

    Widget inventarioDisponible(List<Lote> existencias) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventario disponible',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () => context.push(RoutePaths.existencias),
                child: const Text('Ver todo'),
              ),
            ],
          ),
          if (existencias.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.space4),
              child: Text('No hay lotes con saldo disponible'),
            )
          else
            Column(
              children: existencias
                  .take(5)
                  .map(
                    (lote) => ListTile(
                      title: Text('Lote #${lote.id}'),
                      subtitle: Text(
                        '${lote.estadoCafeNombre} · '
                        '${lote.variedadNombre ?? 'Sin variedad'}',
                      ),
                      trailing: Text(lote.saldo.toStringAsFixed(2)),
                    ),
                  )
                  .toList(),
            ),
        ],
      );
    }

    return existenciasAsync.when(
      loading: _centeredLoading,
      error: (error, stackTrace) => ErrorRetryView(
        message: error.errorMessage(
          fallback: 'No se pudo cargar el inventario. Intenta de nuevo.',
        ),
        onRetry: () => ref.invalidate(existenciasProvider),
      ),
      data: (existencias) {
        if (!esAdminBodega) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KpiGrid(
                items: [('Lotes en existencia', '${existencias.length}')],
              ),
              inventarioDisponible(existencias),
            ],
          );
        }

        final comprasAsync = ref.watch(comprasResumenProvider);
        final ventasAsync = ref.watch(ventasResumenProvider);

        return comprasAsync.when(
          loading: _centeredLoading,
          error: (error, stackTrace) => ErrorRetryView(
            message: error.errorMessage(
              fallback: 'No se pudo cargar el resumen de compras. Intenta de nuevo.',
            ),
            onRetry: () => ref.invalidate(comprasResumenProvider),
          ),
          data: (compras) => ventasAsync.when(
            loading: _centeredLoading,
            error: (error, stackTrace) => ErrorRetryView(
              message: error.errorMessage(
                fallback: 'No se pudo cargar el resumen de ventas. Intenta de nuevo.',
              ),
              onRetry: () => ref.invalidate(ventasResumenProvider),
            ),
            data: (ventas) {
              // `_sum.total` de `GET /compras|ventas/resumen` no viene
              // agregado (es un total por fecha con actividad) — la
              // suma se calcula acá, del lado del cliente.
              final totalCompras = compras.fold<double>(
                0,
                (acc, r) => acc + r.total,
              );
              final totalVentas = ventas.fold<double>(
                0,
                (acc, r) => acc + r.total,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KpiGrid(
                    items: [
                      ('Compras (30 días)', 'L. ${totalCompras.toStringAsFixed(2)}'),
                      ('Ventas (30 días)', 'L. ${totalVentas.toStringAsFixed(2)}'),
                      ('Lotes en existencia', '${existencias.length}'),
                    ],
                  ),
                  inventarioDisponible(existencias),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _bodySuperAdmin(WidgetRef ref) {
    return ref.watch(pagosResumenProvider).when(
      loading: _centeredLoading,
      error: (error, stackTrace) => ErrorRetryView(
        message: error.errorMessage(
          fallback: 'No se pudo cargar el resumen. Intenta de nuevo.',
        ),
        onRetry: () => ref.invalidate(pagosResumenProvider),
      ),
      data: (resumen) => KpiGrid(
        items: [
          ('Bodegas activas', '${resumen.tenantsActivos}'),
          ('Bodegas suspendidas', '${resumen.tenantsSuspendidos}'),
          ('Ingresos del mes', 'L. ${resumen.ingresosMesActual.toStringAsFixed(2)}'),
          ('Ingresos totales', 'L. ${resumen.ingresosTotales.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final logoutAsync = ref.watch(logoutControllerProvider);

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const ZungoffeeWordmark(),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menú',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          if (logoutAsync.isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.space4),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () =>
                  ref.read(logoutControllerProvider.notifier).signOut(),
            ),
        ],
      ),
      // `SingleChildScrollView` (en vez de `Expanded` dentro de un
      // `Column` de altura fija): el contenido crece con cada módulo
      // nuevo y ya no entra siempre en el alto disponible — sin esto,
      // el `Expanded` desbordaba en vez de permitir hacer scroll.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Error de logout: se muestra inline (no en un SnackBar) para
            // no depender de un Timer real en los widget tests, y para
            // mantener el mismo patrón de error que ya usa el resto de la
            // pantalla y de LoginScreen.
            if (logoutAsync.hasError)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Text(
                  logoutAsync.error!.errorMessage(
                    fallback: 'No se pudo cargar tu perfil. Intenta de nuevo.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            perfilAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => ErrorRetryView(
                message: error.errorMessage(
                  fallback: 'No se pudo cargar tu perfil. Intenta de nuevo.',
                ),
                onRetry: () => ref.invalidate(perfilProvider),
              ),
              data: (perfil) {
                final esSuperAdmin = perfil.rol == AppRole.superAdmin;
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.space6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundImage: perfil.fotoUrl != null
                                ? NetworkImage(perfil.fotoUrl!)
                                : null,
                            child: perfil.fotoUrl == null
                                ? Text(
                                    perfil.nombre.isNotEmpty
                                        ? perfil.nombre[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppSpacing.space4),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenido, ${perfil.nombre}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppSpacing.space2),
                                Text(
                                  perfil.tenantNombre ?? 'Panel de administración',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space6),
                      esSuperAdmin
                          ? _bodySuperAdmin(ref)
                          : _bodyOperativo(
                              context,
                              ref,
                              perfil.rol == AppRole.adminBodega,
                            ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
