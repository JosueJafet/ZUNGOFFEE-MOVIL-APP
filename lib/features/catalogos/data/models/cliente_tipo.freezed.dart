// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente_tipo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClienteTipo {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Create a copy of ClienteTipo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClienteTipoCopyWith<ClienteTipo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClienteTipoCopyWith<$Res> {
  factory $ClienteTipoCopyWith(
          ClienteTipo value, $Res Function(ClienteTipo) then) =
      _$ClienteTipoCopyWithImpl<$Res, ClienteTipo>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$ClienteTipoCopyWithImpl<$Res, $Val extends ClienteTipo>
    implements $ClienteTipoCopyWith<$Res> {
  _$ClienteTipoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClienteTipo
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
abstract class _$$ClienteTipoImplCopyWith<$Res>
    implements $ClienteTipoCopyWith<$Res> {
  factory _$$ClienteTipoImplCopyWith(
          _$ClienteTipoImpl value, $Res Function(_$ClienteTipoImpl) then) =
      __$$ClienteTipoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$ClienteTipoImplCopyWithImpl<$Res>
    extends _$ClienteTipoCopyWithImpl<$Res, _$ClienteTipoImpl>
    implements _$$ClienteTipoImplCopyWith<$Res> {
  __$$ClienteTipoImplCopyWithImpl(
      _$ClienteTipoImpl _value, $Res Function(_$ClienteTipoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClienteTipo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$ClienteTipoImpl(
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

class _$ClienteTipoImpl implements _ClienteTipo {
  const _$ClienteTipoImpl({required this.id, required this.nombre});

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'ClienteTipo(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClienteTipoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of ClienteTipo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClienteTipoImplCopyWith<_$ClienteTipoImpl> get copyWith =>
      __$$ClienteTipoImplCopyWithImpl<_$ClienteTipoImpl>(this, _$identity);
}

abstract class _ClienteTipo implements ClienteTipo {
  const factory _ClienteTipo(
      {required final int id,
      required final String nombre}) = _$ClienteTipoImpl;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of ClienteTipo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClienteTipoImplCopyWith<_$ClienteTipoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
