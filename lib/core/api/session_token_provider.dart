/// Lo mínimo que [ApiClient] necesita saber sobre la sesión activa: el
/// JWT a adjuntar en cada request.
///
/// `AuthSessionService` (`core/services`) lo implementa. Definir esta
/// interfaz del lado de `core/api` (en vez de depender directamente de
/// `AuthSessionService`) evita que el cliente de red dependa del SDK de
/// Supabase, y permite probar `ApiClient` con un fake en tests.
abstract interface class SessionTokenProvider {
  /// JWT de la sesión activa, o `null` si no hay sesión.
  String? get accessToken;
}
