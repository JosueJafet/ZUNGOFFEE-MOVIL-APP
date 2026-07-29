// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compra_historial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CompraHistorial {
  int get id => throw _privateConstructorUsedError;
  DateTime get fecha => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get proveedorNombre => throw _privateConstructorUsedError;
  String get usuarioNombre => throw _privateConstructorUsedError;

  /// Create a copy of CompraHistorial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraHistorialCopyWith<CompraHistorial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraHistorialCopyWith<$Res> {
  factory $CompraHistorialCopyWith(
          CompraHistorial value, $Res Function(CompraHistorial) then) =
      _$CompraHistorialCopyWithImpl<$Res, CompraHistorial>;
  @useResult
  $Res call(
      {int id,
      DateTime fecha,
      double total,
      String proveedorNombre,
      String usuarioNombre});
}

/// @nodoc
class _$CompraHistorialCopyWithImpl<$Res, $Val extends CompraHistorial>
    implements $CompraHistorialCopyWith<$Res> {
  _$CompraHistorialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompraHistorial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? proveedorNombre = null,
    Object? usuarioNombre = null,
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
      proveedorNombre: null == proveedorNombre
          ? _value.proveedorNombre
          : proveedorNombre // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioNombre: null == usuarioNombre
          ? _value.usuarioNombre
          : usuarioNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompraHistorialImplCopyWith<$Res>
    implements $CompraHistorialCopyWith<$Res> {
  factory _$$CompraHistorialImplCopyWith(_$CompraHistorialImpl value,
          $Res Function(_$CompraHistorialImpl) then) =
      __$$CompraHistorialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime fecha,
      double total,
      String proveedorNombre,
      String usuarioNombre});
}

/// @nodoc
class __$$CompraHistorialImplCopyWithImpl<$Res>
    extends _$CompraHistorialCopyWithImpl<$Res, _$CompraHistorialImpl>
    implements _$$CompraHistorialImplCopyWith<$Res> {
  __$$CompraHistorialImplCopyWithImpl(
      _$CompraHistorialImpl _value, $Res Function(_$CompraHistorialImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompraHistorial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? proveedorNombre = null,
    Object? usuarioNombre = null,
  }) {
    return _then(_$CompraHistorialImpl(
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
      proveedorNombre: null == proveedorNombre
          ? _value.proveedorNombre
          : proveedorNombre // ignore: cast_nullable_to_non_nullable
              as String,
      usuarioNombre: null == usuarioNombre
          ? _value.usuarioNombre
          : usuarioNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CompraHistorialImpl implements _CompraHistorial {
  const _$CompraHistorialImpl(
      {required this.id,
      required this.fecha,
      required this.total,
      required this.proveedorNombre,
      required this.usuarioNombre});

  @override
  final int id;
  @override
  final DateTime fecha;
  @override
  final double total;
  @override
  final String proveedorNombre;
  @override
  final String usuarioNombre;

  @override
  String toString() {
    return 'CompraHistorial(id: $id, fecha: $fecha, total: $total, proveedorNombre: $proveedorNombre, usuarioNombre: $usuarioNombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraHistorialImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.proveedorNombre, proveedorNombre) ||
                other.proveedorNombre == proveedorNombre) &&
            (identical(other.usuarioNombre, usuarioNombre) ||
                other.usuarioNombre == usuarioNombre));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, fecha, total, proveedorNombre, usuarioNombre);

  /// Create a copy of CompraHistorial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraHistorialImplCopyWith<_$CompraHistorialImpl> get copyWith =>
      __$$CompraHistorialImplCopyWithImpl<_$CompraHistorialImpl>(
          this, _$identity);
}

abstract class _CompraHistorial implements CompraHistorial {
  const factory _CompraHistorial(
      {required final int id,
      required final DateTime fecha,
      required final double total,
      required final String proveedorNombre,
      required final String usuarioNombre}) = _$CompraHistorialImpl;

  @override
  int get id;
  @override
  DateTime get fecha;
  @override
  double get total;
  @override
  String get proveedorNombre;
  @override
  String get usuarioNombre;

  /// Create a copy of CompraHistorial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraHistorialImplCopyWith<_$CompraHistorialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
