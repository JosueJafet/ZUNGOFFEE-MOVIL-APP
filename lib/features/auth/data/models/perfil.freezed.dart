// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Perfil {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  bool get activo => throw _privateConstructorUsedError;
  DateTime get fechaCreacion => throw _privateConstructorUsedError;
  String get rol => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  String get tenantNombre => throw _privateConstructorUsedError;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilCopyWith<Perfil> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilCopyWith<$Res> {
  factory $PerfilCopyWith(Perfil value, $Res Function(Perfil) then) =
      _$PerfilCopyWithImpl<$Res, Perfil>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      bool activo,
      DateTime fechaCreacion,
      String rol,
      int tenantId,
      String tenantNombre});
}

/// @nodoc
class _$PerfilCopyWithImpl<$Res, $Val extends Perfil>
    implements $PerfilCopyWith<$Res> {
  _$PerfilCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? activo = null,
    Object? fechaCreacion = null,
    Object? rol = null,
    Object? tenantId = null,
    Object? tenantNombre = null,
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
      activo: null == activo
          ? _value.activo
          : activo // ignore: cast_nullable_to_non_nullable
              as bool,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rol: null == rol
          ? _value.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantNombre: null == tenantNombre
          ? _value.tenantNombre
          : tenantNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerfilImplCopyWith<$Res> implements $PerfilCopyWith<$Res> {
  factory _$$PerfilImplCopyWith(
          _$PerfilImpl value, $Res Function(_$PerfilImpl) then) =
      __$$PerfilImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      bool activo,
      DateTime fechaCreacion,
      String rol,
      int tenantId,
      String tenantNombre});
}

/// @nodoc
class __$$PerfilImplCopyWithImpl<$Res>
    extends _$PerfilCopyWithImpl<$Res, _$PerfilImpl>
    implements _$$PerfilImplCopyWith<$Res> {
  __$$PerfilImplCopyWithImpl(
      _$PerfilImpl _value, $Res Function(_$PerfilImpl) _then)
      : super(_value, _then);

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? activo = null,
    Object? fechaCreacion = null,
    Object? rol = null,
    Object? tenantId = null,
    Object? tenantNombre = null,
  }) {
    return _then(_$PerfilImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      activo: null == activo
          ? _value.activo
          : activo // ignore: cast_nullable_to_non_nullable
              as bool,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rol: null == rol
          ? _value.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantNombre: null == tenantNombre
          ? _value.tenantNombre
          : tenantNombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PerfilImpl implements _Perfil {
  const _$PerfilImpl(
      {required this.id,
      required this.nombre,
      required this.activo,
      required this.fechaCreacion,
      required this.rol,
      required this.tenantId,
      required this.tenantNombre});

  @override
  final int id;
  @override
  final String nombre;
  @override
  final bool activo;
  @override
  final DateTime fechaCreacion;
  @override
  final String rol;
  @override
  final int tenantId;
  @override
  final String tenantNombre;

  @override
  String toString() {
    return 'Perfil(id: $id, nombre: $nombre, activo: $activo, fechaCreacion: $fechaCreacion, rol: $rol, tenantId: $tenantId, tenantNombre: $tenantNombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.activo, activo) || other.activo == activo) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantNombre, tenantNombre) ||
                other.tenantNombre == tenantNombre));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, activo,
      fechaCreacion, rol, tenantId, tenantNombre);

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilImplCopyWith<_$PerfilImpl> get copyWith =>
      __$$PerfilImplCopyWithImpl<_$PerfilImpl>(this, _$identity);
}

abstract class _Perfil implements Perfil {
  const factory _Perfil(
      {required final int id,
      required final String nombre,
      required final bool activo,
      required final DateTime fechaCreacion,
      required final String rol,
      required final int tenantId,
      required final String tenantNombre}) = _$PerfilImpl;

  @override
  int get id;
  @override
  String get nombre;
  @override
  bool get activo;
  @override
  DateTime get fechaCreacion;
  @override
  String get rol;
  @override
  int get tenantId;
  @override
  String get tenantNombre;

  /// Create a copy of Perfil
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilImplCopyWith<_$PerfilImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
