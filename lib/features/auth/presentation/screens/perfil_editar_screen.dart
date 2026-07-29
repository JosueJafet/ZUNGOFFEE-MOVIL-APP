import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_role.dart';
import '../../../../core/services/foto_picker_providers.dart';
import '../../../../core/services/foto_picker_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/empty_states/error_retry_view.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/snackbars/success_snackbar.dart';
import '../../../pagos/presentation/providers/pago_providers.dart';
import '../../../pagos/presentation/utils/suscripcion_calculo.dart';
import '../../data/models/perfil.dart';
import '../providers/perfil_editar_controller.dart';
import '../providers/perfil_foto_controller.dart';
import '../providers/perfil_providers.dart';

/// Opciones del selector estilo WhatsApp que abre el ícono de cámara del
/// avatar.
enum _AccionFoto { tomarFoto, elegirGaleria, eliminar }

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
  ConsumerState<PerfilEditarScreen> createState() => _PerfilEditarScreenState();
}

class _PerfilEditarScreenState extends ConsumerState<PerfilEditarScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Nulo hasta que `perfilProvider` resuelve por primera vez — se
  /// inicializa una sola vez con `??=` para no pisar lo que el usuario
  /// ya haya escrito si `perfilProvider` se refresca por otro motivo
  /// mientras esta pantalla sigue abierta.
  TextEditingController? _nombreController;

  /// Distingue, en el `ref.listen` de éxito, si el estado que acaba de
  /// resolver vino de subir o de eliminar — ambas acciones comparten
  /// `perfilFotoControllerProvider` (mismo `AsyncValue<void>`), así que
  /// no hay otra forma de elegir el mensaje correcto.
  bool _ultimaAccionFueEliminar = false;

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

  /// Abre el selector de opciones estilo WhatsApp (tomar foto / elegir
  /// de galería / eliminar) y ejecuta la acción elegida. Sin
  /// restricción de rol — cualquiera de los 3 roles puede gestionar la
  /// suya (`CONTEXTO-FOTO-PERFIL-MOVIL.md`).
  Future<void> _abrirOpcionesFoto(bool tieneFoto) async {
    final accion = await showModalBottomSheet<_AccionFoto>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.of(context).pop(_AccionFoto.tomarFoto),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () => Navigator.of(context).pop(_AccionFoto.elegirGaleria),
            ),
            if (tieneFoto)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Eliminar foto',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => Navigator.of(context).pop(_AccionFoto.eliminar),
              ),
          ],
        ),
      ),
    );
    if (accion == null || !mounted) return;

    switch (accion) {
      case _AccionFoto.tomarFoto:
        await _seleccionarYSubir(FuenteFoto.camara);
      case _AccionFoto.elegirGaleria:
        await _seleccionarYSubir(FuenteFoto.galeria);
      case _AccionFoto.eliminar:
        await _confirmarYEliminar();
    }
  }

  Future<void> _seleccionarYSubir(FuenteFoto fuente) async {
    final foto =
        await ref.read(fotoPickerServiceProvider).seleccionarYRecortar(fuente);
    if (foto == null || !mounted) return;

    _ultimaAccionFueEliminar = false;
    await ref
        .read(perfilFotoControllerProvider.notifier)
        .subir(bytes: foto.bytes, nombreArchivo: foto.nombreArchivo);
  }

  Future<void> _confirmarYEliminar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar foto de perfil'),
        content: const Text(
          '¿Eliminar tu foto de perfil? Vas a volver a ver el ícono con tu '
          'inicial.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    _ultimaAccionFueEliminar = true;
    await ref.read(perfilFotoControllerProvider.notifier).eliminar();
  }

  Widget _avatar(BuildContext context, Perfil perfil, bool subiendoFoto) {
    return Stack(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: perfil.fotoUrl != null
                    ? NetworkImage(perfil.fotoUrl!)
                    : null,
                child: perfil.fotoUrl == null
                    ? Text(
                        perfil.nombre.isNotEmpty
                            ? perfil.nombre[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      )
                    : null,
              ),
              if (subiendoFoto) const CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton.filled(
            icon: const Icon(Icons.camera_alt, size: 18),
            tooltip: 'Cambiar foto',
            onPressed: subiendoFoto
                ? null
                : () => _abrirOpcionesFoto(perfil.fotoUrl != null),
          ),
        ),
      ],
    );
  }

  /// Bloque de "Suscripción" — solo `admin_bodega` (`CONTEXTO-PLATAFORMA-WEB.md`,
  /// sección 8.15): estado (pendiente/pagado/vencido) y días restantes
  /// del ciclo de pago vigente de su propia bodega. `empleado` no lo ve
  /// (no necesita ni debe ver esto) y `super_admin` no pertenece a
  /// ninguna bodega — ninguno de los dos llega a llamar a este método.
  ///
  /// Reutiliza `pagosHistorialProvider` (`GET /pagos/tenant/:id`), el
  /// mismo endpoint que ya usa el detalle de bodega de `super_admin` —
  /// funciona igual para un `admin_bodega` autenticado sobre su propia
  /// bodega. El cálculo de días restantes vive en `calcularSuscripcion`,
  /// una función pura y testeable aparte (mismo criterio que
  /// `rutaParaTipoNotificacion`).
  Widget _suscripcion(BuildContext context, WidgetRef ref, int tenantId) {
    final pagosAsync = ref.watch(pagosHistorialProvider(tenantId));

    return pagosAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.space4),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
        child: Text(
          'No se pudo cargar el estado de la suscripción.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      data: (pagos) {
        final info = calcularSuscripcion(pagos);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suscripción',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.space2),
                if (info == null)
                  Text(
                    'Sin ciclo de pago registrado',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Row(
                    children: [
                      Chip(
                        label: Text(info.estado),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: AppSpacing.space2),
                      Text('${info.diasRestantes} días restantes'),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
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
        context.showSuccessSnackBar('Perfil actualizado con éxito.');
        widget.onGuardado();
      }
    });

    ref.listen<AsyncValue<void>>(perfilFotoControllerProvider, (
      previous,
      next,
    ) {
      if ((previous?.isLoading ?? false) && !next.hasError) {
        context.showSuccessSnackBar(
          _ultimaAccionFueEliminar
              ? 'Foto de perfil eliminada.'
              : 'Foto de perfil actualizada.',
        );
      }
    });

    final perfilAsync = ref.watch(perfilProvider);
    final editarState = ref.watch(perfilEditarControllerProvider);
    final fotoState = ref.watch(perfilFotoControllerProvider);
    final isLoading = editarState.isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Editar perfil'),
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
                    Center(
                      child: _avatar(context, perfil, fotoState.isLoading),
                    ),
                    if (fotoState.hasError) ...[
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        fotoState.error!.errorMessage(
                          fallback:
                              'No se pudo subir la foto. Intenta de nuevo.',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (perfil.rol == AppRole.adminBodega &&
                        perfil.tenantId != null) ...[
                      const SizedBox(height: AppSpacing.space6),
                      _suscripcion(context, ref, perfil.tenantId!),
                    ],
                    const SizedBox(height: AppSpacing.space6),
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
