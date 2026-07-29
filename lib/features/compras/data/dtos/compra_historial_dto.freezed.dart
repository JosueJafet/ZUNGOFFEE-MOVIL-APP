// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compra_historial_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompraHistorialDto _$CompraHistorialDtoFromJson(Map<String, dynamic> json) {
  return _CompraHistorialDto.fromJson(json);
}

/// @nodoc
mixin _$CompraHistorialDto {
  int get id => throw _privateConstructorUsedError;
  String get fecha => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  CompraHistorialProveedorDto get proveedores =>
      throw _privateConstructorUsedError;
  CompraHistorialUsuarioDto get usuarios => throw _privateConstructorUsedError;

  /// Serializes this CompraHistorialDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraHistorialDtoCopyWith<CompraHistorialDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraHistorialDtoCopyWith<$Res> {
  factory $CompraHistorialDtoCopyWith(
          CompraHistorialDto value, $Res Function(CompraHistorialDto) then) =
      _$CompraHistorialDtoCopyWithImpl<$Res, CompraHistorialDto>;
  @useResult
  $Res call(
      {int id,
      String fecha,
      String total,
      CompraHistorialProveedorDto proveedores,
      CompraHistorialUsuarioDto usuarios});

  $CompraHistorialProveedorDtoCopyWith<$Res> get proveedores;
  $CompraHistorialUsuarioDtoCopyWith<$Res> get usuarios;
}

