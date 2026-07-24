// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variedad_cafe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VariedadCafe {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Create a copy of VariedadCafe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariedadCafeCopyWith<VariedadCafe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariedadCafeCopyWith<$Res> {
  factory $VariedadCafeCopyWith(
          VariedadCafe value, $Res Function(VariedadCafe) then) =
      _$VariedadCafeCopyWithImpl<$Res, VariedadCafe>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$VariedadCafeCopyWithImpl<$Res, $Val extends VariedadCafe>
    implements $VariedadCafeCopyWith<$Res> {
  _$VariedadCafeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariedadCafe
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
abstract class _$$VariedadCafeImplCopyWith<$Res>
    implements $VariedadCafeCopyWith<$Res> {
  factory _$$VariedadCafeImplCopyWith(
          _$VariedadCafeImpl value, $Res Function(_$VariedadCafeImpl) then) =
      __$$VariedadCafeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$VariedadCafeImplCopyWithImpl<$Res>
    extends _$VariedadCafeCopyWithImpl<$Res, _$VariedadCafeImpl>
    implements _$$VariedadCafeImplCopyWith<$Res> {
  __$$VariedadCafeImplCopyWithImpl(
      _$VariedadCafeImpl _value, $Res Function(_$VariedadCafeImpl) _then)
      : super(_value, _then);

  /// Create a copy of VariedadCafe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$VariedadCafeImpl(
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

class _$VariedadCafeImpl implements _VariedadCafe {
  const _$VariedadCafeImpl({required this.id, required this.nombre});

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'VariedadCafe(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariedadCafeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of VariedadCafe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariedadCafeImplCopyWith<_$VariedadCafeImpl> get copyWith =>
      __$$VariedadCafeImplCopyWithImpl<_$VariedadCafeImpl>(this, _$identity);
}

abstract class _VariedadCafe implements VariedadCafe {
  const factory _VariedadCafe(
      {required final int id,
      required final String nombre}) = _$VariedadCafeImpl;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of VariedadCafe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariedadCafeImplCopyWith<_$VariedadCafeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
