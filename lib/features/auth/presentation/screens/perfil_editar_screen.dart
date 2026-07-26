import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../providers/perfil_editar_controller.dart';
import '../providers/perfil_providers.dart';

/// Formulario de editar perfil (`PATCH /perfil`, único campo editable:
/// `nombre`). A diferencia de `ProveedorFormScreen`/`ClienteFormScreen`,
/// no recibe la entidad por `extra:` — observa `perfilProvider`
/// directamente, que es la única fuente (no hay una lista previa que ya
/// lo haya cargado).
///
/// No importa `go_router` — invoca [onGuardado] cuando `actualizar`
/// termina con éxito, igual que el resto de los formularios de la app.
class PerfilEditarScreen extends ConsumerStatefulWidget {
  const PerfilEditarScreen({super.key, required this.onGuardado});

  final VoidCallback onGuardado;

  @override
  ConsumerState<PerfilEditarScreen> createState() =>
      _PerfilEditarScreenState();
}

class _PerfilEditarScreenState extends ConsumerState<PerfilEditarScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Nulo hasta que `perfilProvider` resuelve por primera vez — se
  /// inicializa una sola vez con `??=` para no pisar lo que el usuario
  /// ya haya escrito si `perfilProvider` se refresca por otro motivo
  /// mientras esta pantalla sigue abierta.
  TextEditingController? _nombreController;

  @override
  void dispose() {
    _nombreController?.dispose();
    super.dispose();
  }

  String? _validateNombre(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ingresa el nombre';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final nombre = _nombreController!.text.trim();
    await ref.read(perfilEditarControllerProvider.notifier).actualizar(nombre);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(perfilEditarControllerProvider, (
      previous,
      next,
    ) {
      // `next.hasValue` no sirve para detectar éxito: Riverpod preserva el
      // valor anterior en los estados de loading/error, así que sigue en
      // `true` incluso tras un error. Lo único que distingue un envío
      // exitoso es la ausencia de error (mismo pitfall documentado desde
      // Sprint 5).
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final perfilAsync = ref.watch(perfilProvider);
    final editarState = ref.watch(perfilEditarControllerProvider);
    final isLoading = editarState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: perfilAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorRetryView(
            message: error.errorMessage(
              fallback: 'No se pudo cargar tu perfil. Intenta de nuevo.',
            ),
            onRetry: () => ref.invalidate(perfilProvider),
          ),
          data: (perfil) {
            _nombreController ??= TextEditingController(text: perfil.nombre);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space6),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: _validateNombre,
                      enabled: !isLoading,
                    ),
                    if (editarState.hasError) ...[
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        editarState.error!.errorMessage(
                          fallback:
                              'No se pudo guardar el perfil. Intenta de nuevo.',
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.space6),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
