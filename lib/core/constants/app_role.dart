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

  /// Etiqueta legible de [rol] para mostrar en la interfaz (ej. el chip
  /// de rol en `AppDrawer`, mismo texto que usa la plataforma web junto
  /// al avatar) — cae al valor crudo si algún día apareciera un rol
  /// nuevo no contemplado aquí, en vez de mostrar un chip vacío.
  static String etiquetaDe(String rol) {
    switch (rol) {
      case superAdmin:
        return 'Super admin';
      case adminBodega:
        return 'Administrador';
      case empleado:
        return 'Empleado';
      default:
        return rol;
    }
  }
}