/// @nodoc
class _$CompraHistorialDtoCopyWithImpl<$Res, $Val extends CompraHistorialDto>
    implements $CompraHistorialDtoCopyWith<$Res> {
  _$CompraHistorialDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? proveedores = null,
    Object? usuarios = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      proveedores: null == proveedores
          ? _value.proveedores
          : proveedores // ignore: cast_nullable_to_non_nullable
              as CompraHistorialProveedorDto,
      usuarios: null == usuarios
          ? _value.usuarios
          : usuarios // ignore: cast_nullable_to_non_nullable
              as CompraHistorialUsuarioDto,
    ) as $Val);
  }

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompraHistorialProveedorDtoCopyWith<$Res> get proveedores {
    return $CompraHistorialProveedorDtoCopyWith<$Res>(_value.proveedores,
        (value) {
      return _then(_value.copyWith(proveedores: value) as $Val);
    });
  }

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompraHistorialUsuarioDtoCopyWith<$Res> get usuarios {
    return $CompraHistorialUsuarioDtoCopyWith<$Res>(_value.usuarios, (value) {
      return _then(_value.copyWith(usuarios: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompraHistorialDtoImplCopyWith<$Res>
    implements $CompraHistorialDtoCopyWith<$Res> {
  factory _$$CompraHistorialDtoImplCopyWith(_$CompraHistorialDtoImpl value,
          $Res Function(_$CompraHistorialDtoImpl) then) =
      __$$CompraHistorialDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String fecha,
      String total,
      CompraHistorialProveedorDto proveedores,
      CompraHistorialUsuarioDto usuarios});

  @override
  $CompraHistorialProveedorDtoCopyWith<$Res> get proveedores;
  @override
  $CompraHistorialUsuarioDtoCopyWith<$Res> get usuarios;
}

/// @nodoc
class __$$CompraHistorialDtoImplCopyWithImpl<$Res>
    extends _$CompraHistorialDtoCopyWithImpl<$Res, _$CompraHistorialDtoImpl>
    implements _$$CompraHistorialDtoImplCopyWith<$Res> {
  __$$CompraHistorialDtoImplCopyWithImpl(_$CompraHistorialDtoImpl _value,
      $Res Function(_$CompraHistorialDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? proveedores = null,
    Object? usuarios = null,
  }) {
    return _then(_$CompraHistorialDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      proveedores: null == proveedores
          ? _value.proveedores
          : proveedores // ignore: cast_nullable_to_non_nullable
              as CompraHistorialProveedorDto,
      usuarios: null == usuarios
          ? _value.usuarios
          : usuarios // ignore: cast_nullable_to_non_nullable
              as CompraHistorialUsuarioDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompraHistorialDtoImpl extends _CompraHistorialDto {
  const _$CompraHistorialDtoImpl(
      {required this.id,
      required this.fecha,
      required this.total,
      required this.proveedores,
      required this.usuarios})
      : super._();

  factory _$CompraHistorialDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompraHistorialDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String fecha;
  @override
  final String total;
  @override
  final CompraHistorialProveedorDto proveedores;
  @override
  final CompraHistorialUsuarioDto usuarios;

  @override
  String toString() {
    return 'CompraHistorialDto(id: $id, fecha: $fecha, total: $total, proveedores: $proveedores, usuarios: $usuarios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraHistorialDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.proveedores, proveedores) ||
                other.proveedores == proveedores) &&
            (identical(other.usuarios, usuarios) ||
                other.usuarios == usuarios));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fecha, total, proveedores, usuarios);

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraHistorialDtoImplCopyWith<_$CompraHistorialDtoImpl> get copyWith =>
      __$$CompraHistorialDtoImplCopyWithImpl<_$CompraHistorialDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompraHistorialDtoImplToJson(
      this,
    );
  }
}

abstract class _CompraHistorialDto extends CompraHistorialDto {
  const factory _CompraHistorialDto(
          {required final int id,
          required final String fecha,
          required final String total,
          required final CompraHistorialProveedorDto proveedores,
          required final CompraHistorialUsuarioDto usuarios}) =
      _$CompraHistorialDtoImpl;
  const _CompraHistorialDto._() : super._();

  factory _CompraHistorialDto.fromJson(Map<String, dynamic> json) =
      _$CompraHistorialDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get fecha;
  @override
  String get total;
  @override
  CompraHistorialProveedorDto get proveedores;
  @override
  CompraHistorialUsuarioDto get usuarios;

  /// Create a copy of CompraHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraHistorialDtoImplCopyWith<_$CompraHistorialDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompraHistorialProveedorDto _$CompraHistorialProveedorDtoFromJson(
    Map<String, dynamic> json) {
  return _CompraHistorialProveedorDto.fromJson(json);
}

/// @nodoc
mixin _$CompraHistorialProveedorDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this CompraHistorialProveedorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompraHistorialProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraHistorialProveedorDtoCopyWith<CompraHistorialProveedorDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraHistorialProveedorDtoCopyWith<$Res> {
  factory $CompraHistorialProveedorDtoCopyWith(
          CompraHistorialProveedorDto value,
          $Res Function(CompraHistorialProveedorDto) then) =
      _$CompraHistorialProveedorDtoCopyWithImpl<$Res,
          CompraHistorialProveedorDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$CompraHistorialProveedorDtoCopyWithImpl<$Res,
        $Val extends CompraHistorialProveedorDto>
    implements $CompraHistorialProveedorDtoCopyWith<$Res> {
  _$CompraHistorialProveedorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompraHistorialProveedorDto
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
abstract class _$$CompraHistorialProveedorDtoImplCopyWith<$Res>
    implements $CompraHistorialProveedorDtoCopyWith<$Res> {
  factory _$$CompraHistorialProveedorDtoImplCopyWith(
          _$CompraHistorialProveedorDtoImpl value,
          $Res Function(_$CompraHistorialProveedorDtoImpl) then) =
      __$$CompraHistorialProveedorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$CompraHistorialProveedorDtoImplCopyWithImpl<$Res>
    extends _$CompraHistorialProveedorDtoCopyWithImpl<$Res,
        _$CompraHistorialProveedorDtoImpl>
    implements _$$CompraHistorialProveedorDtoImplCopyWith<$Res> {
  __$$CompraHistorialProveedorDtoImplCopyWithImpl(
      _$CompraHistorialProveedorDtoImpl _value,
      $Res Function(_$CompraHistorialProveedorDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompraHistorialProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$CompraHistorialProveedorDtoImpl(
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
@JsonSerializable()
class _$CompraHistorialProveedorDtoImpl
    implements _CompraHistorialProveedorDto {
  const _$CompraHistorialProveedorDtoImpl(
      {required this.id, required this.nombre});

  factory _$CompraHistorialProveedorDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CompraHistorialProveedorDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'CompraHistorialProveedorDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraHistorialProveedorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of CompraHistorialProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraHistorialProveedorDtoImplCopyWith<_$CompraHistorialProveedorDtoImpl>
      get copyWith => __$$CompraHistorialProveedorDtoImplCopyWithImpl<
          _$CompraHistorialProveedorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompraHistorialProveedorDtoImplToJson(
      this,
    );
  }
}

abstract class _CompraHistorialProveedorDto
    implements CompraHistorialProveedorDto {
  const factory _CompraHistorialProveedorDto(
      {required final int id,
      required final String nombre}) = _$CompraHistorialProveedorDtoImpl;

  factory _CompraHistorialProveedorDto.fromJson(Map<String, dynamic> json) =
      _$CompraHistorialProveedorDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of CompraHistorialProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraHistorialProveedorDtoImplCopyWith<_$CompraHistorialProveedorDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CompraHistorialUsuarioDto _$CompraHistorialUsuarioDtoFromJson(
    Map<String, dynamic> json) {
  return _CompraHistorialUsuarioDto.fromJson(json);
}

/// @nodoc
mixin _$CompraHistorialUsuarioDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this CompraHistorialUsuarioDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompraHistorialUsuarioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraHistorialUsuarioDtoCopyWith<CompraHistorialUsuarioDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraHistorialUsuarioDtoCopyWith<$Res> {
  factory $CompraHistorialUsuarioDtoCopyWith(CompraHistorialUsuarioDto value,
          $Res Function(CompraHistorialUsuarioDto) then) =
      _$CompraHistorialUsuarioDtoCopyWithImpl<$Res, CompraHistorialUsuarioDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$CompraHistorialUsuarioDtoCopyWithImpl<$Res,
        $Val extends CompraHistorialUsuarioDto>
    implements $CompraHistorialUsuarioDtoCopyWith<$Res> {
  _$CompraHistorialUsuarioDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompraHistorialUsuarioDto
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
abstract class _$$CompraHistorialUsuarioDtoImplCopyWith<$Res>
    implements $CompraHistorialUsuarioDtoCopyWith<$Res> {
  factory _$$CompraHistorialUsuarioDtoImplCopyWith(
          _$CompraHistorialUsuarioDtoImpl value,
          $Res Function(_$CompraHistorialUsuarioDtoImpl) then) =
      __$$CompraHistorialUsuarioDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$CompraHistorialUsuarioDtoImplCopyWithImpl<$Res>
    extends _$CompraHistorialUsuarioDtoCopyWithImpl<$Res,
        _$CompraHistorialUsuarioDtoImpl>
    implements _$$CompraHistorialUsuarioDtoImplCopyWith<$Res> {
  __$$CompraHistorialUsuarioDtoImplCopyWithImpl(
      _$CompraHistorialUsuarioDtoImpl _value,
      $Res Function(_$CompraHistorialUsuarioDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompraHistorialUsuarioDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$CompraHistorialUsuarioDtoImpl(
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
@JsonSerializable()
class _$CompraHistorialUsuarioDtoImpl implements _CompraHistorialUsuarioDto {
  const _$CompraHistorialUsuarioDtoImpl(
      {required this.id, required this.nombre});

  factory _$CompraHistorialUsuarioDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompraHistorialUsuarioDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'CompraHistorialUsuarioDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraHistorialUsuarioDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of CompraHistorialUsuarioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraHistorialUsuarioDtoImplCopyWith<_$CompraHistorialUsuarioDtoImpl>
      get copyWith => __$$CompraHistorialUsuarioDtoImplCopyWithImpl<
          _$CompraHistorialUsuarioDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompraHistorialUsuarioDtoImplToJson(
      this,
    );
  }
}

abstract class _CompraHistorialUsuarioDto implements CompraHistorialUsuarioDto {
  const factory _CompraHistorialUsuarioDto(
      {required final int id,
      required final String nombre}) = _$CompraHistorialUsuarioDtoImpl;

  factory _CompraHistorialUsuarioDto.fromJson(Map<String, dynamic> json) =
      _$CompraHistorialUsuarioDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of CompraHistorialUsuarioDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraHistorialUsuarioDtoImplCopyWith<_$CompraHistorialUsuarioDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
