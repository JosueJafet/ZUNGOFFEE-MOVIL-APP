// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pago_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PagoDto _$PagoDtoFromJson(Map<String, dynamic> json) {
  return _PagoDto.fromJson(json);
}

/// @nodoc
mixin _$PagoDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  String get periodo => throw _privateConstructorUsedError;
  String get monto => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_vencimiento')
  String get fechaVencimiento => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_pago')
  String? get fechaPago => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_pago_id')
  int get estadoPagoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'registrado_por')
  int get registradoPor => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_calculado')
  String get estadoCalculado => throw _privateConstructorUsedError;

  /// Serializes this PagoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PagoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagoDtoCopyWith<PagoDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagoDtoCopyWith<$Res> {
  factory $PagoDtoCopyWith(PagoDto value, $Res Function(PagoDto) then) =
      _$PagoDtoCopyWithImpl<$Res, PagoDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String periodo,
      String monto,
      @JsonKey(name: 'fecha_vencimiento') String fechaVencimiento,
      @JsonKey(name: 'fecha_pago') String? fechaPago,
      @JsonKey(name: 'estado_pago_id') int estadoPagoId,
      @JsonKey(name: 'registrado_por') int registradoPor,
      @JsonKey(name: 'estado_calculado') String estadoCalculado});
}

/// @nodoc
class _$PagoDtoCopyWithImpl<$Res, $Val extends PagoDto>
    implements $PagoDtoCopyWith<$Res> {
  _$PagoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PagoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? periodo = null,
    Object? monto = null,
    Object? fechaVencimiento = null,
    Object? fechaPago = freezed,
    Object? estadoPagoId = null,
    Object? registradoPor = null,
    Object? estadoCalculado = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      periodo: null == periodo
          ? _value.periodo
          : periodo // ignore: cast_nullable_to_non_nullable
              as String,
      monto: null == monto
          ? _value.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as String,
      fechaVencimiento: null == fechaVencimiento
          ? _value.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as String,
      fechaPago: freezed == fechaPago
          ? _value.fechaPago
          : fechaPago // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoPagoId: null == estadoPagoId
          ? _value.estadoPagoId
          : estadoPagoId // ignore: cast_nullable_to_non_nullable
              as int,
      registradoPor: null == registradoPor
          ? _value.registradoPor
          : registradoPor // ignore: cast_nullable_to_non_nullable
              as int,
      estadoCalculado: null == estadoCalculado
          ? _value.estadoCalculado
          : estadoCalculado // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PagoDtoImplCopyWith<$Res> implements $PagoDtoCopyWith<$Res> {
  factory _$$PagoDtoImplCopyWith(
          _$PagoDtoImpl value, $Res Function(_$PagoDtoImpl) then) =
      __$$PagoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String periodo,
      String monto,
      @JsonKey(name: 'fecha_vencimiento') String fechaVencimiento,
      @JsonKey(name: 'fecha_pago') String? fechaPago,
      @JsonKey(name: 'estado_pago_id') int estadoPagoId,
      @JsonKey(name: 'registrado_por') int registradoPor,
      @JsonKey(name: 'estado_calculado') String estadoCalculado});
}

