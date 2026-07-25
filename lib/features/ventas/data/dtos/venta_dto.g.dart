// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venta_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VentaDtoImpl _$$VentaDtoImplFromJson(Map<String, dynamic> json) =>
    _$VentaDtoImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      clienteId: (json['cliente_id'] as num).toInt(),
      usuarioId: (json['usuario_id'] as num).toInt(),
      total: json['total'] as String,
      anulada: json['anulada'] as bool,
    );

Map<String, dynamic> _$$VentaDtoImplToJson(_$VentaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'cliente_id': instance.clienteId,
      'usuario_id': instance.usuarioId,
      'total': instance.total,
      'anulada': instance.anulada,
    };
