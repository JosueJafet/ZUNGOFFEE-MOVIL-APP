import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_extensions.dart';

/// Traduce el slug crudo de `estados_cafe` (`uva`, `humedo`,
/// `pergamino_seco`, `tostado_alto`, `tostado_medio`, `tostado_bajo`,
/// `molido`) a un chip con el color de marca de esa etapa y una
/// etiqueta legible, en vez de mostrar el slug tal cual.
///
/// Los 3 niveles de tostado comparten el mismo color (`stageTueste`):
/// la Guia de Marca define un solo tono "Tueste" para todo el tostado,
/// sin distinguir alto/medio/bajo por color — sí se distinguen por la
/// etiqueta. Un slug no reconocido no rompe: cae a `mutedForeground` y
/// muestra el slug tal cual.
class EstadoCafeChip extends StatelessWidget {
  const EstadoCafeChip({super.key, required this.slug});

  final String slug;

  static const Map<String, String> _etiquetas = {
    'uva': 'Uva',
    'humedo': 'Húmedo',
    'pergamino_seco': 'Pergamino seco',
    'tostado_alto': 'Tostado alto',
    'tostado_medio': 'Tostado medio',
    'tostado_bajo': 'Tostado bajo',
    'molido': 'Molido',
  };

  /// Etiqueta legible de [slug], para los sitios que solo necesitan el
  /// texto (p. ej. un `DropdownMenuItem` de selección simple) sin el
  /// chip de color completo — mismo mapeo que usa el chip, para no
  /// duplicarlo.
  static String etiquetaDe(String slug) => _etiquetas[slug] ?? slug;

  Color _colorDe(AppColorsExtension colors) {
    switch (slug) {
      case 'uva':
        return colors.stageUva;
      case 'humedo':
        return colors.stageHumedo;
      case 'pergamino_seco':
        return colors.stagePergamino;
      case 'tostado_alto':
      case 'tostado_medio':
      case 'tostado_bajo':
        return colors.stageTueste;
      case 'molido':
        return colors.stageMolido;
      default:
        return colors.mutedForeground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorDe(context.appColors);
    final etiqueta = _etiquetas[slug] ?? slug;

    return Chip(
      label: Text(etiqueta),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2),
    );
  }
}
