// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoteDtoImpl _$$LoteDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoteDtoImpl(
      id: json['id'] as String,
      saldo: json['saldo'] as String,
      cantidadInicial: json['cantidad_inicial'] as String,
      estadosCafe: LoteEstadoCafeDto.fromJson(
          json['estados_cafe'] as Map<String, dynamic>),
      variedadesCafe: LoteVariedadDto.fromJson(
          json['variedades_cafe'] as Map<String, dynamic>),
      nivelesAltura: LoteNivelAlturaDto.fromJson(
          json['niveles_altura'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoteDtoImplToJson(_$LoteDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saldo': instance.saldo,
      'cantidad_inicial': instance.cantidadInicial,
      'estados_cafe': instance.estadosCafe,
      'variedades_cafe': instance.variedadesCafe,
      'niveles_altura': instance.nivelesAltura,
    };

_$LoteEstadoCafeDtoImpl _$$LoteEstadoCafeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LoteEstadoCafeDtoImpl(
      nombre: json['nombre'] as String,
      unidadMedidaId: (json['unidad_medida_id'] as num).toInt(),
    );

Map<String, dynamic> _$$LoteEstadoCafeDtoImplToJson(
        _$LoteEstadoCafeDtoImpl instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'unidad_medida_id': instance.unidadMedidaId,
    };

_$LoteVariedadDtoImpl _$$LoteVariedadDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LoteVariedadDtoImpl(
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$LoteVariedadDtoImplToJson(
        _$LoteVariedadDtoImpl instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
    };

_$LoteNivelAlturaDtoImpl _$$LoteNivelAlturaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LoteNivelAlturaDtoImpl(
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$LoteNivelAlturaDtoImplToJson(
        _$LoteNivelAlturaDtoImpl instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
    };
