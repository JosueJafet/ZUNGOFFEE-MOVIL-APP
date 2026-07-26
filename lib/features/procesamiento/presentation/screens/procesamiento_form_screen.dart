import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/estado_cafe.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/async_value_view_extension.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../catalogos/data/models/estado_cafe_catalogo.dart';
import '../../../catalogos/presentation/providers/catalogos_providers.dart';
import '../../../inventario/data/models/lote.dart';
import '../../../inventario/presentation/providers/lotes_providers.dart';
import '../providers/procesamiento_form_controller.dart';

/// Todos los `estadoDestinoId` posibles del catálogo — los 3 niveles de
/// tostado más molido (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.6). Se usa
/// solo para calcular, por cada estado de origen, cuáles de estos son
/// destinos válidos vía `EstadoCafeTransiciones.esValida` — sin tocar
/// `core/constants/estado_cafe.dart` (Sprint 2, ya cerrado).
const _todosLosDestinosPosibles = [...EstadoCafeId.tostado, EstadoCafeId.molido];

/// Formulario para registrar un procesamiento (tostar/moler) — una
/// transformación de **un lote origen a un lote destino**, sin líneas
/// dinámicas (a diferencia de `CompraFormScreen`/`VentaFormScreen`).
/// Componente de UI puro sobre `ProcesamientoFormController`: toda la
/// lógica de negocio vive ahí, esta pantalla solo arma el body de la
/// llamada.
///
/// El selector de lote origen reutiliza `existenciasProvider`
/// (`features/inventario`, Sprint 6) filtrado a los lotes que sí tienen
/// alguna transición válida — cruzando `Lote.estadoCafeNombre` contra
/// `catalogosProvider.estadosCafe` (que sí trae `id`) y validando con
/// `EstadoCafeTransiciones.esValida` (Sprint 2, sin usar hasta este
/// sprint). El selector de estado destino solo lista las opciones
/// válidas para el origen elegido (Sprint 8, Decisión 1).
///
/// No importa `go_router` — igual que `CompraFormScreen`/`VentaFormScreen`,
/// invoca [onGuardado] cuando el registro termina con éxito.
class ProcesamientoFormScreen extends ConsumerStatefulWidget {
  const ProcesamientoFormScreen({super.key, required this.onGuardado});

  final VoidCallback onGuardado;

  @override
  ConsumerState<ProcesamientoFormScreen> createState() =>
      _ProcesamientoFormScreenState();
}

