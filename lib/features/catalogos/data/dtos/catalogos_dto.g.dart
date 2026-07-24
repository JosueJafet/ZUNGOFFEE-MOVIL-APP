// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogos_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogosDtoImpl _$$CatalogosDtoImplFromJson(Map<String, dynamic> json) =>
    _$CatalogosDtoImpl(
      metodosPago: (json['metodosPago'] as List<dynamic>)
          .map((e) => MetodoPagoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      variedadesCafe: (json['variedadesCafe'] as List<dynamic>)
          .map((e) => VariedadCafeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nivelesAltura: (json['nivelesAltura'] as List<dynamic>)
          .map((e) => NivelAlturaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      estadosCafe: (json['estadosCafe'] as List<dynamic>)
          .map((e) => EstadoCafeCatalogoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CatalogosDtoImplToJson(_$CatalogosDtoImpl instance) =>
    <String, dynamic>{
      'metodosPago': instance.metodosPago,
      'variedadesCafe': instance.variedadesCafe,
      'nivelesAltura': instance.nivelesAltura,
      'estadosCafe': instance.estadosCafe,
    };

_$MetodoPagoDtoImpl _$$MetodoPagoDtoImplFromJson(Map<String, dynamic> json) =>
    _$MetodoPagoDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$MetodoPagoDtoImplToJson(_$MetodoPagoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };

_$VariedadCafeDtoImpl _$$VariedadCafeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$VariedadCafeDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$VariedadCafeDtoImplToJson(
        _$VariedadCafeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };

_$NivelAlturaDtoImpl _$$NivelAlturaDtoImplFromJson(Map<String, dynamic> json) =>
    _$NivelAlturaDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      msnmMin: (json['msnm_min'] as num?)?.toInt(),
      msnmMax: (json['msnm_max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NivelAlturaDtoImplToJson(
        _$NivelAlturaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'msnm_min': instance.msnmMin,
      'msnm_max': instance.msnmMax,
    };

_$EstadoCafeCatalogoDtoImpl _$$EstadoCafeCatalogoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EstadoCafeCatalogoDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      unidadMedidaId: (json['unidad_medida_id'] as num).toInt(),
    );

Map<String, dynamic> _$$EstadoCafeCatalogoDtoImplToJson(
        _$EstadoCafeCatalogoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'unidad_medida_id': instance.unidadMedidaId,
    };
