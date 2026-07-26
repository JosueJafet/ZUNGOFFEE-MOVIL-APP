import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/venta.dart';
import '../providers/venta_anular_controller.dart';
import '../providers/ventas_providers.dart';

/// Historial de ventas (`GET /ventas`), con anulación (`PATCH
/// /ventas/:id/anular`) para `admin_bodega` — Sprint 9.
///
/// No importa `go_router` — mismo criterio que el resto de las pantallas
/// de listado (`ComprasHistorialScreen`, `ExistenciasListScreen`).
class VentasHistorialScreen extends ConsumerWidget {
  const VentasHistorialScreen({super.key});

  Future<void> _confirmarYAnular(
    BuildContext context,
    WidgetRef ref,
    Venta venta,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular venta'),
        content: Text(
          '¿Anular la venta #${venta.id}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Anular'),
          ),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;

    await ref.read(ventasAnularControllerProvider.notifier).anular(venta.id);

    final anularState = ref.read(ventasAnularControllerProvider);
    if (anularState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            anularState.error!.errorMessage(
              fallback: 'No se pudo anular la venta. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final ventasAsync = ref.watch(ventasHistorialProvider);
    final puedeAnular = perfilAsync.asData?.value.rol == AppRole.adminBodega;
    final anularEnCurso = ref.watch(ventasAnularControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: ventasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudo cargar el historial de ventas. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(ventasHistorialProvider),
        ),
        data: (ventas) {
          if (ventas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay ventas registradas',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: ventas.length,
            itemBuilder: (context, index) {
              final venta = ventas[index];
              return ListTile(
                title: Text('Venta #${venta.id}'),
                subtitle: venta.anulada ? const Text('Anulada') : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('L. ${venta.total.toStringAsFixed(2)}'),
                    if (puedeAnular && !venta.anulada)
                      TextButton(
                        onPressed: anularEnCurso
                            ? null
                            : () => _confirmarYAnular(context, ref, venta),
                        child: const Text('Anular'),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
