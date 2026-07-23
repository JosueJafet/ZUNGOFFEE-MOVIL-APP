/// Límites de paginación (`?page&pageSize`) documentados en
/// `CONTEXTO-MOVIL-FLUTTER.md`, sección 5.
abstract final class PaginationLimits {
  const PaginationLimits._();

  /// `pageSize` por defecto para la mayoría de los módulos cuando no se
  /// especifica (compras, ventas, lotes, procesamiento, usuarios).
  static const int defaultPageSize = 20;

  /// Tope duro de `pageSize` para la mayoría de los módulos.
  static const int maxPageSize = 100;

  /// Tope duro de `pageSize` específico de `bitacora`.
  static const int maxPageSizeBitacora = 200;

  /// `pageSize` por defecto específico de `notificaciones` (en vez del
  /// default general de 20).
  static const int defaultPageSizeNotificaciones = 50;
}