/// @nodoc
class __$$PagoDtoImplCopyWithImpl<$Res>
    extends _$PagoDtoCopyWithImpl<$Res, _$PagoDtoImpl>
    implements _$$PagoDtoImplCopyWith<$Res> {
  __$$PagoDtoImplCopyWithImpl(
      _$PagoDtoImpl _value, $Res Function(_$PagoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? periodo = null,
    Object? monto = null,
    Object? fechaVencimiento = null,
    Object? fechaPago = freezed,
    Object? estadoPagoId = null,
    Object? registradoPor = null,
    Object? estadoCalculado = null,
  }) {
    return _then(_$PagoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      periodo: null == periodo
          ? _value.periodo
          : periodo // ignore: cast_nullable_to_non_nullable
              as String,
      monto: null == monto
          ? _value.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as String,
      fechaVencimiento: null == fechaVencimiento
          ? _value.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as String,
      fechaPago: freezed == fechaPago
          ? _value.fechaPago
          : fechaPago // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoPagoId: null == estadoPagoId
          ? _value.estadoPagoId
          : estadoPagoId // ignore: cast_nullable_to_non_nullable
              as int,
      registradoPor: null == registradoPor
          ? _value.registradoPor
          : registradoPor // ignore: cast_nullable_to_non_nullable
              as int,
      estadoCalculado: null == estadoCalculado
          ? _value.estadoCalculado
          : estadoCalculado // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PagoDtoImpl extends _PagoDto {
  const _$PagoDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      required this.periodo,
      required this.monto,
      @JsonKey(name: 'fecha_vencimiento') required this.fechaVencimiento,
      @JsonKey(name: 'fecha_pago') this.fechaPago,
      @JsonKey(name: 'estado_pago_id') required this.estadoPagoId,
      @JsonKey(name: 'registrado_por') required this.registradoPor,
      @JsonKey(name: 'estado_calculado') required this.estadoCalculado})
      : super._();

  factory _$PagoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PagoDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  final String periodo;
  @override
  final String monto;
  @override
  @JsonKey(name: 'fecha_vencimiento')
  final String fechaVencimiento;
  @override
  @JsonKey(name: 'fecha_pago')
  final String? fechaPago;
  @override
  @JsonKey(name: 'estado_pago_id')
  final int estadoPagoId;
  @override
  @JsonKey(name: 'registrado_por')
  final int registradoPor;
  @override
  @JsonKey(name: 'estado_calculado')
  final String estadoCalculado;

  @override
  String toString() {
    return 'PagoDto(id: $id, tenantId: $tenantId, periodo: $periodo, monto: $monto, fechaVencimiento: $fechaVencimiento, fechaPago: $fechaPago, estadoPagoId: $estadoPagoId, registradoPor: $registradoPor, estadoCalculado: $estadoCalculado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.periodo, periodo) || other.periodo == periodo) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            (identical(other.fechaVencimiento, fechaVencimiento) ||
                other.fechaVencimiento == fechaVencimiento) &&
            (identical(other.fechaPago, fechaPago) ||
                other.fechaPago == fechaPago) &&
            (identical(other.estadoPagoId, estadoPagoId) ||
                other.estadoPagoId == estadoPagoId) &&
            (identical(other.registradoPor, registradoPor) ||
                other.registradoPor == registradoPor) &&
            (identical(other.estadoCalculado, estadoCalculado) ||
                other.estadoCalculado == estadoCalculado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tenantId,
      periodo,
      monto,
      fechaVencimiento,
      fechaPago,
      estadoPagoId,
      registradoPor,
      estadoCalculado);

  /// Create a copy of PagoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagoDtoImplCopyWith<_$PagoDtoImpl> get copyWith =>
      __$$PagoDtoImplCopyWithImpl<_$PagoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PagoDtoImplToJson(
      this,
    );
  }
}

abstract class _PagoDto extends PagoDto {
  const factory _PagoDto(
      {required final int id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      required final String periodo,
      required final String monto,
      @JsonKey(name: 'fecha_vencimiento')
      required final String fechaVencimiento,
      @JsonKey(name: 'fecha_pago') final String? fechaPago,
      @JsonKey(name: 'estado_pago_id') required final int estadoPagoId,
      @JsonKey(name: 'registrado_por') required final int registradoPor,
      @JsonKey(name: 'estado_calculado')
      required final String estadoCalculado}) = _$PagoDtoImpl;
  const _PagoDto._() : super._();

  factory _PagoDto.fromJson(Map<String, dynamic> json) = _$PagoDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  String get periodo;
  @override
  String get monto;
  @override
  @JsonKey(name: 'fecha_vencimiento')
  String get fechaVencimiento;
  @override
  @JsonKey(name: 'fecha_pago')
  String? get fechaPago;
  @override
  @JsonKey(name: 'estado_pago_id')
  int get estadoPagoId;
  @override
  @JsonKey(name: 'registrado_por')
  int get registradoPor;
  @override
  @JsonKey(name: 'estado_calculado')
  String get estadoCalculado;

  /// Create a copy of PagoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagoDtoImplCopyWith<_$PagoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
