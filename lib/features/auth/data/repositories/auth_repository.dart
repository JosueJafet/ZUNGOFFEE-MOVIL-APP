import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/auth_session_service.dart';

/// Fachada de dominio sobre [AuthSessionService] para la feature `auth`.
///
/// No reimplementa nada: solo delega. Existe para que la capa de
/// presentación de esta feature dependa de un tipo propio de `auth` en vez
/// de importar directamente un servicio de `core/services`.
class AuthRepository {
  const AuthRepository(this._authSessionService);

  final AuthSessionService _authSessionService;

  /// `true` si hay una sesión activa.
  bool get isAuthenticated => _authSessionService.isAuthenticated;

  /// Emite cada vez que cambia el estado de auth (login, logout, refresh
  /// de token).
  Stream<AuthState> get onAuthStateChange =>
      _authSessionService.onAuthStateChange;

  /// Inicia sesión con correo y contraseña. No navega ni dispara ningún
  /// redirect: el router reacciona por su cuenta al cambio de sesión.
  Future<void> signIn({required String email, required String password}) async {
    await _authSessionService.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Cierra la sesión activa.
  Future<void> signOut() => _authSessionService.signOut();
}
