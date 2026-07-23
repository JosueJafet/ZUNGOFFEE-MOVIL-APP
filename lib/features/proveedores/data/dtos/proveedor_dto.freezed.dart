// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proveedor_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProveedorDto _$ProveedorDtoFromJson(Map<String, dynamic> json) {
  return _ProveedorDto.fromJson(json);
}

/// @nodoc
mixin _$ProveedorDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get sexo => throw _privateConstructorUsedError;
  String? get lugar => throw _privateConstructorUsedError;
  String? get finca => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_id')
  int? get tipoId => throw _privateConstructorUsedError;
  String? get telefono => throw _privateConstructorUsedError;
  bool get estado => throw _privateConstructorUsedError;

  /// Serializes this ProveedorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProveedorDtoCopyWith<ProveedorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProveedorDtoCopyWith<$Res> {
  factory $ProveedorDtoCopyWith(
          ProveedorDto value, $Res Function(ProveedorDto) then) =
      _$ProveedorDtoCopyWithImpl<$Res, ProveedorDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String nombre,
      String? sexo,
      String? lugar,
      String? finca,
      @JsonKey(name: 'tipo_id') int? tipoId,
      String? telefono,
      bool estado});
}

/// @nodoc
class _$ProveedorDtoCopyWithImpl<$Res, $Val extends ProveedorDto>
    implements $ProveedorDtoCopyWith<$Res> {
  _$ProveedorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? sexo = freezed,
    Object? lugar = freezed,
    Object? finca = freezed,
    Object? tipoId = freezed,
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
      sexo: freezed == sexo
          ? _value.sexo
          : sexo // ignore: cast_nullable_to_non_nullable
              as String?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      finca: freezed == finca
          ? _value.finca
          : finca // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$ProveedorDtoImplCopyWith<$Res>
    implements $ProveedorDtoCopyWith<$Res> {
  factory _$$ProveedorDtoImplCopyWith(
          _$ProveedorDtoImpl value, $Res Function(_$ProveedorDtoImpl) then) =
      __$$ProveedorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      String nombre,
      String? sexo,
      String? lugar,
      String? finca,
      @JsonKey(name: 'tipo_id') int? tipoId,
      String? telefono,
      bool estado});
}

/// @nodoc
class __$$ProveedorDtoImplCopyWithImpl<$Res>
    extends _$ProveedorDtoCopyWithImpl<$Res, _$ProveedorDtoImpl>
    implements _$$ProveedorDtoImplCopyWith<$Res> {
  __$$ProveedorDtoImplCopyWithImpl(
      _$ProveedorDtoImpl _value, $Res Function(_$ProveedorDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? sexo = freezed,
    Object? lugar = freezed,
    Object? finca = freezed,
    Object? tipoId = freezed,
    Object? telefono = freezed,
    Object? estado = null,
  }) {
    return _then(_$ProveedorDtoImpl(
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
      sexo: freezed == sexo
          ? _value.sexo
          : sexo // ignore: cast_nullable_to_non_nullable
              as String?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      finca: freezed == finca
          ? _value.finca
          : finca // ignore: cast_nullable_to_non_nullable
              as String?,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$ProveedorDtoImpl extends _ProveedorDto {
  const _$ProveedorDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      required this.nombre,
      this.sexo,
      this.lugar,
      this.finca,
      @JsonKey(name: 'tipo_id') this.tipoId,
      this.telefono,
      required this.estado})
      : super._();

  factory _$ProveedorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProveedorDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  final String nombre;
  @override
  final String? sexo;
  @override
  final String? lugar;
  @override
  final String? finca;
  @override
  @JsonKey(name: 'tipo_id')
  final int? tipoId;
  @override
  final String? telefono;
  @override
  final bool estado;

  @override
  String toString() {
    return 'ProveedorDto(id: $id, tenantId: $tenantId, nombre: $nombre, sexo: $sexo, lugar: $lugar, finca: $finca, tipoId: $tipoId, telefono: $telefono, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProveedorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.sexo, sexo) || other.sexo == sexo) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.finca, finca) || other.finca == finca) &&
            (identical(other.tipoId, tipoId) || other.tipoId == tipoId) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tenantId, nombre, sexo,
      lugar, finca, tipoId, telefono, estado);

  /// Create a copy of ProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProveedorDtoImplCopyWith<_$ProveedorDtoImpl> get copyWith =>
      __$$ProveedorDtoImplCopyWithImpl<_$ProveedorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProveedorDtoImplToJson(
      this,
    );
  }
}

abstract class _ProveedorDto extends ProveedorDto {
  const factory _ProveedorDto(
      {required final int id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      required final String nombre,
      final String? sexo,
      final String? lugar,
      final String? finca,
      @JsonKey(name: 'tipo_id') final int? tipoId,
      final String? telefono,
      required final bool estado}) = _$ProveedorDtoImpl;
  const _ProveedorDto._() : super._();

  factory _ProveedorDto.fromJson(Map<String, dynamic> json) =
      _$ProveedorDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  String get nombre;
  @override
  String? get sexo;
  @override
  String? get lugar;
  @override
  String? get finca;
  @override
  @JsonKey(name: 'tipo_id')
  int? get tipoId;
  @override
  String? get telefono;
  @override
  bool get estado;

  /// Create a copy of ProveedorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProveedorDtoImplCopyWith<_$ProveedorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
