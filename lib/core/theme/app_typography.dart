import 'package:flutter/material.dart';

/// Familias tipograficas de la marca Zungoffee.
///
/// Fuente: Guia de Marca Zungoffee — seccion "Tipografia".
/// Nota: esta tarea solo declara los nombres de familia. El registro de
/// los archivos de fuente (Google Fonts) en `pubspec.yaml` queda fuera de
/// alcance de este ticket para no agregar dependencias/assets nuevos.
abstract final class AppFontFamily {
  const AppFontFamily._();

  /// Titulos: display, heading, subheading.
  static const String poppins = 'Poppins';

  /// Texto e interfaz: body, caption.
  static const String inter = 'Inter';

  /// Datos tabulares: IDs de lote, montos, cantidades.
  static const String jetBrainsMono = 'JetBrains Mono';
}

/// Estilos de texto de la marca Zungoffee.
///
/// Tamaños y pesos tomados literalmente de la Guia de Marca (seccion
/// "Tipografia"). El color no se fija aqui: se aplica desde `AppTheme`
/// segun el rol semantico (`foreground`, `mutedForeground`, etc.) para
/// que el mismo estilo sirva en tema claro y oscuro.
abstract final class AppTypography {
  const AppTypography._();

  /// Poppins · 700 · 2.5rem / 40px.
  static const TextStyle display = TextStyle(
    fontFamily: AppFontFamily.poppins,
    fontWeight: FontWeight.w700,
    fontSize: 40,
  );

  /// Poppins · 600 · 1.75rem / 28px.
  static const TextStyle heading = TextStyle(
    fontFamily: AppFontFamily.poppins,
    fontWeight: FontWeight.w600,
    fontSize: 28,
  );

  /// Poppins · 600 · 1.25rem / 20px.
  static const TextStyle subheading = TextStyle(
    fontFamily: AppFontFamily.poppins,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  /// Inter · 400 · 1.1rem / 17.6px.
  static const TextStyle body = TextStyle(
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w400,
    fontSize: 17.6,
  );

  /// Inter · 400 · 0.95rem / 15.2px.
  static const TextStyle caption = TextStyle(
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w400,
    fontSize: 15.2,
  );

  /// JetBrains Mono · datos tabulares (lote, saldo, costo unitario).
  ///
  /// La guia no especifica un tamaño/peso explicito para este estilo
  /// (a diferencia de los 5 anteriores). Se usa 16px/400 — el tamaño
  /// base (1rem) del propio sistema de escala de la guia — en lugar de
  /// un valor inventado. Ajustar aqui si la guia se actualiza con un
  /// valor explicito.
  static const TextStyle tabularData = TextStyle(
    fontFamily: AppFontFamily.jetBrainsMono,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
}
