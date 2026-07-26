import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../providers/lotes_providers.dart';

/// Lista de existencias actuales (`GET /lotes/existencias`) — primera
/// pantalla real de `features/inventario/`. Puramente de lectura: la API
/// no expone ninguna acción sobre un lote en este contrato (Sprint 6).
///
/// No importa `go_router` — igual que `ProveedoresListScreen` (Sprint 5),
/// la navegación real la resuelve quien construya esta pantalla desde
/// `app_routes.dart` (Task 8).
class ExistenciasListScreen extends ConsumerWidget {
  const ExistenciasListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existenciasAsync = ref.watch(existenciasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Existencias')),
      body: existenciasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorRetryView(
          message: error.errorMessage(
            fallback: 'No se pudieron cargar las existencias. Intenta de nuevo.',
          ),
          onRetry: () => ref.invalidate(existenciasProvider),
        ),
        data: (lotes) {
          if (lotes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay existencias registradas',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: lotes.length,
            itemBuilder: (context, index) {
              final lote = lotes[index];
              return ListTile(
                title: Text('${lote.variedadNombre} · ${lote.nivelAlturaNombre}'),
                subtitle: Text(lote.estadoCafeNombre),
                trailing: Text(lote.saldo.toStringAsFixed(2)),
              );
            },
          );
        },
      ),
    );
  }
}
