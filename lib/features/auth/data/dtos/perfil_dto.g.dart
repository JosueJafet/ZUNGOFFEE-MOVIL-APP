// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerfilDtoImpl _$$PerfilDtoImplFromJson(Map<String, dynamic> json) =>
    _$PerfilDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      estado: json['estado'] as bool,
      fechaCreacion: json['fecha_creacion'] as String,
      roles: PerfilRolDto.fromJson(json['roles'] as Map<String, dynamic>),
      tenants:
          PerfilTenantDto.fromJson(json['tenants'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PerfilDtoImplToJson(_$PerfilDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'estado': instance.estado,
      'fecha_creacion': instance.fechaCreacion,
      'roles': instance.roles,
      'tenants': instance.tenants,
    };

_$PerfilRolDtoImpl _$$PerfilRolDtoImplFromJson(Map<String, dynamic> json) =>
    _$PerfilRolDtoImpl(
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$PerfilRolDtoImplToJson(_$PerfilRolDtoImpl instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
    };

_$PerfilTenantDtoImpl _$$PerfilTenantDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PerfilTenantDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$PerfilTenantDtoImplToJson(
        _$PerfilTenantDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };
