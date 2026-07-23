/// Excepción para respuestas de error de la API de Zungo Coffee.
///
/// Corresponde al formato de error estándar documentado por el backend:
/// `{ "statusCode": 400, "message": "...", "error": "Bad Request" }`.
class ApiException implements Exception {
  const ApiException({required this.statusCode, this.message, this.error});

  /// Código HTTP devuelto por la API (400, 401, 403, 404, 500, ...).
  final int statusCode;

  /// Mensaje de la API. En errores de regla de negocio (400) viene en
  /// español y está listo para mostrarse al usuario tal cual, sin
  /// necesidad de traducir códigos.
  final String? message;

  /// Nombre corto del error HTTP (p. ej. "Bad Request"), si la API lo manda.
  final String? error;

  /// El usuario no tiene el rol requerido para este endpoint.
  bool get isForbidden => statusCode == 403;

  /// La sesión venció o no es válida.
  bool get isUnauthorized => statusCode == 401;

  /// Regla de negocio rechazada (saldo insuficiente, transición de estado
  /// inválida, operación ya anulada, etc.) — [message] ya viene listo
  /// para mostrarse al usuario.
  bool get isBadRequest => statusCode == 400;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}
