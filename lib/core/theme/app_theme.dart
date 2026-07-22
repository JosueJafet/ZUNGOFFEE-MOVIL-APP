import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'theme_extensions.dart';

/// Construye los [ThemeData] claro y oscuro de Zungoffee a partir de los
/// tokens de `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
/// y `app_radius.dart`.
///
/// Este es el unico lugar del proyecto donde estos tokens se combinan en
/// un [ThemeData]; el resto de la app debe consumirlos via `Theme.of(context)`
/// (colores/tipografia) en lugar de repetir valores.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        colors: const _ThemeColors(
          background: AppLightColors.background,
          card: AppLightColors.card,
          foreground: AppLightColors.foreground,
          primary: AppLightColors.primary,
          secondary: AppLightColors.secondary,
          mutedForeground: AppLightColors.mutedForeground,
          destructive: AppLightColors.destructive,
        ),
        colorsExtension: AppColorsExtension.light,
      );

  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        colors: const _ThemeColors(
          background: AppDarkColors.background,
          card: AppDarkColors.card,
          foreground: AppDarkColors.foreground,
          primary: AppDarkColors.primary,
          secondary: AppDarkColors.secondary,
          mutedForeground: AppDarkColors.mutedForeground,
          destructive: AppDarkColors.destructive,
        ),
        colorsExtension: AppColorsExtension.dark,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required _ThemeColors colors,
    required AppColorsExtension colorsExtension,
  }) {
    // La guia no define tokens `on*` (texto sobre color) explicitos: se usa
    // blanco para texto sobre `primary`/`destructive` (tonos saturados,
    // como en el mock de "Registrar mi bodega") y el `foreground` del propio
    // tema para texto sobre `secondary` (fondo claro/oscuro segun el tema).
    const onSaturated = Colors.white;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: onSaturated,
      secondary: colors.secondary,
      onSecondary: colors.foreground,
      secondaryContainer: colors.secondary,
      onSecondaryContainer: colors.foreground,
      error: colors.destructive,
      onError: onSaturated,
      surface: colors.card,
      onSurface: colors.foreground,
      onSurfaceVariant: colors.mutedForeground,
      outline: colors.mutedForeground,
    );

    final textTheme = _buildTextTheme(colors.foreground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      fontFamily: AppFontFamily.inter,
      textTheme: textTheme,
      extensions: [colorsExtension],
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.secondary,
        labelStyle: AppTypography.caption.copyWith(color: colors.foreground),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
        side: BorderSide.none,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: onSaturated,
          textStyle: AppTypography.body,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space6,
            vertical: AppSpacing.space2,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.foreground,
          side: BorderSide(color: colors.mutedForeground),
          textStyle: AppTypography.body,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space6,
            vertical: AppSpacing.space2,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: AppTypography.body,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space2,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space4,
        ),
        hintStyle: AppTypography.body.copyWith(color: colors.mutedForeground),
        labelStyle: AppTypography.caption.copyWith(color: colors.mutedForeground),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.mutedForeground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.mutedForeground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.destructive),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.mutedForeground.withValues(alpha: 0.3)),
    );
  }

  static TextTheme _buildTextTheme(Color foreground) {
    TextStyle withColor(TextStyle style) => style.copyWith(color: foreground);

    return TextTheme(
      headlineMedium: withColor(AppTypography.display),
      titleLarge: withColor(AppTypography.heading),
      titleMedium: withColor(AppTypography.subheading),
      bodyLarge: withColor(AppTypography.body),
      bodyMedium: withColor(AppTypography.caption),
      labelLarge: withColor(AppTypography.tabularData),
    );
  }
}

/// Agrupa los tokens de color que difieren entre tema claro y oscuro,
/// para que `_buildTheme` no repita la logica de mapeo dos veces.
class _ThemeColors {
  const _ThemeColors({
    required this.background,
    required this.card,
    required this.foreground,
    required this.primary,
    required this.secondary,
    required this.mutedForeground,
    required this.destructive,
  });

  final Color background;
  final Color card;
  final Color foreground;
  final Color primary;
  final Color secondary;
  final Color mutedForeground;
  final Color destructive;
}
