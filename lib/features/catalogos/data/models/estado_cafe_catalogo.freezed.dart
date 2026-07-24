// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estado_cafe_catalogo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EstadoCafeCatalogo {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int get unidadMedidaId => throw _privateConstructorUsedError;

  /// Create a copy of EstadoCafeCatalogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstadoCafeCatalogoCopyWith<EstadoCafeCatalogo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstadoCafeCatalogoCopyWith<$Res> {
  factory $EstadoCafeCatalogoCopyWith(
          EstadoCafeCatalogo value, $Res Function(EstadoCafeCatalogo) then) =
      _$EstadoCafeCatalogoCopyWithImpl<$Res, EstadoCafeCatalogo>;
  @useResult
  $Res call({int id, String nombre, int unidadMedidaId});
}

/// @nodoc
class _$EstadoCafeCatalogoCopyWithImpl<$Res, $Val extends EstadoCafeCatalogo>
    implements $EstadoCafeCatalogoCopyWith<$Res> {
  _$EstadoCafeCatalogoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstadoCafeCatalogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? unidadMedidaId = null,
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
      unidadMedidaId: null == unidadMedidaId
          ? _value.unidadMedidaId
          : unidadMedidaId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EstadoCafeCatalogoImplCopyWith<$Res>
    implements $EstadoCafeCatalogoCopyWith<$Res> {
  factory _$$EstadoCafeCatalogoImplCopyWith(_$EstadoCafeCatalogoImpl value,
          $Res Function(_$EstadoCafeCatalogoImpl) then) =
      __$$EstadoCafeCatalogoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre, int unidadMedidaId});
}

/// @nodoc
class __$$EstadoCafeCatalogoImplCopyWithImpl<$Res>
    extends _$EstadoCafeCatalogoCopyWithImpl<$Res, _$EstadoCafeCatalogoImpl>
    implements _$$EstadoCafeCatalogoImplCopyWith<$Res> {
  __$$EstadoCafeCatalogoImplCopyWithImpl(_$EstadoCafeCatalogoImpl _value,
      $Res Function(_$EstadoCafeCatalogoImpl) _then)
      : super(_value, _then);

  /// Create a copy of EstadoCafeCatalogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? unidadMedidaId = null,
  }) {
    return _then(_$EstadoCafeCatalogoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      unidadMedidaId: null == unidadMedidaId
          ? _value.unidadMedidaId
          : unidadMedidaId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$EstadoCafeCatalogoImpl implements _EstadoCafeCatalogo {
  const _$EstadoCafeCatalogoImpl(
      {required this.id, required this.nombre, required this.unidadMedidaId});

  @override
  final int id;
  @override
  final String nombre;
  @override
  final int unidadMedidaId;

  @override
  String toString() {
    return 'EstadoCafeCatalogo(id: $id, nombre: $nombre, unidadMedidaId: $unidadMedidaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstadoCafeCatalogoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.unidadMedidaId, unidadMedidaId) ||
                other.unidadMedidaId == unidadMedidaId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, unidadMedidaId);

  /// Create a copy of EstadoCafeCatalogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstadoCafeCatalogoImplCopyWith<_$EstadoCafeCatalogoImpl> get copyWith =>
      __$$EstadoCafeCatalogoImplCopyWithImpl<_$EstadoCafeCatalogoImpl>(
          this, _$identity);
}

abstract class _EstadoCafeCatalogo implements EstadoCafeCatalogo {
  const factory _EstadoCafeCatalogo(
      {required final int id,
      required final String nombre,
      required final int unidadMedidaId}) = _$EstadoCafeCatalogoImpl;

  @override
  int get id;
  @override
  String get nombre;
  @override
  int get unidadMedidaId;

  /// Create a copy of EstadoCafeCatalogo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstadoCafeCatalogoImplCopyWith<_$EstadoCafeCatalogoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
