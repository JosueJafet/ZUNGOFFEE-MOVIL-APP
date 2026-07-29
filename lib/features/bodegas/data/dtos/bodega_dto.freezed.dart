// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodega_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodegaDto _$BodegaDtoFromJson(Map<String, dynamic> json) {
  return _BodegaDto.fromJson(json);
}

/// @nodoc
mixin _$BodegaDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_id')
  int get estadoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_registro')
  String get fechaRegistro =>
      throw _privateConstructorUsedError; // Solo vienen en `GET /tenants` (confirmado por
// `CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12) — ausentes en los otros
// 3 shapes de este mismo DTO (onboarding/editar/suspender-activar),
// por eso van opcionales y no `required` como el resto de los
// campos, no porque el contrato los marque como tal.
  @JsonKey(name: 'dias_restantes')
  int? get diasRestantes => throw _privateConstructorUsedError;
  @JsonKey(name: 'estado_pago_calculado')
  String? get estadoPagoCalculado => throw _privateConstructorUsedError;

  /// Serializes this BodegaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodegaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodegaDtoCopyWith<BodegaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodegaDtoCopyWith<$Res> {
  factory $BodegaDtoCopyWith(BodegaDto value, $Res Function(BodegaDto) then) =
      _$BodegaDtoCopyWithImpl<$Res, BodegaDto>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'estado_id') int estadoId,
      @JsonKey(name: 'fecha_registro') String fechaRegistro,
      @JsonKey(name: 'dias_restantes') int? diasRestantes,
      @JsonKey(name: 'estado_pago_calculado') String? estadoPagoCalculado});
}

/// @nodoc
class _$BodegaDtoCopyWithImpl<$Res, $Val extends BodegaDto>
    implements $BodegaDtoCopyWith<$Res> {
  _$BodegaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodegaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estadoId = null,
    Object? fechaRegistro = null,
    Object? diasRestantes = freezed,
    Object? estadoPagoCalculado = freezed,
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
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      fechaRegistro: null == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as String,
      diasRestantes: freezed == diasRestantes
          ? _value.diasRestantes
          : diasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      estadoPagoCalculado: freezed == estadoPagoCalculado
          ? _value.estadoPagoCalculado
          : estadoPagoCalculado // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodegaDtoImplCopyWith<$Res>
    implements $BodegaDtoCopyWith<$Res> {
  factory _$$BodegaDtoImplCopyWith(
          _$BodegaDtoImpl value, $Res Function(_$BodegaDtoImpl) then) =
      __$$BodegaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'estado_id') int estadoId,
      @JsonKey(name: 'fecha_registro') String fechaRegistro,
      @JsonKey(name: 'dias_restantes') int? diasRestantes,
      @JsonKey(name: 'estado_pago_calculado') String? estadoPagoCalculado});
}

/// @nodoc
class __$$BodegaDtoImplCopyWithImpl<$Res>
    extends _$BodegaDtoCopyWithImpl<$Res, _$BodegaDtoImpl>
    implements _$$BodegaDtoImplCopyWith<$Res> {
  __$$BodegaDtoImplCopyWithImpl(
      _$BodegaDtoImpl _value, $Res Function(_$BodegaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodegaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estadoId = null,
    Object? fechaRegistro = null,
    Object? diasRestantes = freezed,
    Object? estadoPagoCalculado = freezed,
  }) {
    return _then(_$BodegaDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      fechaRegistro: null == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as String,
      diasRestantes: freezed == diasRestantes
          ? _value.diasRestantes
          : diasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      estadoPagoCalculado: freezed == estadoPagoCalculado
          ? _value.estadoPagoCalculado
          : estadoPagoCalculado // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodegaDtoImpl extends _BodegaDto {
  const _$BodegaDtoImpl(
      {required this.id,
      required this.nombre,
      @JsonKey(name: 'estado_id') required this.estadoId,
      @JsonKey(name: 'fecha_registro') required this.fechaRegistro,
      @JsonKey(name: 'dias_restantes') this.diasRestantes,
      @JsonKey(name: 'estado_pago_calculado') this.estadoPagoCalculado})
      : super._();

  factory _$BodegaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodegaDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  @JsonKey(name: 'estado_id')
  final int estadoId;
  @override
  @JsonKey(name: 'fecha_registro')
  final String fechaRegistro;
// Solo vienen en `GET /tenants` (confirmado por
// `CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12) — ausentes en los otros
// 3 shapes de este mismo DTO (onboarding/editar/suspender-activar),
// por eso van opcionales y no `required` como el resto de los
// campos, no porque el contrato los marque como tal.
  @override
  @JsonKey(name: 'dias_restantes')
  final int? diasRestantes;
  @override
  @JsonKey(name: 'estado_pago_calculado')
  final String? estadoPagoCalculado;

  @override
  String toString() {
    return 'BodegaDto(id: $id, nombre: $nombre, estadoId: $estadoId, fechaRegistro: $fechaRegistro, diasRestantes: $diasRestantes, estadoPagoCalculado: $estadoPagoCalculado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodegaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.estadoId, estadoId) ||
                other.estadoId == estadoId) &&
            (identical(other.fechaRegistro, fechaRegistro) ||
                other.fechaRegistro == fechaRegistro) &&
            (identical(other.diasRestantes, diasRestantes) ||
                other.diasRestantes == diasRestantes) &&
            (identical(other.estadoPagoCalculado, estadoPagoCalculado) ||
                other.estadoPagoCalculado == estadoPagoCalculado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, estadoId,
      fechaRegistro, diasRestantes, estadoPagoCalculado);

  /// Create a copy of BodegaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodegaDtoImplCopyWith<_$BodegaDtoImpl> get copyWith =>
      __$$BodegaDtoImplCopyWithImpl<_$BodegaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodegaDtoImplToJson(
      this,
    );
  }
}

abstract class _BodegaDto extends BodegaDto {
  const factory _BodegaDto(
      {required final int id,
      required final String nombre,
      @JsonKey(name: 'estado_id') required final int estadoId,
      @JsonKey(name: 'fecha_registro') required final String fechaRegistro,
      @JsonKey(name: 'dias_restantes') final int? diasRestantes,
      @JsonKey(name: 'estado_pago_calculado')
      final String? estadoPagoCalculado}) = _$BodegaDtoImpl;
  const _BodegaDto._() : super._();

  factory _BodegaDto.fromJson(Map<String, dynamic> json) =
      _$BodegaDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  @JsonKey(name: 'estado_id')
  int get estadoId;
  @override
  @JsonKey(name: 'fecha_registro')
  String get fechaRegistro; // Solo vienen en `GET /tenants` (confirmado por
// `CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12) — ausentes en los otros
// 3 shapes de este mismo DTO (onboarding/editar/suspender-activar),
// por eso van opcionales y no `required` como el resto de los
// campos, no porque el contrato los marque como tal.
  @override
  @JsonKey(name: 'dias_restantes')
  int? get diasRestantes;
  @override
  @JsonKey(name: 'estado_pago_calculado')
  String? get estadoPagoCalculado;

  /// Create a copy of BodegaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodegaDtoImplCopyWith<_$BodegaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
