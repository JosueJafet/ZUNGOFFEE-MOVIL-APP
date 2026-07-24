import 'package:freezed_annotation/freezed_annotation.dart';

part 'compra.freezed.dart';

/// Modelo de dominio de una compra, mapeado desde `CompraDto`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.3). No representa `lineas`: la
/// respuesta de `POST /compras` no las devuelve — para verlas hay que
/// consultar `GET /lotes/existencias` después.
@freezed
class Compra with _$Compra {
  const factory Compra({
    required int id,
    required int tenantId,
    required int proveedorId,
    required int usuarioId,
    required DateTime fecha,
    required double total,
    required bool anulada,
  }) = _Compra;
}
