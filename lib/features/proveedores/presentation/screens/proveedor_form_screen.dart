import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/proveedor.dart';
import '../providers/proveedor_form_controller.dart';

/// Formulario de crear/editar proveedor, reutilizado para ambos modos
/// según si recibe [proveedorExistente]. Es un componente de UI puro:
/// toda la lógica de negocio (crear/actualizar, mapeo de errores de la
/// API) vive en [ProveedorFormController]; esta pantalla solo arma el
/// body de la llamada y refleja su `AsyncValue<void>`.
///
/// No importa `go_router` ni llama `context.pop()` — igual que
/// `ProveedoresListScreen`, invoca [onGuardado] cuando el guardado
/// termina con éxito, y quien la construya (Task 6) decide qué hacer con
/// eso (`context.pop()` real desde el `GoRoute`).
class ProveedorFormScreen extends ConsumerStatefulWidget {
  const ProveedorFormScreen({
    super.key,
    this.proveedorExistente,
    required this.onGuardado,
  });

  /// `null` = modo crear. No nulo = modo editar ese proveedor.
  final Proveedor? proveedorExistente;

  /// Se invoca una única vez, cuando `crear`/`actualizar` termina con
  /// éxito.
  final VoidCallback onGuardado;

  @override
  ConsumerState<ProveedorFormScreen> createState() =>
      _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends ConsumerState<ProveedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _lugarController;
  late final TextEditingController _fincaController;
  late final TextEditingController _telefonoController;
  String? _sexo;

  bool get _esEdicion => widget.proveedorExistente != null;

  @override
  void initState() {
    super.initState();
    final proveedor = widget.proveedorExistente;
    _nombreController = TextEditingController(text: proveedor?.nombre ?? '');
    _lugarController = TextEditingController(text: proveedor?.lugar ?? '');
    _fincaController = TextEditingController(text: proveedor?.finca ?? '');
    _telefonoController = TextEditingController(
      text: proveedor?.telefono ?? '',
    );
    _sexo = proveedor?.sexo;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _lugarController.dispose();
    _fincaController.dispose();
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
    final finca = _nullIfEmpty(_fincaController.text);
    final telefono = _nullIfEmpty(_telefonoController.text);
    final controller = ref.read(proveedorFormControllerProvider.notifier);

    if (_esEdicion) {
      await controller.actualizar(
        widget.proveedorExistente!.id,
        nombre: nombre,
        sexo: _sexo,
        lugar: lugar,
        finca: finca,
        telefono: telefono,
      );
    } else {
      await controller.crear(
        nombre: nombre,
        sexo: _sexo,
        lugar: lugar,
        finca: finca,
        telefono: telefono,
      );
    }
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo guardar el proveedor. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo guardar el proveedor. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(proveedorFormControllerProvider, (
      previous,
      next,
    ) {
      // `next.hasValue` no sirve para detectar éxito: Riverpod preserva el
      // valor anterior en los estados de loading/error (para UIs "sin
      // parpadeo"), así que sigue en `true` incluso tras un error. Lo único
      // que distingue un envío exitoso es la ausencia de error.
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final formState = ref.watch(proveedorFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar proveedor' : 'Agregar proveedor'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                DropdownButtonFormField<String?>(
                  initialValue: _sexo,
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Sin especificar'),
                    ),
                    DropdownMenuItem(value: 'M', child: Text('M')),
                    DropdownMenuItem(value: 'F', child: Text('F')),
                  ],
                  onChanged: isLoading
                      ? null
                      : (value) => setState(() => _sexo = value),
                ),
                const SizedBox(height: AppSpacing.space4),
                TextFormField(
                  controller: _lugarController,
                  decoration: const InputDecoration(labelText: 'Lugar'),
                  enabled: !isLoading,
                ),
                const SizedBox(height: AppSpacing.space4),
                TextFormField(
                  controller: _fincaController,
                  decoration: const InputDecoration(labelText: 'Finca'),
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
                    _errorMessage(formState.error!),
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
    );
  }
}
