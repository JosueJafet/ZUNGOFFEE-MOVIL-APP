import 'package:freezed_annotation/freezed_annotation.dart';

part 'venta_historial.freezed.dart';

/// Modelo de dominio de un ítem del historial de ventas, mapeado desde
/// `VentaHistorialDto` (`GET /ventas`). **No es lo mismo que `Venta`**
/// (la respuesta de `POST /ventas` al crear): el listado trae una forma
/// completamente distinta — sin `tenant_id`/`cliente_id`/`usuario_id`
/// planos ni `anulada`, con `clientes` anidado en su lugar, y sí trae
/// `fecha` (que la respuesta de creación no tiene) — confirmado contra
/// la API real, no contra el contrato escrito.
///
/// Sin `anulada`: la API no la incluye en este listado (gap conocido,
/// reportado al backend) — por eso el botón "Anular" del historial no
/// puede condicionarse a este modelo.
@freezed
class VentaHistorial with _$VentaHistorial {
  const factory VentaHistorial({
    required int id,
    required DateTime fecha,
    required double total,
    required String clienteNombre,
  }) = _VentaHistorial;
}
