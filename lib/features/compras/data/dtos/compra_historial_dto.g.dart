// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compra_historial_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompraHistorialDtoImpl _$$CompraHistorialDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CompraHistorialDtoImpl(
      id: (json['id'] as num).toInt(),
      fecha: json['fecha'] as String,
      total: json['total'] as String,
      proveedores: CompraHistorialProveedorDto.fromJson(
          json['proveedores'] as Map<String, dynamic>),
      usuarios: CompraHistorialUsuarioDto.fromJson(
          json['usuarios'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompraHistorialDtoImplToJson(
        _$CompraHistorialDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha,
      'total': instance.total,
      'proveedores': instance.proveedores,
      'usuarios': instance.usuarios,
    };

_$CompraHistorialProveedorDtoImpl _$$CompraHistorialProveedorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CompraHistorialProveedorDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$CompraHistorialProveedorDtoImplToJson(
        _$CompraHistorialProveedorDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };

_$CompraHistorialUsuarioDtoImpl _$$CompraHistorialUsuarioDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CompraHistorialUsuarioDtoImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$$CompraHistorialUsuarioDtoImplToJson(
        _$CompraHistorialUsuarioDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };
