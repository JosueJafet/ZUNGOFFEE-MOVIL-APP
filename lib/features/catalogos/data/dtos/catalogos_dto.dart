import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/catalogos.dart';
import '../models/cliente_tipo.dart';
import '../models/estado_cafe_catalogo.dart';
import '../models/metodo_pago.dart';
import '../models/nivel_altura.dart';
import '../models/unidad_medida.dart';
import '../models/variedad_cafe.dart';

part 'catalogos_dto.freezed.dart';
part 'catalogos_dto.g.dart';

/// DTO fiel al JSON de `GET /catalogos` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// secciones 6.1 y 8; `unidadesMedida` confirmado por
/// `CONTEXTO-PLATAFORMA-WEB.md`, sección 5). El contrato real trae 7
/// grupos; este DTO modela los que tienen un consumidor real hoy
/// (`metodosPago`, `variedadesCafe`, `nivelesAltura`, `estadosCafe`,
/// `clientesTipo` agregado en Sprint 7, `unidadesMedida` agregado al
/// mostrar la unidad real en vez de asumir "libras" en Existencias y
/// Procesamiento) — `proveedoresTipo` queda pendiente hasta que alguna
/// feature lo necesite (Sprint 7, Decisión 1: disciplina de alcance,
/// mismo criterio que Decisión arquitectónica #11).
@freezed
class CatalogosDto with _$CatalogosDto {
  const CatalogosDto._();

  const factory CatalogosDto({
    @JsonKey(name: 'metodosPago') required List<MetodoPagoDto> metodosPago,
    @JsonKey(name: 'variedadesCafe')
    required List<VariedadCafeDto> variedadesCafe,
    @JsonKey(name: 'nivelesAltura') required List<NivelAlturaDto> nivelesAltura,
    @JsonKey(name: 'estadosCafe')
    required List<EstadoCafeCatalogoDto> estadosCafe,
    @JsonKey(name: 'clientesTipo') required List<ClienteTipoDto> clientesTipo,
    @JsonKey(name: 'unidadesMedida')
    required List<UnidadMedidaDto> unidadesMedida,
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
      clientesTipo: clientesTipo.map((dto) => dto.toDomain()).toList(),
      unidadesMedida: unidadesMedida.map((dto) => dto.toDomain()).toList(),
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

/// Entrada del catálogo `clientesTipo` (Sprint 7).
@freezed
class ClienteTipoDto with _$ClienteTipoDto {
  const ClienteTipoDto._();

  const factory ClienteTipoDto({required int id, required String nombre}) =
      _ClienteTipoDto;

  factory ClienteTipoDto.fromJson(Map<String, dynamic> json) =>
      _$ClienteTipoDtoFromJson(json);

  ClienteTipo toDomain() => ClienteTipo(id: id, nombre: nombre);
}

/// Entrada del catálogo `unidadesMedida`.
@freezed
class UnidadMedidaDto with _$UnidadMedidaDto {
  const UnidadMedidaDto._();

  const factory UnidadMedidaDto({required int id, required String nombre}) =
      _UnidadMedidaDto;

  factory UnidadMedidaDto.fromJson(Map<String, dynamic> json) =>
      _$UnidadMedidaDtoFromJson(json);

  UnidadMedida toDomain() => UnidadMedida(id: id, nombre: nombre);
}
