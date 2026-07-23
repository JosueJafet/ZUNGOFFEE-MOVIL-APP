/// Configuración de entorno de la app: credenciales de Supabase, URL base
/// de la API de Zungo Coffee y timeouts de red.
///
/// Todos los valores tienen un default (staging) tomado literalmente del
/// documento de contexto técnico (`CONTEXTO-MOVIL-FLUTTER.md`) y pueden
/// sobreescribirse en tiempo de compilación con `--dart-define`, por
/// ejemplo para apuntar a un backend local durante desarrollo:
///
/// ```
/// flutter run --dart-define=API_BASE_URL=http://localhost:3000
/// ```
///
/// Todavía no existe un ambiente de producción separado (según el propio
/// backend), por lo que no se modela un sistema de "flavors" — solo
/// staging (default) y la posibilidad de apuntar a localhost en dev.
abstract final class AppEnvironment {
  const AppEnvironment._();

  /// URL del proyecto Supabase. Es un valor público por diseño de
  /// Supabase (no es un secreto de servidor).
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tagmxyqqnwttcqisiqvo.supabase.co',
  );

  /// Anon key pública de Supabase. Segura de embeber en el cliente: está
  /// protegida por Row Level Security en el backend, a diferencia de la
  /// `service_role key` (esa nunca debe vivir en la app).
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRhZ214eXFxbnd0dGNxaXNpcXZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ1MTQyNDYsImV4cCI6MjEwMDA5MDI0Nn0.KGV-zluaRwZVKFn0pokzjPBPvYvDNK1dXwi7x2kp1u0',
  );

  /// URL base de la API de Zungo Coffee (NestJS). Default: staging en
  /// Render. Para desarrollo local, sobreescribir con
  /// `--dart-define=API_BASE_URL=http://localhost:3000`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://zungo-coffee-api.onrender.com',
  );

  /// Timeout de conexión pensado para el cold start del plan free de
  /// Render (~30-50s tras ~15 min sin tráfico) — no es un valor arbitrario,
  /// es el escenario documentado del backend.
  static const Duration apiConnectTimeout = Duration(seconds: 60);

  /// Timeout de recepción, mismo criterio que [apiConnectTimeout].
  static const Duration apiReceiveTimeout = Duration(seconds: 60);
}
