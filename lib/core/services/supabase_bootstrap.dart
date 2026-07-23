import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_environment.dart';

/// Inicializa el SDK de Supabase con las credenciales de [AppEnvironment].
///
/// Debe llamarse una única vez, antes de `runApp` (se conecta desde
/// `main.dart` en la tarea de ensamblaje de la app). A partir de aquí,
/// `Supabase.instance.client` queda disponible en toda la app.
abstract final class SupabaseBootstrap {
  const SupabaseBootstrap._();

  static Future<void> initialize() {
    return Supabase.initialize(
      url: AppEnvironment.supabaseUrl,
      // `publishableKey` es el nombre actual del SDK para el mismo valor
      // que el resto del proyecto documenta como "anon key".
      publishableKey: AppEnvironment.supabaseAnonKey,
    );
  }
}
