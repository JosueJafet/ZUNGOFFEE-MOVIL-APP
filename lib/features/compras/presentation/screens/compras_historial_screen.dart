import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
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

  String _errorMessage(Object error, {required String fallback}) {
    if (error is ApiException) {
      return error.message ?? fallback;
    }
    if (error is NetworkException) {
      return error.message;
    }
    return fallback;
  }

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
            _errorMessage(
              anularState.error!,
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
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage(
                    error,
                    fallback:
                        'No se pudo cargar el historial de compras. Intenta de nuevo.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.space4),
                FilledButton(
                  onPressed: () => ref.invalidate(comprasHistorialProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
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
