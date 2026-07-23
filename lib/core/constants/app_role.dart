/// Nombres de rol tal como los devuelve la API en `perfil.roles.nombre`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 2.2).
abstract final class AppRole {
  const AppRole._();

  /// Dueño de la plataforma. No usa la app móvil.
  static const String superAdmin = 'super_admin';

  /// Dueño de una bodega. Control total de su bodega.
  static const String adminBodega = 'admin_bodega';

  /// Trabajador de campo. Usuario principal de la app móvil.
  static const String empleado = 'empleado';
}
