/// Excepción para fallas de conectividad: la API nunca llegó a responder
/// (timeout, sin conexión, o el cold start de Render tardó más que el
/// timeout configurado en `AppEnvironment`) — a diferencia de
/// [ApiException], que representa una respuesta de error real del backend.
class NetworkException implements Exception {
  const NetworkException(this.message);

  /// Mensaje listo para mostrarse al usuario.
  final String message;

  @override
  String toString() => 'NetworkException($message)';
}
