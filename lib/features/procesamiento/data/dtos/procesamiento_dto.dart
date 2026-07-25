import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_decimal.dart';
import '../../../../core/utils/bigint_id.dart';
import '../models/procesamiento.dart';

part 'procesamiento_dto.freezed.dart';
part 'procesamiento_dto.g.dart';

/// DTO fiel al JSON de `POST /procesamiento` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.6) — snake_case, tal como llega de la API. `id`,
/// `lote_origen_id` y `lote_destino_id` son BigInt (`String`), igual que
/// `Lote.id` (Sprint 6). No modela `lote_destino` anidado (ver
/// `Procesamiento`).
@freezed
class ProcesamientoDto with _$ProcesamientoDto {
  const ProcesamientoDto._();

  const factory ProcesamientoDto({
    required String id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    @JsonKey(name: 'lote_origen_id') required String loteOrigenId,
    @JsonKey(name: 'lote_destino_id') required String loteDestinoId,
    @JsonKey(name: 'cantidad_entrada') required String cantidadEntrada,
    @JsonKey(name: 'cantidad_salida') required String cantidadSalida,
  }) = _ProcesamientoDto;

  factory ProcesamientoDto.fromJson(Map<String, dynamic> json) =>
      _$ProcesamientoDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Procesamiento` (camelCase, con las cantidades ya parseadas).
  Procesamiento toDomain() {
    return Procesamiento(
      id: BigIntId.fromJson(id),
      tenantId: tenantId,
      loteOrigenId: BigIntId.fromJson(loteOrigenId),
      loteDestinoId: BigIntId.fromJson(loteDestinoId),
      cantidadEntrada: ApiDecimal.fromJson(cantidadEntrada),
      cantidadSalida: ApiDecimal.fromJson(cantidadSalida),
    );
  }
}
