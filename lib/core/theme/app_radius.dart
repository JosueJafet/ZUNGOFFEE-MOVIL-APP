import 'package:flutter/widgets.dart';

/// Escala de radios de borde de la marca Zungoffee.
///
/// Valores tomados de la Guia de Marca (seccion "Espaciado y radios").
/// Los getters `*Radius` son un envoltorio de conveniencia sobre los
/// mismos valores, no una fuente adicional de datos.
abstract final class AppRadius {
  const AppRadius._();

  /// `radius-sm` — 6px. Chips pequeños.
  static const double sm = 6;

  /// `radius-md` — 8px. Inputs, botones.
  static const double md = 8;

  /// `radius-lg` — 10px. Tarjetas.
  static const double lg = 10;

  /// `radius-xl` — 14px. Modales / paneles grandes.
  static const double xl = 14;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
}
