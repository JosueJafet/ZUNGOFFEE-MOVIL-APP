// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solicitud_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SolicitudDtoImpl _$$SolicitudDtoImplFromJson(Map<String, dynamic> json) =>
    _$SolicitudDtoImpl(
      id: (json['id'] as num).toInt(),
      nombreBodega: json['nombre_bodega'] as String,
      nombreContacto: json['nombre_contacto'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      mensaje: json['mensaje'] as String?,
      estadoId: (json['estado_id'] as num).toInt(),
      tenantCreadoId: (json['tenant_creado_id'] as num?)?.toInt(),
      fechaCreacion: json['fecha_creacion'] as String,
    );

Map<String, dynamic> _$$SolicitudDtoImplToJson(_$SolicitudDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre_bodega': instance.nombreBodega,
      'nombre_contacto': instance.nombreContacto,
      'email': instance.email,
      'telefono': instance.telefono,
      'mensaje': instance.mensaje,
      'estado_id': instance.estadoId,
      'tenant_creado_id': instance.tenantCreadoId,
      'fecha_creacion': instance.fechaCreacion,
    };
