// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venta_historial_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VentaHistorialDtoImpl _$$VentaHistorialDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$VentaHistorialDtoImpl(
      id: (json['id'] as num).toInt(),
      fecha: json['fecha'] as String,
      total: json['total'] as String,
      clientes: VentaHistorialClienteDto.fromJson(
          json['clientes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VentaHistorialDtoImplToJson(
        _$VentaHistorialDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha,
      'total': instance.total,
      'clientes': instance.clientes,
    };

_$VentaHistorialClienteDtoImpl _$$VentaHistorialClienteDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$VentaHistorialClienteDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$VentaHistorialClienteDtoImplToJson(
        _$VentaHistorialClienteDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };
