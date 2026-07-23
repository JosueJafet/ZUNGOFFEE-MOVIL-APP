// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PerfilDto _$PerfilDtoFromJson(Map<String, dynamic> json) {
  return _PerfilDto.fromJson(json);
}

/// @nodoc
mixin _$PerfilDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  bool get estado => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_creacion')
  String get fechaCreacion => throw _privateConstructorUsedError;
  PerfilRolDto get roles => throw _privateConstructorUsedError;
  PerfilTenantDto get tenants => throw _privateConstructorUsedError;

  /// Serializes this PerfilDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilDtoCopyWith<PerfilDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilDtoCopyWith<$Res> {
  factory $PerfilDtoCopyWith(PerfilDto value, $Res Function(PerfilDto) then) =
      _$PerfilDtoCopyWithImpl<$Res, PerfilDto>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      bool estado,
      @JsonKey(name: 'fecha_creacion') String fechaCreacion,
      PerfilRolDto roles,
      PerfilTenantDto tenants});

  $PerfilRolDtoCopyWith<$Res> get roles;
  $PerfilTenantDtoCopyWith<$Res> get tenants;
}

/// @nodoc
class _$PerfilDtoCopyWithImpl<$Res, $Val extends PerfilDto>
    implements $PerfilDtoCopyWith<$Res> {
  _$PerfilDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estado = null,
    Object? fechaCreacion = null,
    Object? roles = null,
    Object? tenants = null,
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
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as PerfilRolDto,
      tenants: null == tenants
          ? _value.tenants
          : tenants // ignore: cast_nullable_to_non_nullable
              as PerfilTenantDto,
    ) as $Val);
  }

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerfilRolDtoCopyWith<$Res> get roles {
    return $PerfilRolDtoCopyWith<$Res>(_value.roles, (value) {
      return _then(_value.copyWith(roles: value) as $Val);
    });
  }

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerfilTenantDtoCopyWith<$Res> get tenants {
    return $PerfilTenantDtoCopyWith<$Res>(_value.tenants, (value) {
      return _then(_value.copyWith(tenants: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PerfilDtoImplCopyWith<$Res>
    implements $PerfilDtoCopyWith<$Res> {
  factory _$$PerfilDtoImplCopyWith(
          _$PerfilDtoImpl value, $Res Function(_$PerfilDtoImpl) then) =
      __$$PerfilDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      bool estado,
      @JsonKey(name: 'fecha_creacion') String fechaCreacion,
      PerfilRolDto roles,
      PerfilTenantDto tenants});

  @override
  $PerfilRolDtoCopyWith<$Res> get roles;
  @override
  $PerfilTenantDtoCopyWith<$Res> get tenants;
}

/// @nodoc
class __$$PerfilDtoImplCopyWithImpl<$Res>
    extends _$PerfilDtoCopyWithImpl<$Res, _$PerfilDtoImpl>
    implements _$$PerfilDtoImplCopyWith<$Res> {
  __$$PerfilDtoImplCopyWithImpl(
      _$PerfilDtoImpl _value, $Res Function(_$PerfilDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estado = null,
    Object? fechaCreacion = null,
    Object? roles = null,
    Object? tenants = null,
  }) {
    return _then(_$PerfilDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as PerfilRolDto,
      tenants: null == tenants
          ? _value.tenants
          : tenants // ignore: cast_nullable_to_non_nullable
              as PerfilTenantDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerfilDtoImpl extends _PerfilDto {
  const _$PerfilDtoImpl(
      {required this.id,
      required this.nombre,
      required this.estado,
      @JsonKey(name: 'fecha_creacion') required this.fechaCreacion,
      required this.roles,
      required this.tenants})
      : super._();

  factory _$PerfilDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  final bool estado;
  @override
  @JsonKey(name: 'fecha_creacion')
  final String fechaCreacion;
  @override
  final PerfilRolDto roles;
  @override
  final PerfilTenantDto tenants;

  @override
  String toString() {
    return 'PerfilDto(id: $id, nombre: $nombre, estado: $estado, fechaCreacion: $fechaCreacion, roles: $roles, tenants: $tenants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion) &&
            (identical(other.roles, roles) || other.roles == roles) &&
            (identical(other.tenants, tenants) || other.tenants == tenants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nombre, estado, fechaCreacion, roles, tenants);

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilDtoImplCopyWith<_$PerfilDtoImpl> get copyWith =>
      __$$PerfilDtoImplCopyWithImpl<_$PerfilDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilDtoImplToJson(
      this,
    );
  }
}

abstract class _PerfilDto extends PerfilDto {
  const factory _PerfilDto(
      {required final int id,
      required final String nombre,
      required final bool estado,
      @JsonKey(name: 'fecha_creacion') required final String fechaCreacion,
      required final PerfilRolDto roles,
      required final PerfilTenantDto tenants}) = _$PerfilDtoImpl;
  const _PerfilDto._() : super._();

  factory _PerfilDto.fromJson(Map<String, dynamic> json) =
      _$PerfilDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  bool get estado;
  @override
  @JsonKey(name: 'fecha_creacion')
  String get fechaCreacion;
  @override
  PerfilRolDto get roles;
  @override
  PerfilTenantDto get tenants;

  /// Create a copy of PerfilDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilDtoImplCopyWith<_$PerfilDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerfilRolDto _$PerfilRolDtoFromJson(Map<String, dynamic> json) {
  return _PerfilRolDto.fromJson(json);
}

/// @nodoc
mixin _$PerfilRolDto {
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this PerfilRolDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerfilRolDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilRolDtoCopyWith<PerfilRolDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilRolDtoCopyWith<$Res> {
  factory $PerfilRolDtoCopyWith(
          PerfilRolDto value, $Res Function(PerfilRolDto) then) =
      _$PerfilRolDtoCopyWithImpl<$Res, PerfilRolDto>;
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class _$PerfilRolDtoCopyWithImpl<$Res, $Val extends PerfilRolDto>
    implements $PerfilRolDtoCopyWith<$Res> {
  _$PerfilRolDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerfilRolDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
  }) {
    return _then(_value.copyWith(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerfilRolDtoImplCopyWith<$Res>
    implements $PerfilRolDtoCopyWith<$Res> {
  factory _$$PerfilRolDtoImplCopyWith(
          _$PerfilRolDtoImpl value, $Res Function(_$PerfilRolDtoImpl) then) =
      __$$PerfilRolDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class __$$PerfilRolDtoImplCopyWithImpl<$Res>
    extends _$PerfilRolDtoCopyWithImpl<$Res, _$PerfilRolDtoImpl>
    implements _$$PerfilRolDtoImplCopyWith<$Res> {
  __$$PerfilRolDtoImplCopyWithImpl(
      _$PerfilRolDtoImpl _value, $Res Function(_$PerfilRolDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerfilRolDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
  }) {
    return _then(_$PerfilRolDtoImpl(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerfilRolDtoImpl implements _PerfilRolDto {
  const _$PerfilRolDtoImpl({required this.nombre});

  factory _$PerfilRolDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilRolDtoImplFromJson(json);

  @override
  final String nombre;

  @override
  String toString() {
    return 'PerfilRolDto(nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilRolDtoImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre);

  /// Create a copy of PerfilRolDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilRolDtoImplCopyWith<_$PerfilRolDtoImpl> get copyWith =>
      __$$PerfilRolDtoImplCopyWithImpl<_$PerfilRolDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilRolDtoImplToJson(
      this,
    );
  }
}

abstract class _PerfilRolDto implements PerfilRolDto {
  const factory _PerfilRolDto({required final String nombre}) =
      _$PerfilRolDtoImpl;

  factory _PerfilRolDto.fromJson(Map<String, dynamic> json) =
      _$PerfilRolDtoImpl.fromJson;

  @override
  String get nombre;

  /// Create a copy of PerfilRolDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilRolDtoImplCopyWith<_$PerfilRolDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerfilTenantDto _$PerfilTenantDtoFromJson(Map<String, dynamic> json) {
  return _PerfilTenantDto.fromJson(json);
}

/// @nodoc
mixin _$PerfilTenantDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this PerfilTenantDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerfilTenantDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilTenantDtoCopyWith<PerfilTenantDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilTenantDtoCopyWith<$Res> {
  factory $PerfilTenantDtoCopyWith(
          PerfilTenantDto value, $Res Function(PerfilTenantDto) then) =
      _$PerfilTenantDtoCopyWithImpl<$Res, PerfilTenantDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$PerfilTenantDtoCopyWithImpl<$Res, $Val extends PerfilTenantDto>
    implements $PerfilTenantDtoCopyWith<$Res> {
  _$PerfilTenantDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerfilTenantDto
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
abstract class _$$PerfilTenantDtoImplCopyWith<$Res>
    implements $PerfilTenantDtoCopyWith<$Res> {
  factory _$$PerfilTenantDtoImplCopyWith(_$PerfilTenantDtoImpl value,
          $Res Function(_$PerfilTenantDtoImpl) then) =
      __$$PerfilTenantDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$PerfilTenantDtoImplCopyWithImpl<$Res>
    extends _$PerfilTenantDtoCopyWithImpl<$Res, _$PerfilTenantDtoImpl>
    implements _$$PerfilTenantDtoImplCopyWith<$Res> {
  __$$PerfilTenantDtoImplCopyWithImpl(
      _$PerfilTenantDtoImpl _value, $Res Function(_$PerfilTenantDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerfilTenantDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$PerfilTenantDtoImpl(
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
class _$PerfilTenantDtoImpl implements _PerfilTenantDto {
  const _$PerfilTenantDtoImpl({required this.id, required this.nombre});

  factory _$PerfilTenantDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilTenantDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'PerfilTenantDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilTenantDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of PerfilTenantDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilTenantDtoImplCopyWith<_$PerfilTenantDtoImpl> get copyWith =>
      __$$PerfilTenantDtoImplCopyWithImpl<_$PerfilTenantDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilTenantDtoImplToJson(
      this,
    );
  }
}

abstract class _PerfilTenantDto implements PerfilTenantDto {
  const factory _PerfilTenantDto(
      {required final int id,
      required final String nombre}) = _$PerfilTenantDtoImpl;

  factory _PerfilTenantDto.fromJson(Map<String, dynamic> json) =
      _$PerfilTenantDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of PerfilTenantDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilTenantDtoImplCopyWith<_$PerfilTenantDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
