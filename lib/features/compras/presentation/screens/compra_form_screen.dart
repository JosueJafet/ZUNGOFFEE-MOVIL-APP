import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/estado_cafe.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../catalogos/data/models/catalogos.dart';
import '../../../catalogos/data/models/estado_cafe_catalogo.dart';
import '../../../catalogos/data/models/nivel_altura.dart';
import '../../../catalogos/data/models/variedad_cafe.dart';
import '../../../catalogos/presentation/providers/catalogos_providers.dart';
import '../../../proveedores/data/models/proveedor.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import '../providers/compra_form_controller.dart';

/// Datos locales de una línea de compra en edición — no es un DTO ni un
/// modelo de dominio, solo el estado de un `Card` del formulario mientras
/// el usuario lo llena. Se convierte a [LineaCompraInput] recién al
/// enviar (`_submit`).
class _LineaFormData {
  _LineaFormData(this.id);

  final int id;
  int? estadoCafeId;
  int? variedadId;
  int? alturaId;
  final TextEditingController humedadController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController costoUnitarioController =
      TextEditingController();

  void dispose() {
    humedadController.dispose();
    cantidadController.dispose();
    costoUnitarioController.dispose();
  }
}

/// Formulario para registrar una compra con una o más líneas
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.3). Componente de UI puro
/// sobre `CompraFormController`: toda la lógica de negocio vive ahí, esta
/// pantalla solo arma el body de la llamada.
///
/// No importa `go_router` — igual que `ProveedorFormScreen` (Sprint 5),
/// invoca [onGuardado] cuando el registro termina con éxito; quien la
/// construya (Task 8) decide qué hacer con eso.
class CompraFormScreen extends ConsumerStatefulWidget {
  const CompraFormScreen({super.key, required this.onGuardado});

  final VoidCallback onGuardado;

  @override
  ConsumerState<CompraFormScreen> createState() => _CompraFormScreenState();
}

class _CompraFormScreenState extends ConsumerState<CompraFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _proveedorId;
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

  String? _validarProveedor(int? value) =>
      value == null ? 'Selecciona un proveedor' : null;

  String? _requerido(int? value) =>
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
      return LineaCompraInput(
        estadoCafeId: linea.estadoCafeId!,
        variedadId: linea.variedadId!,
        alturaId: linea.alturaId!,
        humedad: double.parse(linea.humedadController.text),
        cantidad: double.parse(linea.cantidadController.text),
        costoUnitario: double.parse(linea.costoUnitarioController.text),
      );
    }).toList();

    await ref
        .read(compraFormControllerProvider.notifier)
        .crear(
          proveedorId: _proveedorId!,
          metodoPagoId: _metodoPagoId,
          lineas: lineas,
        );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo registrar la compra. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo registrar la compra. Intenta de nuevo.';
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

  Widget _buildLinea(
    _LineaFormData linea,
    List<EstadoCafeCatalogo> estadosCafe,
    List<VariedadCafe> variedadesCafe,
    List<NivelAltura> nivelesAltura,
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
            DropdownButtonFormField<int>(
              key: Key('linea_${linea.id}_estado'),
              initialValue: linea.estadoCafeId,
              decoration: const InputDecoration(labelText: 'Estado del café'),
              items: estadosCafe
                  .map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.nombre)),
                  )
                  .toList(),
              validator: _requerido,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => linea.estadoCafeId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            DropdownButtonFormField<int>(
              key: Key('linea_${linea.id}_variedad'),
              initialValue: linea.variedadId,
              decoration: const InputDecoration(labelText: 'Variedad'),
              items: variedadesCafe
                  .map(
                    (v) => DropdownMenuItem(value: v.id, child: Text(v.nombre)),
                  )
                  .toList(),
              validator: _requerido,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => linea.variedadId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            DropdownButtonFormField<int>(
              key: Key('linea_${linea.id}_altura'),
              initialValue: linea.alturaId,
              decoration: const InputDecoration(labelText: 'Nivel de altura'),
              items: nivelesAltura
                  .map(
                    (n) => DropdownMenuItem(value: n.id, child: Text(n.nombre)),
                  )
                  .toList(),
              validator: _requerido,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => linea.alturaId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            TextFormField(
              key: Key('linea_${linea.id}_humedad'),
              controller: linea.humedadController,
              decoration: const InputDecoration(labelText: 'Humedad (%)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validarNumeroPositivo,
              enabled: !isLoading,
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
              key: Key('linea_${linea.id}_costoUnitario'),
              controller: linea.costoUnitarioController,
              decoration: const InputDecoration(labelText: 'Costo unitario'),
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
    List<Proveedor> proveedores,
    Catalogos catalogos,
    bool isLoading,
    AsyncValue<void> formState,
  ) {
    final estadosCafeValidos = catalogos.estadosCafe
        .where((e) => EstadoCafeId.compraValidos.contains(e.id))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              key: const Key('dropdown_proveedor'),
              initialValue: _proveedorId,
              decoration: const InputDecoration(labelText: 'Proveedor'),
              items: proveedores
                  .map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                  )
                  .toList(),
              validator: _validarProveedor,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() => _proveedorId = value),
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
              _buildLinea(
                linea,
                estadosCafeValidos,
                catalogos.variedadesCafe,
                catalogos.nivelesAltura,
                isLoading,
              ),
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
    ref.listen<AsyncValue<void>>(compraFormControllerProvider, (
      previous,
      next,
    ) {
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final proveedoresAsync = ref.watch(proveedoresProvider);
    final catalogosAsync = ref.watch(catalogosProvider);
    final formState = ref.watch(compraFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar compra')),
      body: SafeArea(
        child: proveedoresAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              _errorRetry(error, () => ref.invalidate(proveedoresProvider)),
          data: (proveedores) => catalogosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                _errorRetry(error, () => ref.invalidate(catalogosProvider)),
            data: (catalogos) =>
                _buildForm(proveedores, catalogos, isLoading, formState),
          ),
        ),
      ),
    );
  }
}
