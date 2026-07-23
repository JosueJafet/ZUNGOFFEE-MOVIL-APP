import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_session_service.dart';

/// Instancia única de [AuthSessionService] para toda la app.
///
/// Requiere que Supabase ya esté inicializado (`SupabaseBootstrap.
/// initialize()`) antes de que se lea por primera vez — `main.dart` lo
/// garantiza al llamarlo antes de crear el `ProviderContainer`.
final authSessionServiceProvider = Provider<AuthSessionService>((ref) {
  return AuthSessionService(Supabase.instance.client);
});
