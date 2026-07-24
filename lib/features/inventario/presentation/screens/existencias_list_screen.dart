import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
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

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudieron cargar las existencias. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudieron cargar las existencias. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existenciasAsync = ref.watch(existenciasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Existencias')),
      body: existenciasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage(error),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.space4),
                FilledButton(
                  onPressed: () => ref.invalidate(existenciasProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
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
