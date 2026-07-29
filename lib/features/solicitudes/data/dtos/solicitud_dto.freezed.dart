// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'solicitud_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SolicitudDto _$SolicitudDtoFromJson(Map<String, dynamic> json) {
  return _SolicitudDto.fromJson(json);
}

/// @nodoc
mixin _$SolicitudDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre_bodega')
  String get nombreBodega => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre_contacto')
  String get nombreContacto => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // Nullable: al menos una solicitud real en producción llega sin
// teléfono (visto en el panel web, fila sin número bajo el
// contacto) — declararlo `required` rompía el parseo de *todo* el
// array, mismo patrón de bug ya corregido en `PerfilTenantDto`.
  String? get telefono => throw _privateConstructorUsedError;
  String? get mensaje => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_id')
  int get estadoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_creado_id')
  int? get tenantCreadoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_creacion')
  String get fechaCreacion => throw _privateConstructorUsedError;

  /// Serializes this SolicitudDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SolicitudDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SolicitudDtoCopyWith<SolicitudDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SolicitudDtoCopyWith<$Res> {
  factory $SolicitudDtoCopyWith(
          SolicitudDto value, $Res Function(SolicitudDto) then) =
      _$SolicitudDtoCopyWithImpl<$Res, SolicitudDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'nombre_bodega') String nombreBodega,
      @JsonKey(name: 'nombre_contacto') String nombreContacto,
      String email,
      String? telefono,
      String? mensaje,
      @JsonKey(name: 'estado_id') int estadoId,
      @JsonKey(name: 'tenant_creado_id') int? tenantCreadoId,
      @JsonKey(name: 'fecha_creacion') String fechaCreacion});
}

/// @nodoc
class _$SolicitudDtoCopyWithImpl<$Res, $Val extends SolicitudDto>
    implements $SolicitudDtoCopyWith<$Res> {
  _$SolicitudDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SolicitudDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreBodega = null,
    Object? nombreContacto = null,
    Object? email = null,
    Object? telefono = freezed,
    Object? mensaje = freezed,
    Object? estadoId = null,
    Object? tenantCreadoId = freezed,
    Object? fechaCreacion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreBodega: null == nombreBodega
          ? _value.nombreBodega
          : nombreBodega // ignore: cast_nullable_to_non_nullable
              as String,
      nombreContacto: null == nombreContacto
          ? _value.nombreContacto
          : nombreContacto // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      mensaje: freezed == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantCreadoId: freezed == tenantCreadoId
          ? _value.tenantCreadoId
          : tenantCreadoId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SolicitudDtoImplCopyWith<$Res>
    implements $SolicitudDtoCopyWith<$Res> {
  factory _$$SolicitudDtoImplCopyWith(
          _$SolicitudDtoImpl value, $Res Function(_$SolicitudDtoImpl) then) =
      __$$SolicitudDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'nombre_bodega') String nombreBodega,
      @JsonKey(name: 'nombre_contacto') String nombreContacto,
      String email,
      String? telefono,
      String? mensaje,
      @JsonKey(name: 'estado_id') int estadoId,
      @JsonKey(name: 'tenant_creado_id') int? tenantCreadoId,
      @JsonKey(name: 'fecha_creacion') String fechaCreacion});
}

/// @nodoc
class __$$SolicitudDtoImplCopyWithImpl<$Res>
    extends _$SolicitudDtoCopyWithImpl<$Res, _$SolicitudDtoImpl>
    implements _$$SolicitudDtoImplCopyWith<$Res> {
  __$$SolicitudDtoImplCopyWithImpl(
      _$SolicitudDtoImpl _value, $Res Function(_$SolicitudDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SolicitudDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreBodega = null,
    Object? nombreContacto = null,
    Object? email = null,
    Object? telefono = freezed,
    Object? mensaje = freezed,
    Object? estadoId = null,
    Object? tenantCreadoId = freezed,
    Object? fechaCreacion = null,
  }) {
    return _then(_$SolicitudDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreBodega: null == nombreBodega
          ? _value.nombreBodega
          : nombreBodega // ignore: cast_nullable_to_non_nullable
              as String,
      nombreContacto: null == nombreContacto
          ? _value.nombreContacto
          : nombreContacto // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      mensaje: freezed == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantCreadoId: freezed == tenantCreadoId
          ? _value.tenantCreadoId
          : tenantCreadoId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SolicitudDtoImpl extends _SolicitudDto {
  const _$SolicitudDtoImpl(
      {required this.id,
      @JsonKey(name: 'nombre_bodega') required this.nombreBodega,
      @JsonKey(name: 'nombre_contacto') required this.nombreContacto,
      required this.email,
      this.telefono,
      this.mensaje,
      @JsonKey(name: 'estado_id') required this.estadoId,
      @JsonKey(name: 'tenant_creado_id') this.tenantCreadoId,
      @JsonKey(name: 'fecha_creacion') required this.fechaCreacion})
      : super._();

  factory _$SolicitudDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SolicitudDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'nombre_bodega')
  final String nombreBodega;
  @override
  @JsonKey(name: 'nombre_contacto')
  final String nombreContacto;
  @override
  final String email;
// Nullable: al menos una solicitud real en producción llega sin
// teléfono (visto en el panel web, fila sin número bajo el
// contacto) — declararlo `required` rompía el parseo de *todo* el
// array, mismo patrón de bug ya corregido en `PerfilTenantDto`.
  @override
  final String? telefono;
  @override
  final String? mensaje;
  @override
  @JsonKey(name: 'estado_id')
  final int estadoId;
  @override
  @JsonKey(name: 'tenant_creado_id')
  final int? tenantCreadoId;
  @override
  @JsonKey(name: 'fecha_creacion')
  final String fechaCreacion;

  @override
  String toString() {
    return 'SolicitudDto(id: $id, nombreBodega: $nombreBodega, nombreContacto: $nombreContacto, email: $email, telefono: $telefono, mensaje: $mensaje, estadoId: $estadoId, tenantCreadoId: $tenantCreadoId, fechaCreacion: $fechaCreacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SolicitudDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreBodega, nombreBodega) ||
                other.nombreBodega == nombreBodega) &&
            (identical(other.nombreContacto, nombreContacto) ||
                other.nombreContacto == nombreContacto) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.mensaje, mensaje) || other.mensaje == mensaje) &&
            (identical(other.estadoId, estadoId) ||
                other.estadoId == estadoId) &&
            (identical(other.tenantCreadoId, tenantCreadoId) ||
                other.tenantCreadoId == tenantCreadoId) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombreBodega, nombreContacto,
      email, telefono, mensaje, estadoId, tenantCreadoId, fechaCreacion);

  /// Create a copy of SolicitudDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SolicitudDtoImplCopyWith<_$SolicitudDtoImpl> get copyWith =>
      __$$SolicitudDtoImplCopyWithImpl<_$SolicitudDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SolicitudDtoImplToJson(
      this,
    );
  }
}

abstract class _SolicitudDto extends SolicitudDto {
  const factory _SolicitudDto(
      {required final int id,
      @JsonKey(name: 'nombre_bodega') required final String nombreBodega,
      @JsonKey(name: 'nombre_contacto') required final String nombreContacto,
      required final String email,
      final String? telefono,
      final String? mensaje,
      @JsonKey(name: 'estado_id') required final int estadoId,
      @JsonKey(name: 'tenant_creado_id') final int? tenantCreadoId,
      @JsonKey(name: 'fecha_creacion')
      required final String fechaCreacion}) = _$SolicitudDtoImpl;
  const _SolicitudDto._() : super._();

  factory _SolicitudDto.fromJson(Map<String, dynamic> json) =
      _$SolicitudDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'nombre_bodega')
  String get nombreBodega;
  @override
  @JsonKey(name: 'nombre_contacto')
  String get nombreContacto;
  @override
  String
      get email; // Nullable: al menos una solicitud real en producción llega sin
// teléfono (visto en el panel web, fila sin número bajo el
// contacto) — declararlo `required` rompía el parseo de *todo* el
// array, mismo patrón de bug ya corregido en `PerfilTenantDto`.
  @override
  String? get telefono;
  @override
  String? get mensaje;
  @override
  @JsonKey(name: 'estado_id')
  int get estadoId;
  @override
  @JsonKey(name: 'tenant_creado_id')
  int? get tenantCreadoId;
  @override
  @JsonKey(name: 'fecha_creacion')
  String get fechaCreacion;

  /// Create a copy of SolicitudDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SolicitudDtoImplCopyWith<_$SolicitudDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
