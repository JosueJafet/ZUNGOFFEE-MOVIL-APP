// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificacionDtoImpl _$$NotificacionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificacionDtoImpl(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      leida: json['leida'] as bool,
    );

Map<String, dynamic> _$$NotificacionDtoImplToJson(
        _$NotificacionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'mensaje': instance.mensaje,
      'leida': instance.leida,
    };