class _ProcesamientoFormScreenState
    extends ConsumerState<ProcesamientoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _loteOrigenId;
  int? _estadoDestinoId;
  final _cantidadEntradaController = TextEditingController();
  final _cantidadSalidaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Recalcula el indicador de rendimiento en vivo mientras el usuario
    // escribe — solo apoyo visual, no valida ni bloquea el submit.
    _cantidadEntradaController.addListener(_onCantidadesChanged);
    _cantidadSalidaController.addListener(_onCantidadesChanged);
  }

  void _onCantidadesChanged() => setState(() {});

  @override
  void dispose() {
    _cantidadEntradaController.dispose();
    _cantidadSalidaController.dispose();
    super.dispose();
  }

  /// El id numérico del estado de [lote], cruzando su nombre contra
  /// `catalogos.estadosCafe` (Sprint 8, Decisión 1) — `Lote` (Sprint 6)
  /// solo guarda el nombre, no el id.
  int? _estadoIdDeLote(Lote lote, List<EstadoCafeCatalogo> estadosCafe) {
    for (final estado in estadosCafe) {
      if (estado.nombre == lote.estadoCafeNombre) return estado.id;
    }
    return null;
  }

  List<int> _destinosValidosPara(int origenId) {
    return _todosLosDestinosPosibles
        .where(
          (destinoId) =>
              EstadoCafeTransiciones.esValida(
                origenId: origenId,
                destinoId: destinoId,
              ),
        )
        .toList();
  }

  String? _requeridoLote(String? value) =>
      value == null ? 'Selecciona un lote' : null;

  String? _requeridoDestino(int? value) =>
      value == null ? 'Selecciona un destino' : null;

  String? _validarNumeroPositivo(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) return 'Ingresa un número mayor a 0';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(procesamientoFormControllerProvider.notifier)
        .crear(
          loteOrigenId: _loteOrigenId!,
          estadoDestinoId: _estadoDestinoId!,
          cantidadEntrada: double.parse(_cantidadEntradaController.text),
          cantidadSalida: double.parse(_cantidadSalidaController.text),
        );
  }

  static const _errorFallback =
      'No se pudo registrar el procesamiento. Intenta de nuevo.';

  String _loteLabel(Lote lote) {
    return '${lote.estadoCafeNombre} · ${lote.variedadNombre} · '
        '${lote.nivelAlturaNombre} (saldo: ${lote.saldo.toStringAsFixed(2)})';
  }

  /// `null` si no hay suficiente información para calcular un porcentaje
  /// (algún campo vacío, no numérico, o entrada en 0) — el indicador
  /// simplemente no se muestra en ese caso.
  double? get _rendimientoPorcentaje {
    final entrada = double.tryParse(_cantidadEntradaController.text);
    final salida = double.tryParse(_cantidadSalidaController.text);
    if (entrada == null || salida == null || entrada <= 0) return null;
    return (salida / entrada) * 100;
  }

  Widget _buildForm(
    List<Lote> existencias,
    List<EstadoCafeCatalogo> estadosCafe,
    bool isLoading,
    AsyncValue<void> formState,
  ) {
    final lotesOrigenValidos = existencias.where((lote) {
      final estadoId = _estadoIdDeLote(lote, estadosCafe);
      return estadoId != null && _destinosValidosPara(estadoId).isNotEmpty;
    }).toList();

    final origenSeleccionado = _loteOrigenId == null
        ? null
        : lotesOrigenValidos
              .cast<Lote?>()
              .firstWhere((lote) => lote?.id == _loteOrigenId, orElse: () => null);
    final origenEstadoId = origenSeleccionado == null
        ? null
        : _estadoIdDeLote(origenSeleccionado, estadosCafe);
    final destinosValidos = origenEstadoId == null
        ? const <int>[]
        : _destinosValidosPara(origenEstadoId);

    final rendimiento = _rendimientoPorcentaje;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              key: const Key('dropdown_lote_origen'),
              initialValue: _loteOrigenId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Lote origen'),
              items: lotesOrigenValidos
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
              validator: _requeridoLote,
              onChanged: isLoading
                  ? null
                  : (value) => setState(() {
                      _loteOrigenId = value;
                      // Los destinos válidos dependen del origen — un
                      // destino ya elegido puede dejar de ser válido.
                      _estadoDestinoId = null;
                    }),
            ),
            const SizedBox(height: AppSpacing.space4),
            DropdownButtonFormField<int>(
              key: const Key('dropdown_estado_destino'),
              initialValue: _estadoDestinoId,
              decoration: const InputDecoration(labelText: 'Procesar a'),
              items: destinosValidos
                  .map(
                    (id) => DropdownMenuItem(
                      value: id,
                      child: Text(
                        estadosCafe
                            .firstWhere((estado) => estado.id == id)
                            .nombre,
                      ),
                    ),
                  )
                  .toList(),
              validator: _requeridoDestino,
              onChanged: (isLoading || destinosValidos.isEmpty)
                  ? null
                  : (value) => setState(() => _estadoDestinoId = value),
            ),
            const SizedBox(height: AppSpacing.space4),
            TextFormField(
              key: const Key('cantidad_entrada'),
              controller: _cantidadEntradaController,
              decoration: const InputDecoration(
                labelText: 'Cantidad que entra (lote origen)',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validarNumeroPositivo,
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.space4),
            TextFormField(
              key: const Key('cantidad_salida'),
              controller: _cantidadSalidaController,
              decoration: const InputDecoration(
                labelText: 'Cantidad que sale (lote nuevo)',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _validarNumeroPositivo,
              enabled: !isLoading,
            ),
            if (rendimiento != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(
                'Rendimiento estimado: ${rendimiento.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (formState.hasError) ...[
              const SizedBox(height: AppSpacing.space4),
              Text(
                formState.error!.errorMessage(fallback: _errorFallback),
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
    ref.listen<AsyncValue<void>>(procesamientoFormControllerProvider, (
      previous,
      next,
    ) {
      if ((previous?.isLoading ?? false) && !next.hasError) {
        widget.onGuardado();
      }
    });

    final existenciasAsync = ref.watch(existenciasProvider);
    final catalogosAsync = ref.watch(catalogosProvider);
    final formState = ref.watch(procesamientoFormControllerProvider);
    final isLoading = formState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Procesar café')),
      body: SafeArea(
        child: existenciasAsync.buildOrRetry(
          errorFallback: _errorFallback,
          onRetry: () => ref.invalidate(existenciasProvider),
          data: (existencias) => catalogosAsync.buildOrRetry(
            errorFallback: _errorFallback,
            onRetry: () => ref.invalidate(catalogosProvider),
            data: (catalogos) => _buildForm(
              existencias,
              catalogos.estadosCafe,
              isLoading,
              formState,
            ),
          ),
        ),
      ),
    );
  }
}
