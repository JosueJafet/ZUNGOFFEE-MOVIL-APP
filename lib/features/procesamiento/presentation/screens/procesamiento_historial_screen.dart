import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/buttons/soft_destructive_button.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/procesamiento.dart';
import '../providers/procesamiento_anular_controller.dart';
import '../providers/procesamiento_providers.dart';

/// Historial de procesamiento (`GET /procesamiento`), con anulación
/// (`PATCH /procesamiento/:id/anular`) para `admin_bodega` — Sprint 9.
///
/// A diferencia de `ComprasHistorialScreen`/`VentasHistorialScreen`, el
/// botón "Anular" se muestra siempre (no se oculta por estado): el
/// contrato nunca confirma un campo `anulada` para este recurso, así que
/// `Procesamiento` no lo modela (Sprint 9, Decisión 4) — el `400` de la
/// API es el árbitro si el ítem ya estaba anulado.
///
/// No importa `go_router` — mismo criterio que el resto de las pantallas
/// de listado.
class ProcesamientoHistorialScreen extends ConsumerWidget {
  const ProcesamientoHistorialScreen({super.key});

  Future<void> _confirmarYAnular(
    BuildContext context,
    WidgetRef ref,
    Procesamiento procesamiento,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular procesamiento'),
        content: Text(
          '¿Anular el procesamiento #${procesamiento.id}? Esta acción no '
          'se puede deshacer.',
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

    await ref
        .read(procesamientoAnularControllerProvider.notifier)
        .anular(procesamiento.id);

    final anularState = ref.read(procesamientoAnularControllerProvider);
    if (anularState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            anularState.error!.errorMessage(
              fallback: 'No se pudo anular el procesamiento. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final procesamientosAsync = ref.watch(procesamientoHistorialProvider);
    final puedeAnular = perfilAsync.asData?.value.rol == AppRole.adminBodega;
    final anularEnCurso = ref
        .watch(procesamientoAnularControllerProvider)
        .isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Historial de procesamiento'),
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
      body: procesamientosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback:
                'No se pudo cargar el historial de procesamiento. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(procesamientoHistorialProvider),
        ),
        data: (procesamientos) {
          if (procesamientos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay procesamientos registrados',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: procesamientos.length,
            itemBuilder: (context, index) {
              final procesamiento = procesamientos[index];
              return ListTile(
                title: Text(
                  'Procesamiento #${procesamiento.id}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                subtitle: Text(
                  'Lote ${procesamiento.loteOrigenId} → '
                  '${procesamiento.loteDestinoId} · '
                  '${procesamiento.cantidadEntrada.toStringAsFixed(2)} → '
                  '${procesamiento.cantidadSalida.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                trailing: puedeAnular
                    ? SoftDestructiveButton(
                        onPressed: anularEnCurso
                            ? null
                            : () =>
                                  _confirmarYAnular(context, ref, procesamiento),
                        child: const Text('Anular'),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
