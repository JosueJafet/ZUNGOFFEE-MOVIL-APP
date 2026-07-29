import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/snackbars/success_snackbar.dart';
import '../../../solicitudes/data/models/solicitud.dart';
import '../../data/models/bodega.dart';
import '../providers/bodega_form_controller.dart';

/// Formulario de crear/editar bodega, reutilizado para ambos modos según
/// si recibe [bodegaExistente] — mismo patrón que `ProveedorFormScreen`.
///
/// Editar solo permite cambiar el nombre (`PATCH /tenants/:id`). Crear
/// da de alta la bodega y su admin en un solo paso (`POST
/// /tenants/onboarding`), por lo que pide más campos — si viene de una
/// Solicitud pendiente ([solicitudOrigen]), esos campos llegan
/// prellenados y el submit manda `solicitudId` para marcarla procesada.
class BodegaFormScreen extends ConsumerStatefulWidget {
  const BodegaFormScreen({
    super.key,
    this.bodegaExistente,
    this.solicitudOrigen,
    required this.onGuardado,
  });

  /// `null` = modo crear. No nulo = modo editar esa bodega.
  final Bodega? bodegaExistente;

  /// Solo aplica en modo crear (`bodegaExistente == null`): la Solicitud
  /// pendiente desde la que se creó esta bodega, si vino de
  /// `SolicitudesListScreen`.
  final Solicitud? solicitudOrigen;

  final VoidCallback onGuardado;

  @override
  ConsumerState<BodegaFormScreen> createState() => _BodegaFormScreenState();
}

class _BodegaFormScreenState extends ConsumerState<BodegaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _nombreAdminController;
  late final TextEditingController _emailAdminController;
  late final TextEditingController _passwordAdminController;

  bool _obscurePassword = true;

  bool get _esEdicion => widget.bodegaExistente != null;

  @override
  void initState() {
    super.initState();
    final solicitud = widget.solicitudOrigen;
    _nombreController = TextEditingController(
      text: widget.bodegaExistente?.nombre ?? solicitud?.nombreBodega ?? '',
    );
    _nombreAdminController = TextEditingController(
      text: solicitud?.nombreContacto ?? '',
    );
    _emailAdminController = TextEditingController(text: solicitud?.email ?? '');
    _passwordAdminController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _nombreAdminController.dispose();
    _emailAdminController.dispose();
    _passwordAdminController.dispose();
    super.dispose();
  }

  String? _validateNombre(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ingresa el nombre';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa el correo';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa la contraseña';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(bodegaFormControllerProvider.notifier);

    if (_esEdicion) {
      await controller.actualizarNombre(
        widget.bodegaExistente!.id,
        nombre: _nombreController.text.trim(),
      );
    } else {
      await controller.crear(
        nombreBodega: _nombreController.text.trim(),
        nombreAdmin: _nombreAdminController.text.trim(),
        emailAdmin: _emailAdminController.text.trim(),
        passwordAdmin: _passwordAdminController.text,
        solicitudId: widget.solicitudOrigen?.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(bodegaFormControllerProvider, (previous, next) {
      // `next.hasValue` no sirve para detectar éxito: Riverpod preserva el
      // valor anterior en los estados de loading/error — mismo pitfall
      // documentado desde Sprint 5.
      if ((previous?.isLoading ?? false) && !next.hasError) {
        context.showSuccessSnackBar(
          _esEdicion
              ? 'Bodega actualizada con éxito.'
              : 'Bodega creada con éxito.',
        );
        widget.onGuardado();
      }
    });

    final formState = ref.watch(bodegaFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar bodega' : 'Nueva bodega'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.solicitudOrigen?.telefono case final telefono?) ...[
                  Text(
                    'Teléfono de referencia: $telefono',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre de la bodega'),
                  validator: _validateNombre,
                  enabled: !isLoading,
                ),
                if (!_esEdicion) ...[
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _nombreAdminController,
                    decoration: const InputDecoration(labelText: 'Nombre del admin'),
                    validator: _validateNombre,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _emailAdminController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo del admin'),
                    validator: _validateEmail,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _passwordAdminController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña del admin',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        tooltip: _obscurePassword
                            ? 'Mostrar contraseña'
                            : 'Ocultar contraseña',
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: _validatePassword,
                    enabled: !isLoading,
                  ),
                ],
                if (formState.hasError) ...[
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    formState.error!.errorMessage(
                      fallback: 'No se pudo guardar la bodega. Intenta de nuevo.',
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
    );
  }
}
