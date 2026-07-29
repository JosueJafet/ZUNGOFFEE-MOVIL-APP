import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/buttons/soft_destructive_button.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/venta_historial.dart';
import '../providers/venta_anular_controller.dart';
import '../providers/ventas_providers.dart';

/// Historial de ventas (`GET /ventas`), con anulación (`PATCH
/// /ventas/:id/anular`) para `admin_bodega` — Sprint 9.
///
/// No importa `go_router` — mismo criterio que el resto de las pantallas
/// de listado (`ComprasHistorialScreen`, `ExistenciasListScreen`).
class VentasHistorialScreen extends ConsumerWidget {
  const VentasHistorialScreen({super.key});

  static final _formatoFecha = DateFormat('yyyy-MM-dd');

  Future<void> _confirmarYAnular(
    BuildContext context,
    WidgetRef ref,
    VentaHistorial venta,
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
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Historial de ventas'),
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
      body: ventasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback:
                'No se pudo cargar el historial de ventas. Intenta de nuevo.',
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
              // Mismo fix que `ComprasHistorialScreen`: el botón "Anular"
              // se separa a su propia fila debajo en vez de compartir
              // `trailing` con el total, para no apretar la columna de
              // título/subtítulo en un celular real.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(
                      'Venta #${venta.id}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    subtitle: Text(
                      '${_formatoFecha.format(venta.fecha)} · '
                      '${venta.clienteNombre}',
                    ),
                    trailing: Text(
                      'L. ${venta.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  // La API de listado no trae `anulada` (gap reportado al
                  // backend) — se muestra siempre para admin_bodega; si ya
                  // estaba anulada, el backend rechaza con 400 y ese error
                  // ya se maneja igual que cualquier otro.
                  if (puedeAnular)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.space4,
                        0,
                        AppSpacing.space4,
                        AppSpacing.space2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SoftDestructiveButton(
                            onPressed: anularEnCurso
                                ? null
                                : () => _confirmarYAnular(context, ref, venta),
                            child: const Text('Anular'),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
