import 'package:intl/intl.dart';

/// Fechas de la API (`CONTEXTO-MOVIL-FLUTTER.md`, sección 5): se mandan
/// como `"YYYY-MM-DD"` en los request bodies y llegan como datetime ISO
/// completo (`"2026-08-01T00:00:00.000Z"`) en las respuestas.
abstract final class ApiDate {
  const ApiDate._();

  static final DateFormat _requestFormat = DateFormat('yyyy-MM-dd');

  /// Formatea una fecha local al `"YYYY-MM-DD"` que espera un request body.
  static String toRequestDate(DateTime date) => _requestFormat.format(date);

  /// Parsea el datetime ISO completo que llega en una respuesta.
  static DateTime fromResponse(String iso) => DateTime.parse(iso);
}
