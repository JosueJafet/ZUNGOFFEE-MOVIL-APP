// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proveedor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProveedorDtoImpl _$$ProveedorDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProveedorDtoImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      nombre: json['nombre'] as String,
      sexo: json['sexo'] as String?,
      lugar: json['lugar'] as String?,
      finca: json['finca'] as String?,
      tipoId: (json['tipo_id'] as num?)?.toInt(),
      telefono: json['telefono'] as String?,
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$$ProveedorDtoImplToJson(_$ProveedorDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'nombre': instance.nombre,
      'sexo': instance.sexo,
      'lugar': instance.lugar,
      'finca': instance.finca,
      'tipo_id': instance.tipoId,
      'telefono': instance.telefono,
      'estado': instance.estado,
    };
