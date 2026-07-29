import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

/// Botón "soft destructivo": fondo rojo claro + texto rojo, distinto del
/// botón destructivo saturado (`Theme.of(context).colorScheme.error`
/// como fondo pleno). Para acciones destructivas que no son el CTA
/// principal de la pantalla — p. ej. "Anular" en un `ListTile` — mismo
/// tratamiento que "Eliminar lote" en la Guia de Marca.
///
/// Usa `colorScheme.error` (claro/oscuro ya resuelto por `AppTheme`) en
/// vez de un color fijo, así que sigue el tema del sistema igual que el
/// resto de la app.
class SoftDestructiveButton extends StatelessWidget {
  const SoftDestructiveButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destructive = Theme.of(context).colorScheme.error;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: destructive.withValues(alpha: 0.12),
        foregroundColor: destructive,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space2,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      ),
      child: child,
    );
  }
}
