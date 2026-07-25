// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procesamiento_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcesamientoDtoImpl _$$ProcesamientoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ProcesamientoDtoImpl(
      id: json['id'] as String,
      tenantId: (json['tenant_id'] as num).toInt(),
      loteOrigenId: json['lote_origen_id'] as String,
      loteDestinoId: json['lote_destino_id'] as String,
      cantidadEntrada: json['cantidad_entrada'] as String,
      cantidadSalida: json['cantidad_salida'] as String,
    );

Map<String, dynamic> _$$ProcesamientoDtoImplToJson(
        _$ProcesamientoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'lote_origen_id': instance.loteOrigenId,
      'lote_destino_id': instance.loteDestinoId,
      'cantidad_entrada': instance.cantidadEntrada,
      'cantidad_salida': instance.cantidadSalida,
    };
