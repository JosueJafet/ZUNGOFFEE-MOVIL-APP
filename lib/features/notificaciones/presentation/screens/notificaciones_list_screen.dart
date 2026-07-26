import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/notificacion.dart';
import '../providers/notificacion_marcar_leida_controller.dart';
import '../providers/notificaciones_providers.dart';

/// Bandeja de notificaciones (`GET /notificaciones`), con marcar-como-
/// leída (`PATCH /notificaciones/:id/leida`) — Sprint 10.
///
/// Sin gating por rol: ambos endpoints son "cualquiera" en el contrato,
/// a diferencia de `anular` en compras/ventas/procesamiento (Sprint 9).
/// Marcar como leída no es una acción destructiva, así que no pide
/// confirmación.
///
/// No importa `go_router` — mismo criterio que el resto de las pantallas
/// de listado.
class NotificacionesListScreen extends ConsumerWidget {
  const NotificacionesListScreen({super.key});

  String _errorMessage(Object error, {required String fallback}) {
    if (error is ApiException) {
      return error.message ?? fallback;
    }
    if (error is NetworkException) {
      return error.message;
    }
    return fallback;
  }

  Future<void> _marcarLeida(WidgetRef ref, Notificacion notificacion) async {
    if (notificacion.leida) return;
    await ref
        .read(notificacionMarcarLeidaControllerProvider.notifier)
        .marcarLeida(notificacion.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificacionesAsync = ref.watch(notificacionesProvider);

    ref.listen(notificacionMarcarLeidaControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _errorMessage(
                next.error!,
                fallback: 'No se pudo marcar la notificación como leída.',
              ),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: notificacionesAsync.when(
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
                        'No se pudieron cargar las notificaciones. Intenta de nuevo.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.space4),
                FilledButton(
                  onPressed: () => ref.invalidate(notificacionesProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (notificaciones) {
          if (notificaciones.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay notificaciones',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: notificaciones.length,
            itemBuilder: (context, index) {
              final notificacion = notificaciones[index];
              final fontWeight = notificacion.leida
                  ? FontWeight.normal
                  : FontWeight.bold;

              return ListTile(
                leading: notificacion.leida
                    ? null
                    : Icon(
                        Icons.circle,
                        size: 10,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                title: Text(
                  notificacion.titulo,
                  style: TextStyle(fontWeight: fontWeight),
                ),
                subtitle: Text(notificacion.mensaje),
                onTap: () => _marcarLeida(ref, notificacion),
              );
            },
          );
        },
      ),
    );
  }
}
