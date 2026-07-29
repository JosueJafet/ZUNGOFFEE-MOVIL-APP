import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estilos de texto de la marca Zungoffee: Poppins para títulos, Inter
/// para texto/interfaz, JetBrains Mono para datos tabulares.
///
/// Tamaños y pesos tomados literalmente de la Guia de Marca (seccion
/// "Tipografia"). El color no se fija aqui: se aplica desde `AppTheme`
/// segun el rol semantico (`foreground`, `mutedForeground`, etc.) para
/// que el mismo estilo sirva en tema claro y oscuro.
///
/// Los archivos de fuente los resuelve el paquete `google_fonts` — la
/// propia guia lo sugiere para movil ("Poppins/Inter existen para iOS y
/// Android (Google Fonts)") — por eso ya no hay nombres de familia
/// sueltos como antes: `GoogleFonts.poppins`/`inter`/`jetBrainsMono` se
/// encargan de resolver la familia real.
abstract final class AppTypography {
  const AppTypography._();

  /// Poppins · 700 · 2.5rem / 40px.
  static TextStyle get display =>
      GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 40);

  /// Poppins · 600 · 1.75rem / 28px.
  static TextStyle get heading =>
      GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 28);

  /// Poppins · 600 · 1.25rem / 20px.
  static TextStyle get subheading =>
      GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20);

  /// Inter · 400 · 1.1rem / 17.6px.
  static TextStyle get body =>
      GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 17.6);

  /// Inter · 400 · 0.95rem / 15.2px.
  static TextStyle get caption =>
      GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 15.2);

  /// JetBrains Mono · datos tabulares (lote, saldo, costo unitario).
  ///
  /// La guia no especifica un tamaño/peso explicito para este estilo
  /// (a diferencia de los 5 anteriores). Se usa 16px/400 — el tamaño
  /// base (1rem) del propio sistema de escala de la guia — en lugar de
  /// un valor inventado. Ajustar aqui si la guia se actualiza con un
  /// valor explicito.
  static TextStyle get tabularData =>
      GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w400, fontSize: 16);
}
