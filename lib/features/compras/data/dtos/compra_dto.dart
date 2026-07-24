import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../../../../core/utils/api_decimal.dart';
import '../models/compra.dart';

part 'compra_dto.freezed.dart';
part 'compra_dto.g.dart';

/// DTO fiel al JSON de `POST /compras` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.3) — snake_case, tal como llega de la API.
@freezed
class CompraDto with _$CompraDto {
  const CompraDto._();

  const factory CompraDto({
    required int id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    @JsonKey(name: 'proveedor_id') required int proveedorId,
    @JsonKey(name: 'usuario_id') required int usuarioId,
    required String fecha,
    required String total,
    required bool anulada,
  }) = _CompraDto;

  factory CompraDto.fromJson(Map<String, dynamic> json) =>
      _$CompraDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Compra` (camelCase, con `fecha`/`total` ya parseados).
  Compra toDomain() {
    return Compra(
      id: id,
      tenantId: tenantId,
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      fecha: ApiDate.fromResponse(fecha),
      total: ApiDecimal.fromJson(total),
      anulada: anulada,
    );
  }
}
