import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tokens de marca que no tienen un slot equivalente en [ColorScheme]
/// (acento, texto de apoyo y los colores de las 5 etapas del café),
/// expuestos a traves de [Theme] para evitar que los widgets los
/// hardcodeen o los importen directamente desde `app_colors.dart`.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.mutedForeground,
    required this.accent,
    required this.stageUva,
    required this.stageHumedo,
    required this.stagePergamino,
    required this.stageTueste,
    required this.stageMolido,
  });

  /// Texto de apoyo (rol semantico `muted-foreground`).
  final Color mutedForeground;

  /// Acentos / badges (`oro tostado`).
  final Color accent;

  /// Color del estado `uva` en `estados_cafe`.
  final Color stageUva;

  /// Color del estado `humedo` en `estados_cafe`.
  final Color stageHumedo;

  /// Color del estado `pergamino` en `estados_cafe`.
  final Color stagePergamino;

  /// Color del estado `tueste` en `estados_cafe`.
  final Color stageTueste;

  /// Color del estado `molido` en `estados_cafe`.
  final Color stageMolido;

  /// Tokens para [ThemeData.light].
  static const AppColorsExtension light = AppColorsExtension(
    mutedForeground: AppLightColors.mutedForeground,
    accent: AppColors.oroTostado,
    stageUva: AppCoffeeStageColors.uva,
    stageHumedo: AppCoffeeStageColors.humedo,
    stagePergamino: AppCoffeeStageColors.pergamino,
    stageTueste: AppCoffeeStageColors.tueste,
    stageMolido: AppCoffeeStageColors.molido,
  );

  /// Tokens para [ThemeData.dark].
  ///
  /// Los colores de etapa (`estados_cafe`) son los mismos en ambos temas
  /// por diseño (la guia los define una sola vez, sin variante oscura).
  static const AppColorsExtension dark = AppColorsExtension(
    mutedForeground: AppDarkColors.mutedForeground,
    accent: AppColors.oroTostado,
    stageUva: AppCoffeeStageColors.uva,
    stageHumedo: AppCoffeeStageColors.humedo,
    stagePergamino: AppCoffeeStageColors.pergamino,
    stageTueste: AppCoffeeStageColors.tueste,
    stageMolido: AppCoffeeStageColors.molido,
  );

  @override
  AppColorsExtension copyWith({
    Color? mutedForeground,
    Color? accent,
    Color? stageUva,
    Color? stageHumedo,
    Color? stagePergamino,
    Color? stageTueste,
    Color? stageMolido,
  }) {
    return AppColorsExtension(
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      stageUva: stageUva ?? this.stageUva,
      stageHumedo: stageHumedo ?? this.stageHumedo,
      stagePergamino: stagePergamino ?? this.stagePergamino,
      stageTueste: stageTueste ?? this.stageTueste,
      stageMolido: stageMolido ?? this.stageMolido,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      stageUva: Color.lerp(stageUva, other.stageUva, t)!,
      stageHumedo: Color.lerp(stageHumedo, other.stageHumedo, t)!,
      stagePergamino: Color.lerp(stagePergamino, other.stagePergamino, t)!,
      stageTueste: Color.lerp(stageTueste, other.stageTueste, t)!,
      stageMolido: Color.lerp(stageMolido, other.stageMolido, t)!,
    );
  }
}

/// Acceso ergonomico a [AppColorsExtension] desde cualquier [BuildContext].
extension AppThemeContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
