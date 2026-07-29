import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/cards/kpi_grid.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../bodegas/data/models/bodega.dart';
import '../../../bodegas/presentation/providers/bodega_providers.dart';
import '../providers/pago_providers.dart';

/// Resumen de pagos (`GET /pagos/resumen`, solo `super_admin`): KPIs de
/// bodegas activas/suspendidas e ingresos, más la lista de bodegas
/// (reutiliza `bodegasProvider`, ya cargado por `features/bodegas`) con
/// acceso al historial de pagos de cada una.
///
/// No importa `go_router`: igual que `BodegasListScreen`, la navegación
/// real la resuelve quien construya esta pantalla.
class PagosResumenScreen extends ConsumerWidget {
  const PagosResumenScreen({super.key, required this.onVerHistorial});

  final void Function(Bodega bodega) onVerHistorial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumenAsync = ref.watch(pagosResumenProvider);
    final bodegasAsync = ref.watch(bodegasProvider);

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Pagos'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menú',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            resumenAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.space6),
                  child: CircularProgressIndicator(),
                ),
              ),
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
                  (
                    'Ingresos del mes',
                    'L. ${resumen.ingresosMesActual.toStringAsFixed(2)}',
                  ),
                  (
                    'Ingresos totales',
                    'L. ${resumen.ingresosTotales.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space6),
            Text('Bodegas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.space2),
            bodegasAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.space6),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => ErrorRetryView(
                message: error.errorMessage(
                  fallback: 'No se pudieron cargar las bodegas. Intenta de nuevo.',
                ),
                onRetry: () => ref.invalidate(bodegasProvider),
              ),
              data: (bodegas) {
                if (bodegas.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.space4),
                    child: Text('No hay bodegas registradas'),
                  );
                }
                return Column(
                  children: bodegas
                      .map(
                        (bodega) => ListTile(
                          title: Text(bodega.nombre),
                          trailing: TextButton(
                            onPressed: () => onVerHistorial(bodega),
                            child: const Text('Ver historial de pagos'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
