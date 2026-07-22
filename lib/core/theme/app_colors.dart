import 'package:flutter/material.dart';

/// Tonos fijos de la marca Zungoffee, iguales en web, iOS y Android.
///
/// Fuente: Guia de Marca Zungoffee — seccion "Paleta de marca".
abstract final class AppColors {
  const AppColors._();

  /// Cereza — primario · uva.
  static const Color cereza = Color(0xFFA3311F);

  /// Oliva — secundario · verde.
  static const Color oliva = Color(0xFF6E7A4C);

  /// Pergamino — fondo claro.
  static const Color pergamino = Color(0xFFEDE3C6);

  /// Tueste — texto secundario.
  static const Color tueste = Color(0xFF6B4226);

  /// Oro tostado — acentos / badges.
  static const Color oroTostado = Color(0xFFC99A3E);

  /// Ink — texto / modo oscuro.
  static const Color ink = Color(0xFF221912);
}

/// Roles semanticos de color para el tema claro.
///
/// Fuente: Guia de Marca Zungoffee — tabla "Roles semanticos (claro / oscuro)".
abstract final class AppLightColors {
  const AppLightColors._();

  /// Fondo de pantalla.
  static const Color background = Color(0xFFF1E8CE);

  /// Tarjetas / superficies.
  static const Color card = Color(0xFFFBF7EA);

  /// Texto principal.
  static const Color foreground = Color(0xFF221912);

  /// Botones / CTA principal.
  static const Color primary = Color(0xFFA3311F);

  /// Acciones secundarias.
  static const Color secondary = Color(0xFFE7DFC8);

  /// Texto de apoyo.
  static const Color mutedForeground = Color(0xFF7A6A54);

  /// Errores / eliminar.
  static const Color destructive = Color(0xFFC43D2E);
}

/// Roles semanticos de color para el tema oscuro.
///
/// Fuente: Guia de Marca Zungoffee — tabla "Roles semanticos (claro / oscuro)".
abstract final class AppDarkColors {
  const AppDarkColors._();

  /// Fondo de pantalla.
  static const Color background = Color(0xFF17110C);

  /// Tarjetas / superficies.
  static const Color card = Color(0xFF221A13);

  /// Texto principal.
  static const Color foreground = Color(0xFFF1E7CC);

  /// Botones / CTA principal.
  static const Color primary = Color(0xFFE1684A);

  /// Acciones secundarias.
  static const Color secondary = Color(0xFF2E251C);

  /// Texto de apoyo.
  static const Color mutedForeground = Color(0xFFB5A587);

  /// Errores / eliminar.
  static const Color destructive = Color(0xFFE2584A);
}

/// Colores de las 5 etapas del procesamiento de café (`estados_cafe`).
///
/// Se usan para el chip de estado de un lote; deben ser identicos en web
/// y movil, por lo que no dependen del tema claro/oscuro.
///
/// Fuente: Guia de Marca Zungoffee — seccion de la paleta de 5 etapas
/// (Uva, Húmedo, Pergamino, Tueste, Molido).
abstract final class AppCoffeeStageColors {
  const AppCoffeeStageColors._();

  static const Color uva = Color(0xFFA3311F);
  static const Color humedo = Color(0xFFB5652E);
  static const Color pergamino = Color(0xFFC99A3E);
  static const Color tueste = Color(0xFF8B5A34);
  static const Color molido = Color(0xFF4A2E1C);
}
