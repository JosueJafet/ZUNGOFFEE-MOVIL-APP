import 'package:supabase_flutter/supabase_flutter.dart';

/// Envoltorio delgado sobre `SupabaseClient.auth` (Supabase Auth).
///
/// Es el único punto del proyecto que debe hablar directamente con el SDK
/// de Supabase Auth: el interceptor de red (cliente Dio), el router y,
/// más adelante, los providers de `features/auth`, deben pasar por aquí
/// en vez de llamar a `Supabase.instance.client.auth` por su cuenta.
///
/// Recibe el [SupabaseClient] por constructor (en vez de leer el
/// singleton `Supabase.instance` directamente) para poder sustituirlo por
/// un cliente de prueba en tests, sin depender de un SDK ya inicializado.
class AuthSessionService {
  const AuthSessionService(this._client);

  final SupabaseClient _client;

  /// Sesión activa, o `null` si no hay usuario autenticado.
  Session? get currentSession => _client.auth.currentSession;

  /// JWT de la sesión activa, listo para `Authorization: Bearer <token>`.
  /// `null` si no hay sesión — nunca se debe cachear este valor en una
  /// variable propia, para no mandar un token vencido.
  String? get accessToken => currentSession?.accessToken;

  /// `true` si hay una sesión activa.
  bool get isAuthenticated => currentSession != null;

  /// Emite cada vez que cambia el estado de auth (login, logout, refresh
  /// de token). Lo usará el router para reevaluar sus redirects.
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Inicia sesión con correo y contraseña contra Supabase Auth.
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Cierra la sesión activa.
  Future<void> signOut() => _client.auth.signOut();
}
