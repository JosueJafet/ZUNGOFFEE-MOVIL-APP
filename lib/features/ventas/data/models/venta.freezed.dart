// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Venta {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  int get clienteId => throw _privateConstructorUsedError;
  int get usuarioId => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  bool get anulada => throw _privateConstructorUsedError;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaCopyWith<Venta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaCopyWith<$Res> {
  factory $VentaCopyWith(Venta value, $Res Function(Venta) then) =
      _$VentaCopyWithImpl<$Res, Venta>;
  @useResult
  $Res call(
      {int id,
      int tenantId,
      int clienteId,
      int usuarioId,
      double total,
      bool anulada});
}

/// @nodoc
class _$VentaCopyWithImpl<$Res, $Val extends Venta>
    implements $VentaCopyWith<$Res> {
  _$VentaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? clienteId = null,
    Object? usuarioId = null,
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
      clienteId: null == clienteId
          ? _value.clienteId
          : clienteId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$VentaImplCopyWith<$Res> implements $VentaCopyWith<$Res> {
  factory _$$VentaImplCopyWith(
          _$VentaImpl value, $Res Function(_$VentaImpl) then) =
      __$$VentaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int tenantId,
      int clienteId,
      int usuarioId,
      double total,
      bool anulada});
}

/// @nodoc
class __$$VentaImplCopyWithImpl<$Res>
    extends _$VentaCopyWithImpl<$Res, _$VentaImpl>
    implements _$$VentaImplCopyWith<$Res> {
  __$$VentaImplCopyWithImpl(
      _$VentaImpl _value, $Res Function(_$VentaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? clienteId = null,
    Object? usuarioId = null,
    Object? total = null,
    Object? anulada = null,
  }) {
    return _then(_$VentaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      clienteId: null == clienteId
          ? _value.clienteId
          : clienteId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
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

class _$VentaImpl implements _Venta {
  const _$VentaImpl(
      {required this.id,
      required this.tenantId,
      required this.clienteId,
      required this.usuarioId,
      required this.total,
      required this.anulada});

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final int clienteId;
  @override
  final int usuarioId;
  @override
  final double total;
  @override
  final bool anulada;

  @override
  String toString() {
    return 'Venta(id: $id, tenantId: $tenantId, clienteId: $clienteId, usuarioId: $usuarioId, total: $total, anulada: $anulada)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.anulada, anulada) || other.anulada == anulada));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, clienteId, usuarioId, total, anulada);

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaImplCopyWith<_$VentaImpl> get copyWith =>
      __$$VentaImplCopyWithImpl<_$VentaImpl>(this, _$identity);
}

abstract class _Venta implements Venta {
  const factory _Venta(
      {required final int id,
      required final int tenantId,
      required final int clienteId,
      required final int usuarioId,
      required final double total,
      required final bool anulada}) = _$VentaImpl;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  int get clienteId;
  @override
  int get usuarioId;
  @override
  double get total;
  @override
  bool get anulada;

  /// Create a copy of Venta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaImplCopyWith<_$VentaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
