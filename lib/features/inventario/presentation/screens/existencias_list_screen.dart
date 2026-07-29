import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/async_value_view_extension.dart';
import '../../../../shared/widgets/chips/estado_cafe_chip.dart';
import '../../../../shared/widgets/navigation/app_drawer.dart';
import '../../../catalogos/data/models/unidad_medida.dart';
import '../../../catalogos/presentation/providers/catalogos_providers.dart';
import '../../data/models/lote.dart';
import '../providers/lotes_providers.dart';

/// Lista de existencias actuales (`GET /lotes/existencias`) — primera
/// pantalla real de `features/inventario/`. Puramente de lectura: la API
/// no expone ninguna acción sobre un lote en este contrato (Sprint 6).
///
/// No importa `go_router` — igual que `ProveedoresListScreen` (Sprint 5),
/// la navegación real la resuelve quien construya esta pantalla desde
/// `app_routes.dart` (Task 8).
///
/// El filtro "Disponible"/"Todos los lotes" es puramente local (sobre la
/// misma respuesta ya cargada, sin volver a llamar a la API): la
/// plataforma web equivalente ya distingue estas dos vistas, y "saldo >
/// 0" es la única noción de "disponible" que expone este modelo.
///
/// El nombre de la unidad se resuelve contra `catalogos.unidadesMedida`
/// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 5: uva → galones, húmedo y
/// pergamino seco → quintales, tostado y molido → libras) — no se asume
/// "libras" para todo lote, como sí se hacía antes de modelar ese
/// catálogo.
class ExistenciasListScreen extends ConsumerStatefulWidget {
  const ExistenciasListScreen({super.key});

  @override
  ConsumerState<ExistenciasListScreen> createState() =>
      _ExistenciasListScreenState();
}

class _ExistenciasListScreenState extends ConsumerState<ExistenciasListScreen> {
  bool _soloDisponibles = true;

  Widget _stat(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, Lote lote, List<UnidadMedida> unidades) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Lote #${lote.id}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                EstadoCafeChip(slug: lote.estadoCafeNombre),
              ],
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              '${lote.variedadNombre ?? "Sin variedad"} · '
              '${lote.nivelAlturaNombre ?? "Sin nivel"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.space4),
            Row(
              children: [
                _stat(
                    context, 'Unidad', unidades.nombreDe(lote.unidadMedidaId)),
                _stat(
                  context,
                  'Cantidad inicial',
                  lote.cantidadInicial.toStringAsFixed(2),
                ),
                _stat(context, 'Saldo', lote.saldo.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(List<Lote> lotes, List<UnidadMedida> unidades) {
    final lotesFiltrados = _soloDisponibles
        ? lotes.where((lote) => lote.saldo > 0).toList()
        : lotes;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space4,
            AppSpacing.space4,
            AppSpacing.space4,
            0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Disponible')),
                ButtonSegment(value: false, label: Text('Todos los lotes')),
              ],
              selected: {_soloDisponibles},
              onSelectionChanged: (seleccion) =>
                  setState(() => _soloDisponibles = seleccion.first),
            ),
          ),
        ),
        Expanded(
          child: lotesFiltrados.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space6),
                    child: Text(
                      lotes.isEmpty
                          ? 'No hay existencias registradas'
                          : 'No hay lotes disponibles con este filtro',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: AppSpacing.space2),
                  itemCount: lotesFiltrados.length,
                  itemBuilder: (context, index) =>
                      _item(context, lotesFiltrados[index], unidades),
                ),
        ),
      ],
    );
  }

  static const _errorFallback =
      'No se pudieron cargar las existencias. Intenta de nuevo.';

  @override
  Widget build(BuildContext context) {
    final existenciasAsync = ref.watch(existenciasProvider);
    final catalogosAsync = ref.watch(catalogosProvider);

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Existencias'),
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
      body: existenciasAsync.buildOrRetry(
        errorFallback: _errorFallback,
        onRetry: () => ref.invalidate(existenciasProvider),
        data: (lotes) => catalogosAsync.buildOrRetry(
          errorFallback: _errorFallback,
          onRetry: () => ref.invalidate(catalogosProvider),
          data: (catalogos) => _buildLista(lotes, catalogos.unidadesMedida),
        ),
      ),
    );
  }
}
