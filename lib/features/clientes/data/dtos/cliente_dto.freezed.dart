// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClienteDto _$ClienteDtoFromJson(Map<String, dynamic> json) {
  return _ClienteDto.fromJson(json);
}

/// @nodoc
mixin _$ClienteDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_id')
  int? get tipoId => throw _privateConstructorUsedError;
  String? get lugar => throw _privateConstructorUsedError;
  String? get telefono => throw _privateConstructorUsedError;
  bool get estado => throw _privateConstructorUsedError;

  /// Serializes this ClienteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClienteDtoCopyWith<ClienteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClienteDtoCopyWith<$Res> {
  factory $ClienteDtoCopyWith(
          ClienteDto value, $Res Function(ClienteDto) then) =
      _$ClienteDtoCopyWithImpl<$Res, ClienteDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String nombre,
      @JsonKey(name: 'tipo_id') int? tipoId,
      String? lugar,
      String? telefono,
      bool estado});
}

/// @nodoc
class _$ClienteDtoCopyWithImpl<$Res, $Val extends ClienteDto>
    implements $ClienteDtoCopyWith<$Res> {
  _$ClienteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? tipoId = freezed,
    Object? lugar = freezed,
    Object? telefono = freezed,
    Object? estado = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClienteDtoImplCopyWith<$Res>
    implements $ClienteDtoCopyWith<$Res> {
  factory _$$ClienteDtoImplCopyWith(
          _$ClienteDtoImpl value, $Res Function(_$ClienteDtoImpl) then) =
      __$$ClienteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String nombre,
      @JsonKey(name: 'tipo_id') int? tipoId,
      String? lugar,
      String? telefono,
      bool estado});
}

/// @nodoc
class __$$ClienteDtoImplCopyWithImpl<$Res>
    extends _$ClienteDtoCopyWithImpl<$Res, _$ClienteDtoImpl>
    implements _$$ClienteDtoImplCopyWith<$Res> {
  __$$ClienteDtoImplCopyWithImpl(
      _$ClienteDtoImpl _value, $Res Function(_$ClienteDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? tipoId = freezed,
    Object? lugar = freezed,
    Object? telefono = freezed,
    Object? estado = null,
  }) {
    return _then(_$ClienteDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClienteDtoImpl extends _ClienteDto {
  const _$ClienteDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      required this.nombre,
      @JsonKey(name: 'tipo_id') this.tipoId,
      this.lugar,
      this.telefono,
      required this.estado})
      : super._();

  factory _$ClienteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClienteDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  final String nombre;
  @override
  @JsonKey(name: 'tipo_id')
  final int? tipoId;
  @override
  final String? lugar;
  @override
  final String? telefono;
  @override
  final bool estado;

  @override
  String toString() {
    return 'ClienteDto(id: $id, tenantId: $tenantId, nombre: $nombre, tipoId: $tipoId, lugar: $lugar, telefono: $telefono, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClienteDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.tipoId, tipoId) || other.tipoId == tipoId) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, nombre, tipoId, lugar, telefono, estado);

  /// Create a copy of ClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClienteDtoImplCopyWith<_$ClienteDtoImpl> get copyWith =>
      __$$ClienteDtoImplCopyWithImpl<_$ClienteDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClienteDtoImplToJson(
      this,
    );
  }
}

abstract class _ClienteDto extends ClienteDto {
  const factory _ClienteDto(
      {required final int id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      required final String nombre,
      @JsonKey(name: 'tipo_id') final int? tipoId,
      final String? lugar,
      final String? telefono,
      required final bool estado}) = _$ClienteDtoImpl;
  const _ClienteDto._() : super._();

  factory _ClienteDto.fromJson(Map<String, dynamic> json) =
      _$ClienteDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  String get nombre;
  @override
  @JsonKey(name: 'tipo_id')
  int? get tipoId;
  @override
  String? get lugar;
  @override
  String? get telefono;
  @override
  bool get estado;

  /// Create a copy of ClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClienteDtoImplCopyWith<_$ClienteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
