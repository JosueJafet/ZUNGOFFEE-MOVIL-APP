import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_decimal.dart';
import '../../../../core/utils/bigint_id.dart';
import '../models/lote.dart';

part 'lote_dto.freezed.dart';
part 'lote_dto.g.dart';

/// DTO fiel al JSON de `GET /lotes/existencias`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.4) — snake_case, tal como llega
/// de la API.
@freezed
class LoteDto with _$LoteDto {
  const LoteDto._();

  const factory LoteDto({
    required String id,
    required String saldo,
    @JsonKey(name: 'cantidad_inicial') required String cantidadInicial,
    @JsonKey(name: 'estados_cafe') required LoteEstadoCafeDto estadosCafe,
    @JsonKey(name: 'variedades_cafe') required LoteVariedadDto variedadesCafe,
    @JsonKey(name: 'niveles_altura') required LoteNivelAlturaDto nivelesAltura,
  }) = _LoteDto;

  factory LoteDto.fromJson(Map<String, dynamic> json) =>
      _$LoteDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio `Lote`
  /// (camelCase, aplanado).
  Lote toDomain() {
    return Lote(
      id: BigIntId.fromJson(id),
      saldo: ApiDecimal.fromJson(saldo),
      cantidadInicial: ApiDecimal.fromJson(cantidadInicial),
      estadoCafeNombre: estadosCafe.nombre,
      unidadMedidaId: estadosCafe.unidadMedidaId,
      variedadNombre: variedadesCafe.nombre,
      nivelAlturaNombre: nivelesAltura.nombre,
    );
  }
}

/// Sub-objeto `estados_cafe` de la respuesta de `GET /lotes/existencias`.
@freezed
class LoteEstadoCafeDto with _$LoteEstadoCafeDto {
  const factory LoteEstadoCafeDto({
    required String nombre,
    @JsonKey(name: 'unidad_medida_id') required int unidadMedidaId,
  }) = _LoteEstadoCafeDto;

  factory LoteEstadoCafeDto.fromJson(Map<String, dynamic> json) =>
      _$LoteEstadoCafeDtoFromJson(json);
}

/// Sub-objeto `variedades_cafe` de la respuesta de `GET /lotes/existencias`.
@freezed
class LoteVariedadDto with _$LoteVariedadDto {
  const factory LoteVariedadDto({required String nombre}) = _LoteVariedadDto;

  factory LoteVariedadDto.fromJson(Map<String, dynamic> json) =>
      _$LoteVariedadDtoFromJson(json);
}

/// Sub-objeto `niveles_altura` de la respuesta de `GET /lotes/existencias`.
@freezed
class LoteNivelAlturaDto with _$LoteNivelAlturaDto {
  const factory LoteNivelAlturaDto({required String nombre}) =
      _LoteNivelAlturaDto;

  factory LoteNivelAlturaDto.fromJson(Map<String, dynamic> json) =>
      _$LoteNivelAlturaDtoFromJson(json);
}
