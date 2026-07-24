// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nivel_altura.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NivelAltura {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int? get msnmMin => throw _privateConstructorUsedError;
  int? get msnmMax => throw _privateConstructorUsedError;

  /// Create a copy of NivelAltura
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NivelAlturaCopyWith<NivelAltura> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NivelAlturaCopyWith<$Res> {
  factory $NivelAlturaCopyWith(
          NivelAltura value, $Res Function(NivelAltura) then) =
      _$NivelAlturaCopyWithImpl<$Res, NivelAltura>;
  @useResult
  $Res call({int id, String nombre, int? msnmMin, int? msnmMax});
}

/// @nodoc
class _$NivelAlturaCopyWithImpl<$Res, $Val extends NivelAltura>
    implements $NivelAlturaCopyWith<$Res> {
  _$NivelAlturaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NivelAltura
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? msnmMin = freezed,
    Object? msnmMax = freezed,
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
      msnmMin: freezed == msnmMin
          ? _value.msnmMin
          : msnmMin // ignore: cast_nullable_to_non_nullable
              as int?,
      msnmMax: freezed == msnmMax
          ? _value.msnmMax
          : msnmMax // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NivelAlturaImplCopyWith<$Res>
    implements $NivelAlturaCopyWith<$Res> {
  factory _$$NivelAlturaImplCopyWith(
          _$NivelAlturaImpl value, $Res Function(_$NivelAlturaImpl) then) =
      __$$NivelAlturaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre, int? msnmMin, int? msnmMax});
}

/// @nodoc
class __$$NivelAlturaImplCopyWithImpl<$Res>
    extends _$NivelAlturaCopyWithImpl<$Res, _$NivelAlturaImpl>
    implements _$$NivelAlturaImplCopyWith<$Res> {
  __$$NivelAlturaImplCopyWithImpl(
      _$NivelAlturaImpl _value, $Res Function(_$NivelAlturaImpl) _then)
      : super(_value, _then);

  /// Create a copy of NivelAltura
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? msnmMin = freezed,
    Object? msnmMax = freezed,
  }) {
    return _then(_$NivelAlturaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      msnmMin: freezed == msnmMin
          ? _value.msnmMin
          : msnmMin // ignore: cast_nullable_to_non_nullable
              as int?,
      msnmMax: freezed == msnmMax
          ? _value.msnmMax
          : msnmMax // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$NivelAlturaImpl implements _NivelAltura {
  const _$NivelAlturaImpl(
      {required this.id, required this.nombre, this.msnmMin, this.msnmMax});

  @override
  final int id;
  @override
  final String nombre;
  @override
  final int? msnmMin;
  @override
  final int? msnmMax;

  @override
  String toString() {
    return 'NivelAltura(id: $id, nombre: $nombre, msnmMin: $msnmMin, msnmMax: $msnmMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NivelAlturaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.msnmMin, msnmMin) || other.msnmMin == msnmMin) &&
            (identical(other.msnmMax, msnmMax) || other.msnmMax == msnmMax));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, msnmMin, msnmMax);

  /// Create a copy of NivelAltura
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NivelAlturaImplCopyWith<_$NivelAlturaImpl> get copyWith =>
      __$$NivelAlturaImplCopyWithImpl<_$NivelAlturaImpl>(this, _$identity);
}

abstract class _NivelAltura implements NivelAltura {
  const factory _NivelAltura(
      {required final int id,
      required final String nombre,
      final int? msnmMin,
      final int? msnmMax}) = _$NivelAlturaImpl;

  @override
  int get id;
  @override
  String get nombre;
  @override
  int? get msnmMin;
  @override
  int? get msnmMax;

  /// Create a copy of NivelAltura
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NivelAlturaImplCopyWith<_$NivelAlturaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
