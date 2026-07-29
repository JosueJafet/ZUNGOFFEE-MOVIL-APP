import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../../shared/widgets/snackbars/success_snackbar.dart';
import '../../../bodegas/data/models/bodega.dart';
import '../providers/pago_form_controller.dart';

/// Formulario de "Nuevo pago" (`POST /pagos`) para una bodega.
///
/// No importa `go_router` — invoca [onGuardado] cuando `registrar`
/// termina con éxito, igual que el resto de los formularios de la app.
class PagoFormScreen extends ConsumerStatefulWidget {
  const PagoFormScreen({super.key, required this.bodega, required this.onGuardado});

  final Bodega bodega;
  final VoidCallback onGuardado;

  @override
  ConsumerState<PagoFormScreen> createState() => _PagoFormScreenState();
}

class _PagoFormScreenState extends ConsumerState<PagoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();

  static final _formatoFecha = DateFormat('yyyy-MM-dd');

  DateTime? _periodo;
  DateTime? _fechaVencimiento;

  /// Solo tras un primer intento de guardar se muestran los mensajes de
  /// "selecciona una fecha" — igual que un `TextFormField` no muestra su
  /// error hasta la primera validación, para no recibir al usuario con
  /// mensajes de error antes de que haga nada.
  bool _intentoEnviar = false;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  String? _validateMonto(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa el monto';
    final monto = double.tryParse(texto);
    if (monto == null || monto <= 0) return 'Ingresa un monto válido';
    return null;
  }

  Future<void> _seleccionarFecha({required bool esVencimiento}) async {
    final ahora = DateTime.now();
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: DateTime(ahora.year - 1),
      lastDate: DateTime(ahora.year + 5),
    );
    if (seleccionada == null) return;
    setState(() {
      if (esVencimiento) {
        _fechaVencimiento = seleccionada;
      } else {
        _periodo = seleccionada;
      }
    });
  }

  Future<void> _submit() async {
    setState(() => _intentoEnviar = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_periodo == null || _fechaVencimiento == null) return;

    await ref
        .read(pagoFormControllerProvider.notifier)
        .registrar(
          tenantId: widget.bodega.id,
          periodo: _periodo!,
          monto: double.parse(_montoController.text.trim()),
          fechaVencimiento: _fechaVencimiento!,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(pagoFormControllerProvider, (previous, next) {
      // `next.hasValue` no sirve para detectar éxito: Riverpod preserva el
      // valor anterior en los estados de loading/error — mismo pitfall
      // documentado desde Sprint 5.
      if ((previous?.isLoading ?? false) && !next.hasError) {
        context.showSuccessSnackBar('Pago registrado con éxito.');
        widget.onGuardado();
      }
    });

    final formState = ref.watch(pagoFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Nuevo pago — ${widget.bodega.nombre}'),
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Periodo'),
                  subtitle: Text(
                    _periodo == null
                        ? 'Selecciona una fecha'
                        : _formatoFecha.format(_periodo!),
                  ),
                  onTap: isLoading
                      ? null
                      : () => _seleccionarFecha(esVencimiento: false),
                ),
                if (_intentoEnviar && _periodo == null)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.space4),
                    child: Text(
                      'Selecciona el periodo',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: AppSpacing.space4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Fecha de vencimiento'),
                  subtitle: Text(
                    _fechaVencimiento == null
                        ? 'Selecciona una fecha'
                        : _formatoFecha.format(_fechaVencimiento!),
                  ),
                  onTap: isLoading
                      ? null
                      : () => _seleccionarFecha(esVencimiento: true),
                ),
                if (_intentoEnviar && _fechaVencimiento == null)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.space4),
                    child: Text(
                      'Selecciona la fecha de vencimiento',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: AppSpacing.space4),
                TextFormField(
                  controller: _montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Monto'),
                  validator: _validateMonto,
                  enabled: !isLoading,
                ),
                if (formState.hasError) ...[
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    formState.error!.errorMessage(
                      fallback: 'No se pudo registrar el pago. Intenta de nuevo.',
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
