// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venta_historial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VentaHistorial {
  int get id => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get clienteNombre => throw _privateConstructorUsedError;

  /// Create a copy of VentaHistorial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaHistorialCopyWith<VentaHistorial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaHistorialCopyWith<$Res> {
  factory $VentaHistorialCopyWith(
          VentaHistorial value, $Res Function(VentaHistorial) then) =
      _$VentaHistorialCopyWithImpl<$Res, VentaHistorial>;
  @useResult
  $Res call({int id, DateTime fecha, double total, String clienteNombre});
}

/// @nodoc
class _$VentaHistorialCopyWithImpl<$Res, $Val extends VentaHistorial>
    implements $VentaHistorialCopyWith<$Res> {
  _$VentaHistorialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VentaHistorial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? clienteNombre = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      clienteNombre: null == clienteNombre
          ? _value.clienteNombre
          : clienteNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VentaHistorialImplCopyWith<$Res>
    implements $VentaHistorialCopyWith<$Res> {
  factory _$$VentaHistorialImplCopyWith(_$VentaHistorialImpl value,
          $Res Function(_$VentaHistorialImpl) then) =
      __$$VentaHistorialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, DateTime fecha, double total, String clienteNombre});
}

/// @nodoc
class __$$VentaHistorialImplCopyWithImpl<$Res>
    extends _$VentaHistorialCopyWithImpl<$Res, _$VentaHistorialImpl>
    implements _$$VentaHistorialImplCopyWith<$Res> {
  __$$VentaHistorialImplCopyWithImpl(
      _$VentaHistorialImpl _value, $Res Function(_$VentaHistorialImpl) _then)
      : super(_value, _then);

  /// Create a copy of VentaHistorial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? clienteNombre = null,
  }) {
    return _then(_$VentaHistorialImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      clienteNombre: null == clienteNombre
          ? _value.clienteNombre
          : clienteNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VentaHistorialImpl implements _VentaHistorial {
  const _$VentaHistorialImpl(
      {required this.id,
      required this.fecha,
      required this.total,
      required this.clienteNombre});

  @override
  final int id;
  @override
  final DateTime fecha;
  @override
  final double total;
  @override
  final String clienteNombre;

  @override
  String toString() {
    return 'VentaHistorial(id: $id, fecha: $fecha, total: $total, clienteNombre: $clienteNombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaHistorialImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.clienteNombre, clienteNombre) ||
                other.clienteNombre == clienteNombre));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, fecha, total, clienteNombre);

  /// Create a copy of VentaHistorial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaHistorialImplCopyWith<_$VentaHistorialImpl> get copyWith =>
      __$$VentaHistorialImplCopyWithImpl<_$VentaHistorialImpl>(
          this, _$identity);
}

abstract class _VentaHistorial implements VentaHistorial {
  const factory _VentaHistorial(
      {required final int id,
      required final DateTime fecha,
      required final double total,
      required final String clienteNombre}) = _$VentaHistorialImpl;

  @override
  int get id;
  @override
  DateTime get fecha;
  @override
  double get total;
  @override
  String get clienteNombre;

  /// Create a copy of VentaHistorial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaHistorialImplCopyWith<_$VentaHistorialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
