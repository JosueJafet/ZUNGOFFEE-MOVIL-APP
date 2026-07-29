import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../bodegas/data/models/bodega.dart';
import '../providers/pago_marcar_pagado_controller.dart';
import '../providers/pago_providers.dart';

/// Historial de pagos de una bodega (`GET /pagos/tenant/:tenantId`, solo
/// `super_admin`).
///
/// No importa `go_router`: igual que `BodegasListScreen`, la navegación
/// real ("Nuevo pago") la resuelve quien construya esta pantalla.
class PagoHistorialScreen extends ConsumerWidget {
  const PagoHistorialScreen({
    super.key,
    required this.bodega,
    required this.onNuevoPago,
  });

  final Bodega bodega;
  final VoidCallback onNuevoPago;

  static final _formatoFecha = DateFormat('yyyy-MM-dd');

  Future<void> _marcarPagado(BuildContext context, WidgetRef ref, int id) async {
    await ref
        .read(pagoMarcarPagadoControllerProvider.notifier)
        .marcarPagado(id, tenantId: bodega.id);

    final marcarState = ref.read(pagoMarcarPagadoControllerProvider);
    if (marcarState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            marcarState.error!.errorMessage(
              fallback: 'No se pudo marcar el pago como pagado. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagosAsync = ref.watch(pagosHistorialProvider(bodega.id));
    final marcarEnCurso = ref.watch(pagoMarcarPagadoControllerProvider).isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Pagos — ${bodega.nombre}'),
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
      body: pagosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudo cargar el historial de pagos. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(pagosHistorialProvider(bodega.id)),
        ),
        data: (pagos) {
          if (pagos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay pagos registrados',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              final pago = pagos[index];
              final pagado = pago.estadoCalculado == 'pagado';
              return ListTile(
                title: Text(_formatoFecha.format(pago.periodo)),
                subtitle: Text(
                  'Vence ${_formatoFecha.format(pago.fechaVencimiento)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'L. ${pago.monto.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: AppSpacing.space2),
                    Chip(
                      label: Text(pago.estadoCalculado),
                      visualDensity: VisualDensity.compact,
                    ),
                    if (!pagado) ...[
                      const SizedBox(width: AppSpacing.space2),
                      FilledButton(
                        onPressed: marcarEnCurso
                            ? null
                            : () => _marcarPagado(context, ref, pago.id),
                        child: const Text('Marcar como pagado'),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onNuevoPago,
        tooltip: 'Nuevo pago',
        child: const Icon(Icons.add),
      ),
    );
  }
}
