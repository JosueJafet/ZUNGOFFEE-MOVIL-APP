import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_decimal.dart';
import '../models/venta.dart';

part 'venta_dto.freezed.dart';
part 'venta_dto.g.dart';

/// DTO fiel al JSON de `POST /ventas` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.5) — snake_case, tal como llega de la API. **Sin `fecha`**:
/// a diferencia de `CompraDto`, esta respuesta no la incluye.
@freezed
class VentaDto with _$VentaDto {
  const VentaDto._();

  const factory VentaDto({
    required int id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    @JsonKey(name: 'cliente_id') required int clienteId,
    @JsonKey(name: 'usuario_id') required int usuarioId,
    required String total,
    required bool anulada,
  }) = _VentaDto;

  factory VentaDto.fromJson(Map<String, dynamic> json) =>
      _$VentaDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Venta` (camelCase, con `total` ya parseado).
  Venta toDomain() {
    return Venta(
      id: id,
      tenantId: tenantId,
      clienteId: clienteId,
      usuarioId: usuarioId,
      total: ApiDecimal.fromJson(total),
      anulada: anulada,
    );
  }
}