import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/proveedor.dart';
import '../providers/proveedor_providers.dart';

/// Lista de proveedores (`GET /proveedores`).
///
/// No importa `go_router`: igual que `HomeScreen`, la navegación real
/// (crear/editar) la resuelve quien construya esta pantalla — ver Task 6,
/// que la conecta al `GoRouter` desde `app_routes.dart`. Esto la mantiene
/// testeable de forma aislada, sin necesitar un `GoRouter` real en los
/// widget tests.
class ProveedoresListScreen extends ConsumerWidget {
  const ProveedoresListScreen({
    super.key,
    required this.onCrear,
    required this.onEditar,
  });

  /// Se invoca al tocar el botón de agregar. Todos los roles pueden crear.
  final VoidCallback onCrear;

  /// Se invoca al tocar un proveedor de la lista. Solo se llega a invocar
  /// si el perfil actual es `admin_bodega` (ver [_puedeEditar]).
  final void Function(Proveedor proveedor) onEditar;

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudieron cargar los proveedores. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudieron cargar los proveedores. Intenta de nuevo.';
  }

  String? _subtitulo(Proveedor proveedor) {
    final partes = [
      proveedor.lugar,
      proveedor.finca,
      proveedor.telefono,
    ].where((parte) => parte != null && parte.isNotEmpty);
    return partes.isEmpty ? null : partes.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final proveedoresAsync = ref.watch(proveedoresProvider);
    final puedeEditar = perfilAsync.asData?.value.rol == AppRole.adminBodega;

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: proveedoresAsync.when(
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
                  onPressed: () => ref.invalidate(proveedoresProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (proveedores) {
          if (proveedores.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay proveedores registrados',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];
              final subtitulo = _subtitulo(proveedor);
              return ListTile(
                title: Text(proveedor.nombre),
                subtitle: subtitulo == null ? null : Text(subtitulo),
                onTap: puedeEditar ? () => onEditar(proveedor) : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCrear,
        tooltip: 'Agregar proveedor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
