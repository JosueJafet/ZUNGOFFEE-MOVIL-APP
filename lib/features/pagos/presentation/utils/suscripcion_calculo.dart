import '../../data/models/pago.dart';

/// Estado de la suscripción de una bodega, ya resuelto para mostrar
/// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.15 — mismo bloque que ve
/// `admin_bodega` en "Mi perfil" en la plataforma web).
class SuscripcionInfo {
  const SuscripcionInfo({required this.estado, required this.diasRestantes});

  /// "pendiente" / "pagado" / "vencido" — tal como lo devuelve
  /// `Pago.estadoCalculado`, ya resuelto por el backend.
  final String estado;

  /// Puede ser negativo (ciclo ya vencido hace días).
  final int diasRestantes;
}

/// Calcula el estado de suscripción vigente a partir del historial de
/// pagos de una bodega (`GET /pagos/tenant/:id`) — `null` si la bodega
/// nunca registró un ciclo de pago ("Sin ciclo de pago", sección 8.12).
///
/// Mismo cálculo que hace la plataforma web (sección 8.12, nota de
/// cálculo): el ciclo vigente es el que tiene la `fechaVencimiento` más
/// lejana, y los días restantes se cuentan en días completos usando
/// medianoche UTC de ambos lados — evita el corrimiento de un día por
/// zona horaria que darían fechas locales.
///
/// [ahora] es inyectable para que los tests no dependan del reloj real
/// del sistema (mismo patrón que otras funciones puras del proyecto,
/// ej. `rutaParaTipoNotificacion`).
SuscripcionInfo? calcularSuscripcion(List<Pago> pagos, {DateTime? ahora}) {
  if (pagos.isEmpty) return null;

  final vigente = pagos.reduce(
    (a, b) => a.fechaVencimiento.isAfter(b.fechaVencimiento) ? a : b,
  );

  final hoyUtc = (ahora ?? DateTime.now()).toUtc();
  final hoyMedianoche = DateTime.utc(hoyUtc.year, hoyUtc.month, hoyUtc.day);

  final vencimientoUtc = vigente.fechaVencimiento.toUtc();
  final vencimientoMedianoche = DateTime.utc(
    vencimientoUtc.year,
    vencimientoUtc.month,
    vencimientoUtc.day,
  );

  return SuscripcionInfo(
    estado: vigente.estadoCalculado,
    diasRestantes: vencimientoMedianoche.difference(hoyMedianoche).inDays,
  );
}
