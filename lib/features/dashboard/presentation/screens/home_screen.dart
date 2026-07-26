import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/providers/logout_controller.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';

/// Pantalla real de inicio: muestra un mensaje de bienvenida con el
/// perfil del usuario autenticado (`GET /perfil`, `features/auth`).
///
/// No depende del estado de sesión para navegar — la única redirección
/// por sesión sigue siendo la de `AppRouter` (Sprint 4). La entrada a
/// `features/proveedores` (Sprint 5, Task 6) es la primera excepción
/// deliberada a "no navega": un `context.push` disparado por una acción
/// real del usuario, no por un cambio de estado de sesión.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo cargar tu perfil. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo cargar tu perfil. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final logoutAsync = ref.watch(logoutControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zungo Coffee'),
        actions: [
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
      // `Column` de altura fija): la fila de botones crece con cada
      // módulo nuevo (van 10 desde Sprint 10) y ya no entra siempre en
      // el alto disponible — sin esto, el `Expanded` desbordaba en vez
      // de permitir hacer scroll.
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
                  _errorMessage(logoutAsync.error!),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space6),
              child: perfilAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage(error),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    FilledButton(
                      onPressed: () => ref.invalidate(perfilProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
                data: (perfil) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bienvenido, ${perfil.nombre}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      perfil.tenantNombre,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: context.appColors.mutedForeground),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.space4,
                runSpacing: AppSpacing.space2,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.proveedores),
                    icon: const Icon(Icons.storefront),
                    label: const Text('Proveedores'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.compraFormulario),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Registrar compra'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.existencias),
                    icon: const Icon(Icons.inventory_2_outlined),
                    label: const Text('Ver existencias'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.clientes),
                    icon: const Icon(Icons.people_outline),
                    label: const Text('Clientes'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.ventaFormulario),
                    icon: const Icon(Icons.point_of_sale_outlined),
                    label: const Text('Registrar venta'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        context.push(RoutePaths.procesamientoFormulario),
                    icon: const Icon(Icons.local_fire_department_outlined),
                    label: const Text('Procesar café'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.historialCompras),
                    icon: const Icon(Icons.history),
                    label: const Text('Historial de compras'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.historialVentas),
                    icon: const Icon(Icons.history),
                    label: const Text('Historial de ventas'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        context.push(RoutePaths.historialProcesamiento),
                    icon: const Icon(Icons.history),
                    label: const Text('Historial de procesamiento'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(RoutePaths.notificaciones),
                    icon: const Icon(Icons.notifications_outlined),
                    label: const Text('Notificaciones'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
