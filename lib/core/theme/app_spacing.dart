/// Escala de espaciado de la marca Zungoffee.
///
/// Contiene unicamente los tokens documentados en la Guia de Marca
/// (seccion "Espaciado y radios"). No se agregan valores intermedios
/// que no esten definidos en la fuente oficial.
abstract final class AppSpacing {
  const AppSpacing._();

  /// `space-2` — 8px. Separacion minima entre elementos.
  static const double space2 = 8;

  /// `space-4` — 16px. Padding interno de tarjeta.
  static const double space4 = 16;

  /// `space-6` — 24px. Separacion entre bloques.
  static const double space6 = 24;
}
