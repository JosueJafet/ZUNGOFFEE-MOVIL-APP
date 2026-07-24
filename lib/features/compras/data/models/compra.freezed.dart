// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compra.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Compra {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  int get proveedorId => throw _privateConstructorUsedError;
  int get usuarioId => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  bool get anulada => throw _privateConstructorUsedError;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraCopyWith<Compra> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraCopyWith<$Res> {
  factory $CompraCopyWith(Compra value, $Res Function(Compra) then) =
      _$CompraCopyWithImpl<$Res, Compra>;
  @useResult
  $Res call(
      {int id,
      int tenantId,
      int proveedorId,
      int usuarioId,
      DateTime fecha,
      double total,
      bool anulada});
}

/// @nodoc
class _$CompraCopyWithImpl<$Res, $Val extends Compra>
    implements $CompraCopyWith<$Res> {
  _$CompraCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? proveedorId = null,
    Object? usuarioId = null,
    Object? fecha = null,
    Object? total = null,
    Object? anulada = null,
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
      proveedorId: null == proveedorId
          ? _value.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      anulada: null == anulada
          ? _value.anulada
          : anulada // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompraImplCopyWith<$Res> implements $CompraCopyWith<$Res> {
  factory _$$CompraImplCopyWith(
          _$CompraImpl value, $Res Function(_$CompraImpl) then) =
      __$$CompraImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int tenantId,
      int proveedorId,
      int usuarioId,
      DateTime fecha,
      double total,
      bool anulada});
}

/// @nodoc
class __$$CompraImplCopyWithImpl<$Res>
    extends _$CompraCopyWithImpl<$Res, _$CompraImpl>
    implements _$$CompraImplCopyWith<$Res> {
  __$$CompraImplCopyWithImpl(
      _$CompraImpl _value, $Res Function(_$CompraImpl) _then)
      : super(_value, _then);

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? proveedorId = null,
    Object? usuarioId = null,
    Object? fecha = null,
    Object? total = null,
    Object? anulada = null,
  }) {
    return _then(_$CompraImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      proveedorId: null == proveedorId
          ? _value.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      anulada: null == anulada
          ? _value.anulada
          : anulada // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CompraImpl implements _Compra {
  const _$CompraImpl(
      {required this.id,
      required this.tenantId,
      required this.proveedorId,
      required this.usuarioId,
      required this.fecha,
      required this.total,
      required this.anulada});

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final int proveedorId;
  @override
  final int usuarioId;
  @override
  final DateTime fecha;
  @override
  final double total;
  @override
  final bool anulada;

  @override
  String toString() {
    return 'Compra(id: $id, tenantId: $tenantId, proveedorId: $proveedorId, usuarioId: $usuarioId, fecha: $fecha, total: $total, anulada: $anulada)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.proveedorId, proveedorId) ||
                other.proveedorId == proveedorId) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.anulada, anulada) || other.anulada == anulada));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, proveedorId, usuarioId, fecha, total, anulada);

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraImplCopyWith<_$CompraImpl> get copyWith =>
      __$$CompraImplCopyWithImpl<_$CompraImpl>(this, _$identity);
}

abstract class _Compra implements Compra {
  const factory _Compra(
      {required final int id,
      required final int tenantId,
      required final int proveedorId,
      required final int usuarioId,
      required final DateTime fecha,
      required final double total,
      required final bool anulada}) = _$CompraImpl;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  int get proveedorId;
  @override
  int get usuarioId;
  @override
  DateTime get fecha;
  @override
  double get total;
  @override
  bool get anulada;

  /// Create a copy of Compra
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraImplCopyWith<_$CompraImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
