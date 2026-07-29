// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumen_diario_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResumenDiarioDtoImpl _$$ResumenDiarioDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ResumenDiarioDtoImpl(
      fecha: json['fecha'] as String,
      sum: ResumenSumaDto.fromJson(json['_sum'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResumenDiarioDtoImplToJson(
        _$ResumenDiarioDtoImpl instance) =>
    <String, dynamic>{
      'fecha': instance.fecha,
      '_sum': instance.sum,
    };

_$ResumenSumaDtoImpl _$$ResumenSumaDtoImplFromJson(Map<String, dynamic> json) =>
    _$ResumenSumaDtoImpl(
      total: json['total'] as String,
    );

Map<String, dynamic> _$$ResumenSumaDtoImplToJson(
        _$ResumenSumaDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
    };
