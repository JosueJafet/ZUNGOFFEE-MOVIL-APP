// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pago.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Pago {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  DateTime get periodo => throw _privateConstructorUsedError;
  double get monto => throw _privateConstructorUsedError;
  DateTime get fechaVencimiento => throw _privateConstructorUsedError;
  DateTime? get fechaPago => throw _privateConstructorUsedError;
  int get estadoPagoId => throw _privateConstructorUsedError;
  int get registradoPor =>
      throw _privateConstructorUsedError; // "pagado" / "vencido" / "pendiente" — ya resuelto por el servidor
// (`GET /pagos/tenant/:id`), no se recalcula del lado del cliente.
  String get estadoCalculado => throw _privateConstructorUsedError;

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagoCopyWith<Pago> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagoCopyWith<$Res> {
  factory $PagoCopyWith(Pago value, $Res Function(Pago) then) =
      _$PagoCopyWithImpl<$Res, Pago>;
  @useResult
  $Res call(
      {int id,
      int tenantId,
      DateTime periodo,
      double monto,
      DateTime fechaVencimiento,
      DateTime? fechaPago,
      int estadoPagoId,
      int registradoPor,
      String estadoCalculado});
}

/// @nodoc
class _$PagoCopyWithImpl<$Res, $Val extends Pago>
    implements $PagoCopyWith<$Res> {
  _$PagoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pago
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
              as DateTime,
      monto: null == monto
          ? _value.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as double,
      fechaVencimiento: null == fechaVencimiento
          ? _value.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fechaPago: freezed == fechaPago
          ? _value.fechaPago
          : fechaPago // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$PagoImplCopyWith<$Res> implements $PagoCopyWith<$Res> {
  factory _$$PagoImplCopyWith(
          _$PagoImpl value, $Res Function(_$PagoImpl) then) =
      __$$PagoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int tenantId,
      DateTime periodo,
      double monto,
      DateTime fechaVencimiento,
      DateTime? fechaPago,
      int estadoPagoId,
      int registradoPor,
      String estadoCalculado});
}

/// @nodoc
class __$$PagoImplCopyWithImpl<$Res>
    extends _$PagoCopyWithImpl<$Res, _$PagoImpl>
    implements _$$PagoImplCopyWith<$Res> {
  __$$PagoImplCopyWithImpl(_$PagoImpl _value, $Res Function(_$PagoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pago
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
    return _then(_$PagoImpl(
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
              as DateTime,
      monto: null == monto
          ? _value.monto
          : monto // ignore: cast_nullable_to_non_nullable
              as double,
      fechaVencimiento: null == fechaVencimiento
          ? _value.fechaVencimiento
          : fechaVencimiento // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fechaPago: freezed == fechaPago
          ? _value.fechaPago
          : fechaPago // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

class _$PagoImpl implements _Pago {
  const _$PagoImpl(
      {required this.id,
      required this.tenantId,
      required this.periodo,
      required this.monto,
      required this.fechaVencimiento,
      this.fechaPago,
      required this.estadoPagoId,
      required this.registradoPor,
      required this.estadoCalculado});

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final DateTime periodo;
  @override
  final double monto;
  @override
  final DateTime fechaVencimiento;
  @override
  final DateTime? fechaPago;
  @override
  final int estadoPagoId;
  @override
  final int registradoPor;
// "pagado" / "vencido" / "pendiente" — ya resuelto por el servidor
// (`GET /pagos/tenant/:id`), no se recalcula del lado del cliente.
  @override
  final String estadoCalculado;

  @override
  String toString() {
    return 'Pago(id: $id, tenantId: $tenantId, periodo: $periodo, monto: $monto, fechaVencimiento: $fechaVencimiento, fechaPago: $fechaPago, estadoPagoId: $estadoPagoId, registradoPor: $registradoPor, estadoCalculado: $estadoCalculado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagoImpl &&
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

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagoImplCopyWith<_$PagoImpl> get copyWith =>
      __$$PagoImplCopyWithImpl<_$PagoImpl>(this, _$identity);
}

abstract class _Pago implements Pago {
  const factory _Pago(
      {required final int id,
      required final int tenantId,
      required final DateTime periodo,
      required final double monto,
      required final DateTime fechaVencimiento,
      final DateTime? fechaPago,
      required final int estadoPagoId,
      required final int registradoPor,
      required final String estadoCalculado}) = _$PagoImpl;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  DateTime get periodo;
  @override
  double get monto;
  @override
  DateTime get fechaVencimiento;
  @override
  DateTime? get fechaPago;
  @override
  int get estadoPagoId;
  @override
  int get registradoPor; // "pagado" / "vencido" / "pendiente" — ya resuelto por el servidor
// (`GET /pagos/tenant/:id`), no se recalcula del lado del cliente.
  @override
  String get estadoCalculado;

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagoImplCopyWith<_$PagoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
