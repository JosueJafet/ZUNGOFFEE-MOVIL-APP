// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compra_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompraDtoImpl _$$CompraDtoImplFromJson(Map<String, dynamic> json) =>
    _$CompraDtoImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      proveedorId: (json['proveedor_id'] as num).toInt(),
      usuarioId: (json['usuario_id'] as num).toInt(),
      fecha: json['fecha'] as String,
      total: json['total'] as String,
      anulada: json['anulada'] as bool,
    );

Map<String, dynamic> _$$CompraDtoImplToJson(_$CompraDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'proveedor_id': instance.proveedorId,
      'usuario_id': instance.usuarioId,
      'fecha': instance.fecha,
      'total': instance.total,
      'anulada': instance.anulada,
    };
