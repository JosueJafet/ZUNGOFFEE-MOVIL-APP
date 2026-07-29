import '../../../../core/router/route_paths.dart';

/// Mapea `data.tipo` de un push (`CONTEXTO-PUSH-FCM-MOVIL.md`, sección
/// 5) a la pantalla a la que hay que navegar al tocar la notificación.
///
/// `compra_registrada`/`venta_registrada` sugieren "detalle de la
/// compra/venta" en la doc, pero esa pantalla no existe hoy en la app
/// (solo los historiales de lista) — construirla es un feature aparte,
/// así que navegan al historial correspondiente, el destino real más
/// cercano.
///
/// `null` para cualquier `tipo` no contemplado — no navega en vez de
/// romper con un tipo futuro que el backend agregue sin avisar.
String? rutaParaTipoNotificacion(String tipo) {
  switch (tipo) {
    case 'solicitud_pendiente':
      return RoutePaths.solicitudes;
    case 'pago_pendiente':
      return RoutePaths.pagos;
    case 'compra_registrada':
      return RoutePaths.historialCompras;
    case 'venta_registrada':
      return RoutePaths.historialVentas;
    default:
      return null;
  }
}
