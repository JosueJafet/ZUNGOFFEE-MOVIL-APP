import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';

/// Punto único de integración de la identidad visual de Zungoffee.
///
/// El logo/isotipo definitivo está en diseño en paralelo (fuera de
/// alcance de este sprint) — mientras tanto, este widget es un
/// placeholder de texto. Cuando el logo esté aprobado (previsiblemente
/// un SVG), el reemplazo se hace una sola vez aquí adentro — p. ej.
/// cambiar el `Text` de abajo por `SvgPicture.asset(...)` — sin tocar
/// `HomeScreen`, `LoginScreen` ni ninguna otra pantalla que lo consuma.
class ZungoffeeWordmark extends StatelessWidget {
  const ZungoffeeWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Zungoffee',
      style: AppTypography.heading.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
