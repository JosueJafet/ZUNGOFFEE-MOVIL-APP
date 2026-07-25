import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';
import '../../data/models/cliente.dart';
import '../providers/cliente_providers.dart';

/// Lista de clientes (`GET /clientes`).
///
/// No importa `go_router`: igual que `ProveedoresListScreen` (Sprint 5),
/// la navegación real (crear/editar) la resuelve quien construya esta
/// pantalla — ver Task 11, que la conecta al `GoRouter` desde
/// `app_routes.dart`.
class ClientesListScreen extends ConsumerWidget {
  const ClientesListScreen({
    super.key,
    required this.onCrear,
    required this.onEditar,
  });

  /// Se invoca al tocar el botón de agregar. Todos los roles pueden crear.
  final VoidCallback onCrear;

  /// Se invoca al tocar un cliente de la lista. Solo se llega a invocar si
  /// el perfil actual es `admin_bodega` (ver [_puedeEditar]).
  final void Function(Cliente cliente) onEditar;

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudieron cargar los clientes. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudieron cargar los clientes. Intenta de nuevo.';
  }

  String? _subtitulo(Cliente cliente) {
    final partes = [
      cliente.lugar,
      cliente.telefono,
    ].where((parte) => parte != null && parte.isNotEmpty);
    return partes.isEmpty ? null : partes.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final clientesAsync = ref.watch(clientesProvider);
    final puedeEditar = perfilAsync.asData?.value.rol == AppRole.adminBodega;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: clientesAsync.when(
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
                  onPressed: () => ref.invalidate(clientesProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (clientes) {
          if (clientes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.space6),
                child: Text(
                  'No hay clientes registrados',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              final subtitulo = _subtitulo(cliente);
              return ListTile(
                title: Text(cliente.nombre),
                subtitle: subtitulo == null ? null : Text(subtitulo),
                onTap: puedeEditar ? () => onEditar(cliente) : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCrear,
        tooltip: 'Agregar cliente',
        child: const Icon(Icons.add),
      ),
    );
  }
}