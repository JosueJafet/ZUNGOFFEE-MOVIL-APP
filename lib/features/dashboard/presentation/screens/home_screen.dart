import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/providers/perfil_providers.dart';

/// Pantalla real de inicio: muestra un mensaje de bienvenida con el
/// perfil del usuario autenticado (`GET /perfil`, `features/auth`).
///
/// No navega ni depende de `core/router/` — ver nota de arquitectura del
/// Sprint 4 (misma regla que ya sigue `features/auth`).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo cargar tu perfil. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo cargar tu perfil. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Zungo Coffee')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: perfilAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _errorMessage(error),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.space4),
                FilledButton(
                  onPressed: () => ref.invalidate(perfilProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
            data: (perfil) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bienvenido, ${perfil.nombre}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  perfil.tenantNombre,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
