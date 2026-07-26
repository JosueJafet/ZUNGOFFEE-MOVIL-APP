import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/compra.dart';
import '../providers/compra_anular_controller.dart';
import '../providers/compras_providers.dart';

/// Historial de compras (`GET /compras`), con anulación (`PATCH
/// /compras/:id/anular`) para `admin_bodega` — Sprint 9.
///
/// No importa `go_router` — mismo criterio que el resto de las pantallas
/// de listado (`ExistenciasListScreen`, `ProveedoresListScreen`).
class ComprasHistorialScreen extends ConsumerWidget {
  const ComprasHistorialScreen({super.key});

  static final _formatoFecha = DateFormat('yyyy-MM-dd');

  Future<void> _confirmarYAnular(
    BuildContext context,
    WidgetRef ref,
    Compra compra,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular compra'),
        content: Text(
          '¿Anular la compra #${compra.id}? Esta acción no se puede deshacer.',
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

    await ref.read(comprasAnularControllerProvider.notifier).anular(compra.id);

    final anularState = ref.read(comprasAnularControllerProvider);
    if (anularState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            anularState.error!.errorMessage(
              fallback: 'No se pudo anular la compra. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final comprasAsync = ref.watch(comprasHistorialProvider);
    final puedeAnular = perfilAsync.asData?.value.rol == AppRole.adminBodega;
    final anularEnCurso = ref.watch(comprasAnularControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de compras')),
      body: comprasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudo cargar el historial de compras. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(comprasHistorialProvider),
        ),
        data: (compras) {
          if (compras.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay compras registradas',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compra = compras[index];
              return ListTile(
                title: Text('Compra #${compra.id}'),
                subtitle: Text(
                  '${_formatoFecha.format(compra.fecha)}'
                  '${compra.anulada ? ' · Anulada' : ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('L. ${compra.total.toStringAsFixed(2)}'),
                    if (puedeAnular && !compra.anulada)
                      TextButton(
                        onPressed: anularEnCurso
                            ? null
                            : () => _confirmarYAnular(context, ref, compra),
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
