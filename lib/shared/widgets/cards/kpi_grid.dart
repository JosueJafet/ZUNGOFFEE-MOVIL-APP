import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// Grilla de tarjetas KPI (número grande + etiqueta) — usada en Home y
/// en `PagosResumenScreen` para mostrar métricas por rol (bodegas
/// activas/suspendidas, ingresos, lotes en existencia, etc). No conoce
/// de dónde vienen los datos: cada pantalla arma sus propios `(label,
/// value)` ya formateados.
class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key, required this.items});

  final List<(String label, String value)> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.space4,
      crossAxisSpacing: AppSpacing.space4,
      childAspectRatio: 1.6,
      children: items
          .map(
            (item) => Card(
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.lgRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$2,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(item.$1, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
