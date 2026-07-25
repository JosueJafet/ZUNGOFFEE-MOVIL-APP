// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procesamiento_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProcesamientoDto _$ProcesamientoDtoFromJson(Map<String, dynamic> json) {
  return _ProcesamientoDto.fromJson(json);
}

/// @nodoc
mixin _$ProcesamientoDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lote_origen_id')
  String get loteOrigenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lote_destino_id')
  String get loteDestinoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cantidad_entrada')
  String get cantidadEntrada => throw _privateConstructorUsedError;
  @JsonKey(name: 'cantidad_salida')
  String get cantidadSalida => throw _privateConstructorUsedError;

  /// Serializes this ProcesamientoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProcesamientoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcesamientoDtoCopyWith<ProcesamientoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcesamientoDtoCopyWith<$Res> {
  factory $ProcesamientoDtoCopyWith(
          ProcesamientoDto value, $Res Function(ProcesamientoDto) then) =
      _$ProcesamientoDtoCopyWithImpl<$Res, ProcesamientoDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'lote_origen_id') String loteOrigenId,
      @JsonKey(name: 'lote_destino_id') String loteDestinoId,
      @JsonKey(name: 'cantidad_entrada') String cantidadEntrada,
      @JsonKey(name: 'cantidad_salida') String cantidadSalida});
}

/// @nodoc
class _$ProcesamientoDtoCopyWithImpl<$Res, $Val extends ProcesamientoDto>
    implements $ProcesamientoDtoCopyWith<$Res> {
  _$ProcesamientoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcesamientoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? loteOrigenId = null,
    Object? loteDestinoId = null,
    Object? cantidadEntrada = null,
    Object? cantidadSalida = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      loteOrigenId: null == loteOrigenId
          ? _value.loteOrigenId
          : loteOrigenId // ignore: cast_nullable_to_non_nullable
              as String,
      loteDestinoId: null == loteDestinoId
          ? _value.loteDestinoId
          : loteDestinoId // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadEntrada: null == cantidadEntrada
          ? _value.cantidadEntrada
          : cantidadEntrada // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadSalida: null == cantidadSalida
          ? _value.cantidadSalida
          : cantidadSalida // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcesamientoDtoImplCopyWith<$Res>
    implements $ProcesamientoDtoCopyWith<$Res> {
  factory _$$ProcesamientoDtoImplCopyWith(_$ProcesamientoDtoImpl value,
          $Res Function(_$ProcesamientoDtoImpl) then) =
      __$$ProcesamientoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'lote_origen_id') String loteOrigenId,
      @JsonKey(name: 'lote_destino_id') String loteDestinoId,
      @JsonKey(name: 'cantidad_entrada') String cantidadEntrada,
      @JsonKey(name: 'cantidad_salida') String cantidadSalida});
}

/// @nodoc
class __$$ProcesamientoDtoImplCopyWithImpl<$Res>
    extends _$ProcesamientoDtoCopyWithImpl<$Res, _$ProcesamientoDtoImpl>
    implements _$$ProcesamientoDtoImplCopyWith<$Res> {
  __$$ProcesamientoDtoImplCopyWithImpl(_$ProcesamientoDtoImpl _value,
      $Res Function(_$ProcesamientoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProcesamientoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? loteOrigenId = null,
    Object? loteDestinoId = null,
    Object? cantidadEntrada = null,
    Object? cantidadSalida = null,
  }) {
    return _then(_$ProcesamientoDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      loteOrigenId: null == loteOrigenId
          ? _value.loteOrigenId
          : loteOrigenId // ignore: cast_nullable_to_non_nullable
              as String,
      loteDestinoId: null == loteDestinoId
          ? _value.loteDestinoId
          : loteDestinoId // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadEntrada: null == cantidadEntrada
          ? _value.cantidadEntrada
          : cantidadEntrada // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadSalida: null == cantidadSalida
          ? _value.cantidadSalida
          : cantidadSalida // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcesamientoDtoImpl extends _ProcesamientoDto {
  const _$ProcesamientoDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      @JsonKey(name: 'lote_origen_id') required this.loteOrigenId,
      @JsonKey(name: 'lote_destino_id') required this.loteDestinoId,
      @JsonKey(name: 'cantidad_entrada') required this.cantidadEntrada,
      @JsonKey(name: 'cantidad_salida') required this.cantidadSalida})
      : super._();

  factory _$ProcesamientoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcesamientoDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  @JsonKey(name: 'lote_origen_id')
  final String loteOrigenId;
  @override
  @JsonKey(name: 'lote_destino_id')
  final String loteDestinoId;
  @override
  @JsonKey(name: 'cantidad_entrada')
  final String cantidadEntrada;
  @override
  @JsonKey(name: 'cantidad_salida')
  final String cantidadSalida;

  @override
  String toString() {
    return 'ProcesamientoDto(id: $id, tenantId: $tenantId, loteOrigenId: $loteOrigenId, loteDestinoId: $loteDestinoId, cantidadEntrada: $cantidadEntrada, cantidadSalida: $cantidadSalida)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcesamientoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.loteOrigenId, loteOrigenId) ||
                other.loteOrigenId == loteOrigenId) &&
            (identical(other.loteDestinoId, loteDestinoId) ||
                other.loteDestinoId == loteDestinoId) &&
            (identical(other.cantidadEntrada, cantidadEntrada) ||
                other.cantidadEntrada == cantidadEntrada) &&
            (identical(other.cantidadSalida, cantidadSalida) ||
                other.cantidadSalida == cantidadSalida));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tenantId, loteOrigenId,
      loteDestinoId, cantidadEntrada, cantidadSalida);

  /// Create a copy of ProcesamientoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcesamientoDtoImplCopyWith<_$ProcesamientoDtoImpl> get copyWith =>
      __$$ProcesamientoDtoImplCopyWithImpl<_$ProcesamientoDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcesamientoDtoImplToJson(
      this,
    );
  }
}

abstract class _ProcesamientoDto extends ProcesamientoDto {
  const factory _ProcesamientoDto(
      {required final String id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      @JsonKey(name: 'lote_origen_id') required final String loteOrigenId,
      @JsonKey(name: 'lote_destino_id') required final String loteDestinoId,
      @JsonKey(name: 'cantidad_entrada') required final String cantidadEntrada,
      @JsonKey(name: 'cantidad_salida')
      required final String cantidadSalida}) = _$ProcesamientoDtoImpl;
  const _ProcesamientoDto._() : super._();

  factory _ProcesamientoDto.fromJson(Map<String, dynamic> json) =
      _$ProcesamientoDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  @JsonKey(name: 'lote_origen_id')
  String get loteOrigenId;
  @override
  @JsonKey(name: 'lote_destino_id')
  String get loteDestinoId;
  @override
  @JsonKey(name: 'cantidad_entrada')
  String get cantidadEntrada;
  @override
  @JsonKey(name: 'cantidad_salida')
  String get cantidadSalida;

  /// Create a copy of ProcesamientoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcesamientoDtoImplCopyWith<_$ProcesamientoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
