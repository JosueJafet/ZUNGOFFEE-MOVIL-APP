import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../catalogos/data/models/catalogos.dart';
import '../../../catalogos/presentation/providers/catalogos_providers.dart';
import '../../../clientes/data/models/cliente.dart';
import '../../../clientes/presentation/providers/cliente_providers.dart';
import '../../../inventario/data/models/lote.dart';
import '../../../inventario/presentation/providers/lotes_providers.dart';
import '../../data/datasources/ventas_remote_datasource.dart';
import '../providers/venta_form_controller.dart';

/// Datos locales de una línea de venta en edición — no es un DTO ni un
/// modelo de dominio, solo el estado de un `Card` del formulario mientras
/// el usuario lo llena. Se convierte a [LineaVentaInput] recién al enviar
/// (`_submit`) — mismo patrón que `_LineaFormData` en `CompraFormScreen`
/// (Sprint 6).
class _LineaFormData {
  _LineaFormData(this.id);

  final int id;
  String? loteId;
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController precioUnitarioController =
      TextEditingController();

  void dispose() {
    cantidadController.dispose();
    precioUnitarioController.dispose();
  }
}

/// Formulario para registrar una venta con una o más líneas
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.5). Componente de UI puro sobre
/// `VentaFormController`: toda la lógica de negocio vive ahí, esta
/// pantalla solo arma el body de la llamada.
///
/// El selector de lote de cada línea reutiliza `existenciasProvider`
/// (`features/inventario`, ya construido en Sprint 6) sin duplicar esa
/// capa de datos (Sprint 7, alcance confirmado). No se filtra por estado
/// del café (Sprint 7, Decisión 2: la sección del contrato que documenta
/// `POST /ventas` no pide ese filtro, a diferencia de compras — la API es
/// el árbitro final).
///
/// No importa `go_router` — igual que `CompraFormScreen` (Sprint 6),
/// invoca [onGuardado] cuando el registro termina con éxito; quien la
/// construya (Task 11) decide qué hacer con eso.
class VentaFormScreen extends ConsumerStatefulWidget {
  const VentaFormScreen({super.key, required this.onGuardado});

  final VoidCallback onGuardado;

  @override
  ConsumerState<VentaFormScreen> createState() => _VentaFormScreenState();
}

class _VentaFormScreenState extends ConsumerState<VentaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _clienteId;
  int? _metodoPagoId;
  int _nextLineaId = 0;
  late List<_LineaFormData> _lineas;

  @override
  void initState() {
    super.initState();
    _lineas = [_nuevaLinea()];
  }

  _LineaFormData _nuevaLinea() => _LineaFormData(_nextLineaId++);

  @override
  void dispose() {
    for (final linea in _lineas) {
      linea.dispose();
    }
    super.dispose();
  }

  void _agregarLinea() => setState(() => _lineas.add(_nuevaLinea()));

  void _quitarLinea(_LineaFormData linea) {
    setState(() {
      linea.dispose();
      _lineas.remove(linea);
    });
  }

  String? _validarCliente(int? value) =>
      value == null ? 'Selecciona un cliente' : null;

  String? _requerido(String? value) =>
      value == null ? 'Selecciona una opción' : null;

  String? _validarNumeroPositivo(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) return 'Ingresa un número mayor a 0';
    return null;
  }

  Future<void> _submit() async {
    if (_lineas.isEmpty) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final lineas = _lineas.map((linea) {
      return LineaVentaInput(
        loteId: linea.loteId!,
        cantidad: double.parse(linea.cantidadController.text),
        precioUnitario: double.parse(linea.precioUnitarioController.text),
      );
    }).toList();

    await ref
        .read(ventaFormControllerProvider.notifier)
        .crear(clienteId: _clienteId!, metodoPagoId: _metodoPagoId, lineas: lineas);
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo registrar la venta. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo registrar la venta. Intenta de nuevo.';
  }

  Widget _errorRetry(Object error, VoidCallback onRetry) {
    return Center(
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
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  String _loteLabel(Lote lote) {
    return '${lote.estadoCafeNombre} · ${lote.variedadNombre} · '
        '${lote.nivelAlturaNombre} (saldo: ${lote.saldo.toStringAsFixed(2)})';
  }

  Widget _buildLinea(
    _LineaFormData linea,
    List<Lote> existencias,
    bool isLoading,
  ) {
    return Card(
      key: ValueKey('linea_${linea.id}'),
      margin: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              key: Key('linea_${linea.id}_lote'),
              initialValue: linea.loteId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Lote'),
              items: existencias
                  .map(
                    (lote) => DropdownMenuItem(
                      value: lote.id,
                      child: Text(
                        _loteLabel(lote),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              validator: _requerido,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => linea.loteId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            TextFormField(
              key: Key('linea_${linea.id}_cantidad'),
              controller: linea.cantidadController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validarNumeroPositivo,
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.space4),
            TextFormField(
              key: Key('linea_${linea.id}_precioUnitario'),
              controller: linea.precioUnitarioController,
              decoration: const InputDecoration(labelText: 'Precio unitario'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validarNumeroPositivo,
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.space2),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: Key('linea_${linea.id}_quitar'),
                onPressed: isLoading ? null : () => _quitarLinea(linea),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Quitar línea'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
    List<Cliente> clientes,
    Catalogos catalogos,
    List<Lote> existencias,
    bool isLoading,
    AsyncValue<void> formState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              key: const Key('dropdown_cliente'),
              initialValue: _clienteId,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: clientes
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)),
                  )
                  .toList(),
              validator: _validarCliente,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => _clienteId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            DropdownButtonFormField<int?>(
              key: const Key('dropdown_metodo_pago'),
              initialValue: _metodoPagoId,
              decoration: const InputDecoration(labelText: 'Método de pago'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Sin especificar'),
                ),
                ...catalogos.metodosPago.map(
                  (m) => DropdownMenuItem(value: m.id, child: Text(m.nombre)),
                ),
              ],
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => _metodoPagoId = value),
            ),
            const SizedBox(height: AppSpacing.space6),
            Text('Líneas', style: Theme.of(context).textTheme.titleMedium),
            if (_lineas.isEmpty) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(
                'Agrega al menos una línea',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: AppSpacing.space4),
            for (final linea in _lineas)
              _buildLinea(linea, existencias, isLoading),
            OutlinedButton.icon(
              key: const Key('boton_agregar_linea'),
              onPressed: isLoading ? null : _agregarLinea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar línea'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(ventaFormControllerProvider, (
      previous,
      next,
    ) {
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final clientesAsync = ref.watch(clientesProvider);
    final catalogosAsync = ref.watch(catalogosProvider);
    final existenciasAsync = ref.watch(existenciasProvider);
    final formState = ref.watch(ventaFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar venta')),
      body: SafeArea(
        child: clientesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              _errorRetry(error, () => ref.invalidate(clientesProvider)),
          data: (clientes) => catalogosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                _errorRetry(error, () => ref.invalidate(catalogosProvider)),
            data: (catalogos) => existenciasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _errorRetry(
                error,
                () => ref.invalidate(existenciasProvider),
              ),
              data: (existencias) => _buildForm(
                clientes,
                catalogos,
                existencias,
                isLoading,
                formState,
              ),
            ),
          ),
        ),
      ),
    );
  }
}