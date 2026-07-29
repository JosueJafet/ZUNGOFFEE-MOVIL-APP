import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../data/models/solicitud.dart';
import '../providers/solicitud_providers.dart';
import '../providers/solicitud_rechazar_controller.dart';

/// Lista de solicitudes de acceso (`GET /solicitudes`, solo
/// `super_admin`).
///
/// No importa `go_router`: igual que `BodegasListScreen`, la navegación
/// real ("Crear bodega") la resuelve quien construya esta pantalla. Sin
/// FAB: las solicitudes las genera el formulario público de la landing,
/// no la app.
class SolicitudesListScreen extends ConsumerWidget {
  const SolicitudesListScreen({super.key, required this.onCrearBodega});

  final void Function(Solicitud solicitud) onCrearBodega;

  Future<void> _confirmarYRechazar(
    BuildContext context,
    WidgetRef ref,
    Solicitud solicitud,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: Text(
          '¿Rechazar la solicitud de "${solicitud.nombreBodega}"? Esta '
          'acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) return;

    await ref
        .read(solicitudRechazarControllerProvider.notifier)
        .rechazar(solicitud.id);

    final rechazarState = ref.read(solicitudRechazarControllerProvider);
    if (rechazarState.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            rechazarState.error!.errorMessage(
              fallback: 'No se pudo rechazar la solicitud. Intenta de nuevo.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solicitudesAsync = ref.watch(solicitudesProvider);
    final rechazarEnCurso = ref.watch(solicitudRechazarControllerProvider).isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Solicitudes'),
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
      body: solicitudesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudieron cargar las solicitudes. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(solicitudesProvider),
        ),
        data: (solicitudes) {
          if (solicitudes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay solicitudes registradas',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: solicitudes.length,
            itemBuilder: (context, index) {
              final solicitud = solicitudes[index];
              final mensaje = solicitud.mensaje;
              final telefono = solicitud.telefono;
              // El chip de estado va en `trailing` (ancho fijo, chico),
              // pero los botones de acción van en una fila propia debajo
              // — no en `trailing` junto al chip: con un `subtitle` largo
              // (contacto + email + teléfono + mensaje, todo concatenado)
              // y "Crear bodega" + el ícono de descartar sumados al chip,
              // `trailing` se vuelve tan ancho que en un celular real
              // aprieta la columna de título/subtítulo a un ancho casi
              // nulo, y el texto termina envuelto letra por letra.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(solicitud.nombreBodega),
                    subtitle: Text(
                      [
                        solicitud.nombreContacto,
                        solicitud.email,
                        if (telefono != null && telefono.isNotEmpty) telefono,
                        if (mensaje != null && mensaje.isNotEmpty) mensaje,
                      ].join(' · '),
                    ),
                    isThreeLine: mensaje != null && mensaje.isNotEmpty,
                    trailing: Chip(
                      label: Text(solicitud.estadoLabel),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  if (solicitud.pendiente)
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
                          FilledButton(
                            onPressed: () => onCrearBodega(solicitud),
                            child: const Text('Crear bodega'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.block),
                            tooltip: 'Descartar',
                            onPressed: rechazarEnCurso
                                ? null
                                : () => _confirmarYRechazar(context, ref, solicitud),
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
