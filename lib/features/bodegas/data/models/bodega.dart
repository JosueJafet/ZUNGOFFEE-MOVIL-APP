import 'package:freezed_annotation/freezed_annotation.dart';

part 'bodega.freezed.dart';

/// Modelo de dominio de una bodega (tenant), mapeado desde `BodegaDto`.
/// Solo la ve `super_admin` (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12).
@freezed
class Bodega with _$Bodega {
  const Bodega._();

  const factory Bodega({
    required int id,
    required String nombre,
    required int estadoId,
    required DateTime fechaRegistro,
    // `null` = la bodega nunca registró un ciclo de pago ("Sin ciclo de
    // pago", `CONTEXTO-PLATAFORMA-WEB.md` sección 8.12) — ya vienen
    // calculados por el backend en `GET /tenants`, no se recalculan acá
    // (a diferencia de la suscripción propia de `admin_bodega` en Mi
    // perfil, que sí se calcula en el cliente porque ese rol no tiene
    // acceso a este endpoint).
    int? diasRestantes,
    String? estadoPagoCalculado,
  }) = _Bodega;

  /// `estado_id`: `1`=activo, `2`=suspendido (confirmado por Rubio,
  /// backend). Única fuente de verdad del estado — no depende del
  /// objeto `estados_tenant`, ausente en la respuesta de `PATCH
  /// /tenants/:id`.
  bool get activa => estadoId == 1;
}
