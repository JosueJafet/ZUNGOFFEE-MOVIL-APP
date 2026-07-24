// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metodo_pago.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MetodoPago {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Create a copy of MetodoPago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetodoPagoCopyWith<MetodoPago> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetodoPagoCopyWith<$Res> {
  factory $MetodoPagoCopyWith(
          MetodoPago value, $Res Function(MetodoPago) then) =
      _$MetodoPagoCopyWithImpl<$Res, MetodoPago>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$MetodoPagoCopyWithImpl<$Res, $Val extends MetodoPago>
    implements $MetodoPagoCopyWith<$Res> {
  _$MetodoPagoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetodoPago
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetodoPagoImplCopyWith<$Res>
    implements $MetodoPagoCopyWith<$Res> {
  factory _$$MetodoPagoImplCopyWith(
          _$MetodoPagoImpl value, $Res Function(_$MetodoPagoImpl) then) =
      __$$MetodoPagoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$MetodoPagoImplCopyWithImpl<$Res>
    extends _$MetodoPagoCopyWithImpl<$Res, _$MetodoPagoImpl>
    implements _$$MetodoPagoImplCopyWith<$Res> {
  __$$MetodoPagoImplCopyWithImpl(
      _$MetodoPagoImpl _value, $Res Function(_$MetodoPagoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetodoPago
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$MetodoPagoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MetodoPagoImpl implements _MetodoPago {
  const _$MetodoPagoImpl({required this.id, required this.nombre});

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'MetodoPago(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetodoPagoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of MetodoPago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetodoPagoImplCopyWith<_$MetodoPagoImpl> get copyWith =>
      __$$MetodoPagoImplCopyWithImpl<_$MetodoPagoImpl>(this, _$identity);
}

abstract class _MetodoPago implements MetodoPago {
  const factory _MetodoPago(
      {required final int id, required final String nombre}) = _$MetodoPagoImpl;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of MetodoPago
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetodoPagoImplCopyWith<_$MetodoPagoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
