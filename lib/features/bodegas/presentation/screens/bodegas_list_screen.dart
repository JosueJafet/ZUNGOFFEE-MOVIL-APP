import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/buttons/soft_destructive_button.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../data/models/bodega.dart';
import '../providers/bodega_estado_controller.dart';
import '../providers/bodega_providers.dart';

/// Lista de bodegas (`GET /tenants`, solo `super_admin`).
///
/// No importa `go_router`: igual que `ProveedoresListScreen`, la
/// navegación real (crear/editar) la resuelve quien construya esta
/// pantalla.
class BodegasListScreen extends ConsumerWidget {
  const BodegasListScreen({
    super.key,
    required this.onCrear,
    required this.onEditar,
  });

  final VoidCallback onCrear;
  final void Function(Bodega bodega) onEditar;

  static final _formatoFecha = DateFormat('yyyy-MM-dd');

  Future<void> _confirmarYSuspender(
    BuildContext context,
    WidgetRef ref,
    Bodega bodega,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspender bodega'),
        content: Text(
          '¿Suspender "${bodega.nombre}"? Sus usuarios perderán acceso a '
          'la plataforma en su siguiente refresco de sesión.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Suspender'),
          ),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;

    await ref
        .read(bodegaEstadoControllerProvider.notifier)
        .suspender(bodega.id);

    final estadoState = ref.read(bodegaEstadoControllerProvider);
    if (estadoState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            estadoState.error!.errorMessage(
              fallback: 'No se pudo suspender la bodega. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _activar(
      BuildContext context, WidgetRef ref, Bodega bodega) async {
    await ref.read(bodegaEstadoControllerProvider.notifier).activar(bodega.id);

    final estadoState = ref.read(bodegaEstadoControllerProvider);
    if (estadoState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            estadoState.error!.errorMessage(
              fallback: 'No se pudo activar la bodega. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  /// Estado de suscripción de [bodega] — chip con `estadoPagoCalculado`
  /// (mismo criterio que `Pago.estadoCalculado`: se muestra tal cual,
  /// sin mapear a mayúsculas) más los días restantes, o el texto de
  /// "Sin ciclo de pago" si la bodega nunca registró uno
  /// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12).
  Widget _suscripcion(BuildContext context, Bodega bodega) {
    final estado = bodega.estadoPagoCalculado;
    if (estado == null) {
      return Text(
        'Sin ciclo de pago',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(label: Text(estado), visualDensity: VisualDensity.compact),
        if (bodega.diasRestantes != null) ...[
          const SizedBox(width: AppSpacing.space2),
          Text('${bodega.diasRestantes} días restantes'),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodegasAsync = ref.watch(bodegasProvider);
    final estadoEnCurso = ref.watch(bodegaEstadoControllerProvider).isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Bodegas'),
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
      body: bodegasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudieron cargar las bodegas. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(bodegasProvider),
        ),
        data: (bodegas) {
          if (bodegas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay bodegas registradas',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: bodegas.length,
            itemBuilder: (context, index) {
              final bodega = bodegas[index];
              // El chip de Activa/Suspendida se queda en `trailing` (ancho
              // fijo, chico), pero el estado de suscripción y el botón
              // de suspender/activar van en su propia fila debajo — mismo
              // fix que `SolicitudesListScreen`/`ComprasHistorialScreen`:
              // meter todo en `trailing` junto al nombre de la bodega
              // aprieta la columna de título a un ancho casi nulo en un
              // celular real. Esa fila usa `Wrap` (no `Row`) para que el
              // botón baje a su propia línea si el texto de días
              // restantes no entra, en vez de desbordar.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(bodega.nombre),
                    subtitle: Text(_formatoFecha.format(bodega.fechaRegistro)),
                    onTap: () => onEditar(bodega),
                    trailing: Chip(
                      label: Text(bodega.activa ? 'Activa' : 'Suspendida'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.space4,
                      0,
                      AppSpacing.space4,
                      AppSpacing.space2,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.space2,
                      runSpacing: AppSpacing.space2,
                      children: [
                        _suscripcion(context, bodega),
                        if (bodega.activa)
                          SoftDestructiveButton(
                            onPressed: estadoEnCurso
                                ? null
                                : () =>
                                    _confirmarYSuspender(context, ref, bodega),
                            child: const Text('Suspender'),
                          )
                        else
                          FilledButton(
                            onPressed: estadoEnCurso
                                ? null
                                : () => _activar(context, ref, bodega),
                            child: const Text('Activar'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: onCrear,
        tooltip: 'Nueva bodega',
        child: const Icon(Icons.add),
      ),
    );
  }
}
