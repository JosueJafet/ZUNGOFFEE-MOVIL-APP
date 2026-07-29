// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagos_resumen_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagosResumenDtoImpl _$$PagosResumenDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PagosResumenDtoImpl(
      tenantsActivos: (json['tenantsActivos'] as num).toInt(),
      tenantsSuspendidos: (json['tenantsSuspendidos'] as num).toInt(),
      ingresosMesActual: json['ingresosMesActual'] as String,
      ingresosTotales: json['ingresosTotales'] as String,
    );

Map<String, dynamic> _$$PagosResumenDtoImplToJson(
        _$PagosResumenDtoImpl instance) =>
    <String, dynamic>{
      'tenantsActivos': instance.tenantsActivos,
      'tenantsSuspendidos': instance.tenantsSuspendidos,
      'ingresosMesActual': instance.ingresosMesActual,
      'ingresosTotales': instance.ingresosTotales,
    };
