import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/catalogos.dart';
import '../models/estado_cafe_catalogo.dart';
import '../models/metodo_pago.dart';
import '../models/nivel_altura.dart';
import '../models/variedad_cafe.dart';

part 'catalogos_dto.freezed.dart';
part 'catalogos_dto.g.dart';

/// DTO fiel al JSON de `GET /catalogos` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// confirmado por el usuario: claves `metodosPago`, `variedadesCafe`,
/// `nivelesAltura`, `estadosCafe`). Los campos internos de cada catálogo
/// (`msnm_min`/`msnm_max`, `unidad_medida_id`) se asumen snake_case, igual
/// que el resto de las respuestas de la API (`fecha_creacion`,
/// `unidad_medida_id` ya visto en `GET /lotes/existencias`, etc.) — ajustar
/// si el contrato real dice lo contrario.
@freezed
class CatalogosDto with _$CatalogosDto {
  const CatalogosDto._();

  const factory CatalogosDto({
    @JsonKey(name: 'metodosPago') required List<MetodoPagoDto> metodosPago,
    @JsonKey(name: 'variedadesCafe')
    required List<VariedadCafeDto> variedadesCafe,
    @JsonKey(name: 'nivelesAltura')
    required List<NivelAlturaDto> nivelesAltura,
    @JsonKey(name: 'estadosCafe')
    required List<EstadoCafeCatalogoDto> estadosCafe,
  }) = _CatalogosDto;

  factory CatalogosDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogosDtoFromJson(json);

  /// Mapea este DTO al agregado de dominio `Catalogos`.
  Catalogos toDomain() {
    return Catalogos(
      metodosPago: metodosPago.map((dto) => dto.toDomain()).toList(),
      variedadesCafe: variedadesCafe.map((dto) => dto.toDomain()).toList(),
      nivelesAltura: nivelesAltura.map((dto) => dto.toDomain()).toList(),
      estadosCafe: estadosCafe.map((dto) => dto.toDomain()).toList(),
    );
  }
}

/// Entrada del catálogo `metodosPago`.
@freezed
class MetodoPagoDto with _$MetodoPagoDto {
  const MetodoPagoDto._();

  const factory MetodoPagoDto({required int id, required String nombre}) =
      _MetodoPagoDto;

  factory MetodoPagoDto.fromJson(Map<String, dynamic> json) =>
      _$MetodoPagoDtoFromJson(json);

  MetodoPago toDomain() => MetodoPago(id: id, nombre: nombre);
}

/// Entrada del catálogo `variedadesCafe`.
@freezed
class VariedadCafeDto with _$VariedadCafeDto {
  const VariedadCafeDto._();

  const factory VariedadCafeDto({required int id, required String nombre}) =
      _VariedadCafeDto;

  factory VariedadCafeDto.fromJson(Map<String, dynamic> json) =>
      _$VariedadCafeDtoFromJson(json);

  VariedadCafe toDomain() => VariedadCafe(id: id, nombre: nombre);
}

/// Entrada del catálogo `nivelesAltura`.
@freezed
class NivelAlturaDto with _$NivelAlturaDto {
  const NivelAlturaDto._();

  const factory NivelAlturaDto({
    required int id,
    required String nombre,
    @JsonKey(name: 'msnm_min') int? msnmMin,
    @JsonKey(name: 'msnm_max') int? msnmMax,
  }) = _NivelAlturaDto;

  factory NivelAlturaDto.fromJson(Map<String, dynamic> json) =>
      _$NivelAlturaDtoFromJson(json);

  NivelAltura toDomain() => NivelAltura(
    id: id,
    nombre: nombre,
    msnmMin: msnmMin,
    msnmMax: msnmMax,
  );
}

/// Entrada del catálogo `estadosCafe`.
@freezed
class EstadoCafeCatalogoDto with _$EstadoCafeCatalogoDto {
  const EstadoCafeCatalogoDto._();

  const factory EstadoCafeCatalogoDto({
    required int id,
    required String nombre,
    @JsonKey(name: 'unidad_medida_id') required int unidadMedidaId,
  }) = _EstadoCafeCatalogoDto;

  factory EstadoCafeCatalogoDto.fromJson(Map<String, dynamic> json) =>
      _$EstadoCafeCatalogoDtoFromJson(json);

  EstadoCafeCatalogo toDomain() => EstadoCafeCatalogo(
    id: id,
    nombre: nombre,
    unidadMedidaId: unidadMedidaId,
  );
}
