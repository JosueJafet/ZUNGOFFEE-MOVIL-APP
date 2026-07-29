import 'package:freezed_annotation/freezed_annotation.dart';

part 'compra_historial.freezed.dart';

/// Modelo de dominio de un ítem del historial de compras, mapeado desde
/// `CompraHistorialDto` (`GET /compras`). **No es lo mismo que `Compra`**
/// (la respuesta de `POST /compras` al crear): el listado trae una forma
/// completamente distinta — sin `tenant_id`/`proveedor_id`/`usuario_id`
/// planos ni `anulada`, con `proveedores`/`usuarios` anidados en su
/// lugar — confirmado contra la API real, no contra el contrato escrito.
///
/// Sin `anulada`: la API no la incluye en este listado (gap conocido,
/// reportado al backend) — por eso el botón "Anular" del historial no
/// puede condicionarse a este modelo.
@freezed
class CompraHistorial with _$CompraHistorial {
  const factory CompraHistorial({
    required int id,
    required DateTime fecha,
    required double total,
    required String proveedorNombre,
    required String usuarioNombre,
  }) = _CompraHistorial;
}
