// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodega_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodegaDtoImpl _$$BodegaDtoImplFromJson(Map<String, dynamic> json) =>
    _$BodegaDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      estadoId: (json['estado_id'] as num).toInt(),
      fechaRegistro: json['fecha_registro'] as String,
      diasRestantes: (json['dias_restantes'] as num?)?.toInt(),
      estadoPagoCalculado: json['estado_pago_calculado'] as String?,
    );

Map<String, dynamic> _$$BodegaDtoImplToJson(_$BodegaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'estado_id': instance.estadoId,
      'fecha_registro': instance.fechaRegistro,
      'dias_restantes': instance.diasRestantes,
      'estado_pago_calculado': instance.estadoPagoCalculado,
    };
