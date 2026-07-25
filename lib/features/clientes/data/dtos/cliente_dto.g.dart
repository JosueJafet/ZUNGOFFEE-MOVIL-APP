// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClienteDtoImpl _$$ClienteDtoImplFromJson(Map<String, dynamic> json) =>
    _$ClienteDtoImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      tipoId: (json['tipo_id'] as num?)?.toInt(),
      lugar: json['lugar'] as String?,
      telefono: json['telefono'] as String?,
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$$ClienteDtoImplToJson(_$ClienteDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'nombre': instance.nombre,
      'tipo_id': instance.tipoId,
      'lugar': instance.lugar,
      'telefono': instance.telefono,
      'estado': instance.estado,
    };
