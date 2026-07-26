import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../catalogos/presentation/providers/catalogos_providers.dart';
import '../../data/models/cliente.dart';
import '../providers/cliente_form_controller.dart';

/// Formulario de crear/editar cliente, reutilizado para ambos modos según
/// si recibe [clienteExistente]. Es un componente de UI puro: toda la
/// lógica de negocio (crear/actualizar, mapeo de errores de la API) vive
/// en [ClienteFormController]; esta pantalla solo arma el body de la
/// llamada y refleja su `AsyncValue<void>` — mismo patrón que
/// `ProveedorFormScreen` (Sprint 5), con la diferencia de que este
/// formulario sí espera un recurso async adicional (`catalogosProvider`)
/// para poblar el selector de `tipoId` (`clientesTipo`, Sprint 7).
///
/// No importa `go_router` ni llama `context.pop()` — invoca [onGuardado]
/// cuando el guardado termina con éxito, y quien la construya (Task 11)
/// decide qué hacer con eso.
class ClienteFormScreen extends ConsumerStatefulWidget {
  const ClienteFormScreen({
    super.key,
    this.clienteExistente,
    required this.onGuardado,
  });

  /// `null` = modo crear. No nulo = modo editar ese cliente.
  final Cliente? clienteExistente;

  /// Se invoca una única vez, cuando `crear`/`actualizar` termina con
  /// éxito.
  final VoidCallback onGuardado;

  @override
  ConsumerState<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends ConsumerState<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _lugarController;
  late final TextEditingController _telefonoController;
  int? _tipoId;

  bool get _esEdicion => widget.clienteExistente != null;

  @override
  void initState() {
    super.initState();
    final cliente = widget.clienteExistente;
    _nombreController = TextEditingController(text: cliente?.nombre ?? '');
    _lugarController = TextEditingController(text: cliente?.lugar ?? '');
    _telefonoController = TextEditingController(text: cliente?.telefono ?? '');
    _tipoId = cliente?.tipoId;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _lugarController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  String? _validateNombre(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ingresa el nombre';
    return null;
  }

  String? _nullIfEmpty(String value) =>
      value.trim().isEmpty ? null : value.trim();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final nombre = _nombreController.text.trim();
    final lugar = _nullIfEmpty(_lugarController.text);
    final telefono = _nullIfEmpty(_telefonoController.text);
    final controller = ref.read(clienteFormControllerProvider.notifier);

    if (_esEdicion) {
      await controller.actualizar(
        widget.clienteExistente!.id,
        nombre: nombre,
        tipoId: _tipoId,
        lugar: lugar,
        telefono: telefono,
      );
    } else {
      await controller.crear(
        nombre: nombre,
        tipoId: _tipoId,
        lugar: lugar,
        telefono: telefono,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(clienteFormControllerProvider, (
      previous,
      next,
    ) {
      // `next.hasValue` no sirve para detectar éxito: Riverpod preserva el
      // valor anterior en los estados de loading/error — lo único que
      // distingue un envío exitoso es la ausencia de error (Sprint 5,
      // Decisión arquitectónica #19).
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final catalogosAsync = ref.watch(catalogosProvider);
    final formState = ref.watch(clienteFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar cliente' : 'Agregar cliente'),
      ),
      body: SafeArea(
        child: catalogosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorRetryView(
            message: error.errorMessage(
              fallback: 'No se pudo guardar el cliente. Intenta de nuevo.',
            ),
            onRetry: () => ref.invalidate(catalogosProvider),
          ),
          data: (catalogos) => SingleChildScrollView(
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
                  const SizedBox(height: AppSpacing.space4),
                  DropdownButtonFormField<int?>(
                    initialValue: _tipoId,
                    decoration: const InputDecoration(labelText: 'Tipo de cliente'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Sin especificar'),
                      ),
                      ...catalogos.clientesTipo.map(
                        (tipo) => DropdownMenuItem(
                          value: tipo.id,
                          child: Text(tipo.nombre),
                        ),
                      ),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) => setState(() => _tipoId = value),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _lugarController,
                    decoration: const InputDecoration(labelText: 'Lugar'),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                    enabled: !isLoading,
                  ),
                  if (formState.hasError) ...[
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      formState.error!.errorMessage(
                        fallback: 'No se pudo guardar el cliente. Intenta de nuevo.',
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
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
          ),
        ),
      ),
    );
  }
}