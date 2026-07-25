import 'package:freezed_annotation/freezed_annotation.dart';

part 'venta.freezed.dart';

/// Modelo de dominio de una venta, mapeado desde `VentaDto`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.5). **Sin `fecha`**: a
/// diferencia de `Compra`, la respuesta de `POST /ventas` no la incluye.
/// No representa `lineas`: esa respuesta tampoco las devuelve — para
/// verlas hay que consultar `GET /lotes/existencias` después.
@freezed
class Venta with _$Venta {
  const factory Venta({
    required int id,
    required int tenantId,
    required int clienteId,
    required int usuarioId,
    required double total,
    required bool anulada,
  }) = _Venta;
}