// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pago_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagoDtoImpl _$$PagoDtoImplFromJson(Map<String, dynamic> json) =>
    _$PagoDtoImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      periodo: json['periodo'] as String,
      monto: json['monto'] as String,
      fechaVencimiento: json['fecha_vencimiento'] as String,
      fechaPago: json['fecha_pago'] as String?,
      estadoPagoId: (json['estado_pago_id'] as num).toInt(),
      registradoPor: (json['registrado_por'] as num).toInt(),
      estadoCalculado: json['estado_calculado'] as String,
    );

Map<String, dynamic> _$$PagoDtoImplToJson(_$PagoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'periodo': instance.periodo,
      'monto': instance.monto,
      'fecha_vencimiento': instance.fechaVencimiento,
      'fecha_pago': instance.fechaPago,
      'estado_pago_id': instance.estadoPagoId,
      'registrado_por': instance.registradoPor,
      'estado_calculado': instance.estadoCalculado,
    };
