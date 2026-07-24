// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lote_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoteDto _$LoteDtoFromJson(Map<String, dynamic> json) {
  return _LoteDto.fromJson(json);
}

/// @nodoc
mixin _$LoteDto {
  String get id => throw _privateConstructorUsedError;
  String get saldo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cantidad_inicial')
  String get cantidadInicial => throw _privateConstructorUsedError;
  @JsonKey(name: 'estados_cafe')
  LoteEstadoCafeDto get estadosCafe => throw _privateConstructorUsedError;
  @JsonKey(name: 'variedades_cafe')
  LoteVariedadDto get variedadesCafe => throw _privateConstructorUsedError;
  @JsonKey(name: 'niveles_altura')
  LoteNivelAlturaDto get nivelesAltura => throw _privateConstructorUsedError;

  /// Serializes this LoteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoteDtoCopyWith<LoteDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoteDtoCopyWith<$Res> {
  factory $LoteDtoCopyWith(LoteDto value, $Res Function(LoteDto) then) =
      _$LoteDtoCopyWithImpl<$Res, LoteDto>;
  @useResult
  $Res call(
      {String id,
      String saldo,
      @JsonKey(name: 'cantidad_inicial') String cantidadInicial,
      @JsonKey(name: 'estados_cafe') LoteEstadoCafeDto estadosCafe,
      @JsonKey(name: 'variedades_cafe') LoteVariedadDto variedadesCafe,
      @JsonKey(name: 'niveles_altura') LoteNivelAlturaDto nivelesAltura});

  $LoteEstadoCafeDtoCopyWith<$Res> get estadosCafe;
  $LoteVariedadDtoCopyWith<$Res> get variedadesCafe;
  $LoteNivelAlturaDtoCopyWith<$Res> get nivelesAltura;
}

/// @nodoc
class _$LoteDtoCopyWithImpl<$Res, $Val extends LoteDto>
    implements $LoteDtoCopyWith<$Res> {
  _$LoteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saldo = null,
    Object? cantidadInicial = null,
    Object? estadosCafe = null,
    Object? variedadesCafe = null,
    Object? nivelesAltura = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saldo: null == saldo
          ? _value.saldo
          : saldo // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadInicial: null == cantidadInicial
          ? _value.cantidadInicial
          : cantidadInicial // ignore: cast_nullable_to_non_nullable
              as String,
      estadosCafe: null == estadosCafe
          ? _value.estadosCafe
          : estadosCafe // ignore: cast_nullable_to_non_nullable
              as LoteEstadoCafeDto,
      variedadesCafe: null == variedadesCafe
          ? _value.variedadesCafe
          : variedadesCafe // ignore: cast_nullable_to_non_nullable
              as LoteVariedadDto,
      nivelesAltura: null == nivelesAltura
          ? _value.nivelesAltura
          : nivelesAltura // ignore: cast_nullable_to_non_nullable
              as LoteNivelAlturaDto,
    ) as $Val);
  }

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoteEstadoCafeDtoCopyWith<$Res> get estadosCafe {
    return $LoteEstadoCafeDtoCopyWith<$Res>(_value.estadosCafe, (value) {
      return _then(_value.copyWith(estadosCafe: value) as $Val);
    });
  }

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoteVariedadDtoCopyWith<$Res> get variedadesCafe {
    return $LoteVariedadDtoCopyWith<$Res>(_value.variedadesCafe, (value) {
      return _then(_value.copyWith(variedadesCafe: value) as $Val);
    });
  }

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoteNivelAlturaDtoCopyWith<$Res> get nivelesAltura {
    return $LoteNivelAlturaDtoCopyWith<$Res>(_value.nivelesAltura, (value) {
      return _then(_value.copyWith(nivelesAltura: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoteDtoImplCopyWith<$Res> implements $LoteDtoCopyWith<$Res> {
  factory _$$LoteDtoImplCopyWith(
          _$LoteDtoImpl value, $Res Function(_$LoteDtoImpl) then) =
      __$$LoteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String saldo,
      @JsonKey(name: 'cantidad_inicial') String cantidadInicial,
      @JsonKey(name: 'estados_cafe') LoteEstadoCafeDto estadosCafe,
      @JsonKey(name: 'variedades_cafe') LoteVariedadDto variedadesCafe,
      @JsonKey(name: 'niveles_altura') LoteNivelAlturaDto nivelesAltura});

  @override
  $LoteEstadoCafeDtoCopyWith<$Res> get estadosCafe;
  @override
  $LoteVariedadDtoCopyWith<$Res> get variedadesCafe;
  @override
  $LoteNivelAlturaDtoCopyWith<$Res> get nivelesAltura;
}

/// @nodoc
class __$$LoteDtoImplCopyWithImpl<$Res>
    extends _$LoteDtoCopyWithImpl<$Res, _$LoteDtoImpl>
    implements _$$LoteDtoImplCopyWith<$Res> {
  __$$LoteDtoImplCopyWithImpl(
      _$LoteDtoImpl _value, $Res Function(_$LoteDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saldo = null,
    Object? cantidadInicial = null,
    Object? estadosCafe = null,
    Object? variedadesCafe = null,
    Object? nivelesAltura = null,
  }) {
    return _then(_$LoteDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saldo: null == saldo
          ? _value.saldo
          : saldo // ignore: cast_nullable_to_non_nullable
              as String,
      cantidadInicial: null == cantidadInicial
          ? _value.cantidadInicial
          : cantidadInicial // ignore: cast_nullable_to_non_nullable
              as String,
      estadosCafe: null == estadosCafe
          ? _value.estadosCafe
          : estadosCafe // ignore: cast_nullable_to_non_nullable
              as LoteEstadoCafeDto,
      variedadesCafe: null == variedadesCafe
          ? _value.variedadesCafe
          : variedadesCafe // ignore: cast_nullable_to_non_nullable
              as LoteVariedadDto,
      nivelesAltura: null == nivelesAltura
          ? _value.nivelesAltura
          : nivelesAltura // ignore: cast_nullable_to_non_nullable
              as LoteNivelAlturaDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoteDtoImpl extends _LoteDto {
  const _$LoteDtoImpl(
      {required this.id,
      required this.saldo,
      @JsonKey(name: 'cantidad_inicial') required this.cantidadInicial,
      @JsonKey(name: 'estados_cafe') required this.estadosCafe,
      @JsonKey(name: 'variedades_cafe') required this.variedadesCafe,
      @JsonKey(name: 'niveles_altura') required this.nivelesAltura})
      : super._();

  factory _$LoteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoteDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String saldo;
  @override
  @JsonKey(name: 'cantidad_inicial')
  final String cantidadInicial;
  @override
  @JsonKey(name: 'estados_cafe')
  final LoteEstadoCafeDto estadosCafe;
  @override
  @JsonKey(name: 'variedades_cafe')
  final LoteVariedadDto variedadesCafe;
  @override
  @JsonKey(name: 'niveles_altura')
  final LoteNivelAlturaDto nivelesAltura;

  @override
  String toString() {
    return 'LoteDto(id: $id, saldo: $saldo, cantidadInicial: $cantidadInicial, estadosCafe: $estadosCafe, variedadesCafe: $variedadesCafe, nivelesAltura: $nivelesAltura)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoteDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saldo, saldo) || other.saldo == saldo) &&
            (identical(other.cantidadInicial, cantidadInicial) ||
                other.cantidadInicial == cantidadInicial) &&
            (identical(other.estadosCafe, estadosCafe) ||
                other.estadosCafe == estadosCafe) &&
            (identical(other.variedadesCafe, variedadesCafe) ||
                other.variedadesCafe == variedadesCafe) &&
            (identical(other.nivelesAltura, nivelesAltura) ||
                other.nivelesAltura == nivelesAltura));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, saldo, cantidadInicial,
      estadosCafe, variedadesCafe, nivelesAltura);

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoteDtoImplCopyWith<_$LoteDtoImpl> get copyWith =>
      __$$LoteDtoImplCopyWithImpl<_$LoteDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoteDtoImplToJson(
      this,
    );
  }
}

abstract class _LoteDto extends LoteDto {
  const factory _LoteDto(
      {required final String id,
      required final String saldo,
      @JsonKey(name: 'cantidad_inicial') required final String cantidadInicial,
      @JsonKey(name: 'estados_cafe')
      required final LoteEstadoCafeDto estadosCafe,
      @JsonKey(name: 'variedades_cafe')
      required final LoteVariedadDto variedadesCafe,
      @JsonKey(name: 'niveles_altura')
      required final LoteNivelAlturaDto nivelesAltura}) = _$LoteDtoImpl;
  const _LoteDto._() : super._();

  factory _LoteDto.fromJson(Map<String, dynamic> json) = _$LoteDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get saldo;
  @override
  @JsonKey(name: 'cantidad_inicial')
  String get cantidadInicial;
  @override
  @JsonKey(name: 'estados_cafe')
  LoteEstadoCafeDto get estadosCafe;
  @override
  @JsonKey(name: 'variedades_cafe')
  LoteVariedadDto get variedadesCafe;
  @override
  @JsonKey(name: 'niveles_altura')
  LoteNivelAlturaDto get nivelesAltura;

  /// Create a copy of LoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoteDtoImplCopyWith<_$LoteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoteEstadoCafeDto _$LoteEstadoCafeDtoFromJson(Map<String, dynamic> json) {
  return _LoteEstadoCafeDto.fromJson(json);
}

/// @nodoc
mixin _$LoteEstadoCafeDto {
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'unidad_medida_id')
  int get unidadMedidaId => throw _privateConstructorUsedError;

  /// Serializes this LoteEstadoCafeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoteEstadoCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoteEstadoCafeDtoCopyWith<LoteEstadoCafeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoteEstadoCafeDtoCopyWith<$Res> {
  factory $LoteEstadoCafeDtoCopyWith(
          LoteEstadoCafeDto value, $Res Function(LoteEstadoCafeDto) then) =
      _$LoteEstadoCafeDtoCopyWithImpl<$Res, LoteEstadoCafeDto>;
  @useResult
  $Res call(
      {String nombre, @JsonKey(name: 'unidad_medida_id') int unidadMedidaId});
}

/// @nodoc
class _$LoteEstadoCafeDtoCopyWithImpl<$Res, $Val extends LoteEstadoCafeDto>
    implements $LoteEstadoCafeDtoCopyWith<$Res> {
  _$LoteEstadoCafeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoteEstadoCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? unidadMedidaId = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$LoteEstadoCafeDtoImplCopyWith<$Res>
    implements $LoteEstadoCafeDtoCopyWith<$Res> {
  factory _$$LoteEstadoCafeDtoImplCopyWith(_$LoteEstadoCafeDtoImpl value,
          $Res Function(_$LoteEstadoCafeDtoImpl) then) =
      __$$LoteEstadoCafeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String nombre, @JsonKey(name: 'unidad_medida_id') int unidadMedidaId});
}

/// @nodoc
class __$$LoteEstadoCafeDtoImplCopyWithImpl<$Res>
    extends _$LoteEstadoCafeDtoCopyWithImpl<$Res, _$LoteEstadoCafeDtoImpl>
    implements _$$LoteEstadoCafeDtoImplCopyWith<$Res> {
  __$$LoteEstadoCafeDtoImplCopyWithImpl(_$LoteEstadoCafeDtoImpl _value,
      $Res Function(_$LoteEstadoCafeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoteEstadoCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? unidadMedidaId = null,
  }) {
    return _then(_$LoteEstadoCafeDtoImpl(
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
@JsonSerializable()
class _$LoteEstadoCafeDtoImpl implements _LoteEstadoCafeDto {
  const _$LoteEstadoCafeDtoImpl(
      {required this.nombre,
      @JsonKey(name: 'unidad_medida_id') required this.unidadMedidaId});

  factory _$LoteEstadoCafeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoteEstadoCafeDtoImplFromJson(json);

  @override
  final String nombre;
  @override
  @JsonKey(name: 'unidad_medida_id')
  final int unidadMedidaId;

  @override
  String toString() {
    return 'LoteEstadoCafeDto(nombre: $nombre, unidadMedidaId: $unidadMedidaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoteEstadoCafeDtoImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.unidadMedidaId, unidadMedidaId) ||
                other.unidadMedidaId == unidadMedidaId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre, unidadMedidaId);

  /// Create a copy of LoteEstadoCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoteEstadoCafeDtoImplCopyWith<_$LoteEstadoCafeDtoImpl> get copyWith =>
      __$$LoteEstadoCafeDtoImplCopyWithImpl<_$LoteEstadoCafeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoteEstadoCafeDtoImplToJson(
      this,
    );
  }
}

abstract class _LoteEstadoCafeDto implements LoteEstadoCafeDto {
  const factory _LoteEstadoCafeDto(
      {required final String nombre,
      @JsonKey(name: 'unidad_medida_id')
      required final int unidadMedidaId}) = _$LoteEstadoCafeDtoImpl;

  factory _LoteEstadoCafeDto.fromJson(Map<String, dynamic> json) =
      _$LoteEstadoCafeDtoImpl.fromJson;

  @override
  String get nombre;
  @override
  @JsonKey(name: 'unidad_medida_id')
  int get unidadMedidaId;

  /// Create a copy of LoteEstadoCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoteEstadoCafeDtoImplCopyWith<_$LoteEstadoCafeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoteVariedadDto _$LoteVariedadDtoFromJson(Map<String, dynamic> json) {
  return _LoteVariedadDto.fromJson(json);
}

/// @nodoc
mixin _$LoteVariedadDto {
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this LoteVariedadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoteVariedadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoteVariedadDtoCopyWith<LoteVariedadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoteVariedadDtoCopyWith<$Res> {
  factory $LoteVariedadDtoCopyWith(
          LoteVariedadDto value, $Res Function(LoteVariedadDto) then) =
      _$LoteVariedadDtoCopyWithImpl<$Res, LoteVariedadDto>;
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class _$LoteVariedadDtoCopyWithImpl<$Res, $Val extends LoteVariedadDto>
    implements $LoteVariedadDtoCopyWith<$Res> {
  _$LoteVariedadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoteVariedadDto
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
abstract class _$$LoteVariedadDtoImplCopyWith<$Res>
    implements $LoteVariedadDtoCopyWith<$Res> {
  factory _$$LoteVariedadDtoImplCopyWith(_$LoteVariedadDtoImpl value,
          $Res Function(_$LoteVariedadDtoImpl) then) =
      __$$LoteVariedadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class __$$LoteVariedadDtoImplCopyWithImpl<$Res>
    extends _$LoteVariedadDtoCopyWithImpl<$Res, _$LoteVariedadDtoImpl>
    implements _$$LoteVariedadDtoImplCopyWith<$Res> {
  __$$LoteVariedadDtoImplCopyWithImpl(
      _$LoteVariedadDtoImpl _value, $Res Function(_$LoteVariedadDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoteVariedadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
  }) {
    return _then(_$LoteVariedadDtoImpl(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoteVariedadDtoImpl implements _LoteVariedadDto {
  const _$LoteVariedadDtoImpl({required this.nombre});

  factory _$LoteVariedadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoteVariedadDtoImplFromJson(json);

  @override
  final String nombre;

  @override
  String toString() {
    return 'LoteVariedadDto(nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoteVariedadDtoImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre);

  /// Create a copy of LoteVariedadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoteVariedadDtoImplCopyWith<_$LoteVariedadDtoImpl> get copyWith =>
      __$$LoteVariedadDtoImplCopyWithImpl<_$LoteVariedadDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoteVariedadDtoImplToJson(
      this,
    );
  }
}

abstract class _LoteVariedadDto implements LoteVariedadDto {
  const factory _LoteVariedadDto({required final String nombre}) =
      _$LoteVariedadDtoImpl;

  factory _LoteVariedadDto.fromJson(Map<String, dynamic> json) =
      _$LoteVariedadDtoImpl.fromJson;

  @override
  String get nombre;

  /// Create a copy of LoteVariedadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoteVariedadDtoImplCopyWith<_$LoteVariedadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoteNivelAlturaDto _$LoteNivelAlturaDtoFromJson(Map<String, dynamic> json) {
  return _LoteNivelAlturaDto.fromJson(json);
}

/// @nodoc
mixin _$LoteNivelAlturaDto {
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this LoteNivelAlturaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoteNivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoteNivelAlturaDtoCopyWith<LoteNivelAlturaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoteNivelAlturaDtoCopyWith<$Res> {
  factory $LoteNivelAlturaDtoCopyWith(
          LoteNivelAlturaDto value, $Res Function(LoteNivelAlturaDto) then) =
      _$LoteNivelAlturaDtoCopyWithImpl<$Res, LoteNivelAlturaDto>;
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class _$LoteNivelAlturaDtoCopyWithImpl<$Res, $Val extends LoteNivelAlturaDto>
    implements $LoteNivelAlturaDtoCopyWith<$Res> {
  _$LoteNivelAlturaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoteNivelAlturaDto
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
abstract class _$$LoteNivelAlturaDtoImplCopyWith<$Res>
    implements $LoteNivelAlturaDtoCopyWith<$Res> {
  factory _$$LoteNivelAlturaDtoImplCopyWith(_$LoteNivelAlturaDtoImpl value,
          $Res Function(_$LoteNivelAlturaDtoImpl) then) =
      __$$LoteNivelAlturaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nombre});
}

/// @nodoc
class __$$LoteNivelAlturaDtoImplCopyWithImpl<$Res>
    extends _$LoteNivelAlturaDtoCopyWithImpl<$Res, _$LoteNivelAlturaDtoImpl>
    implements _$$LoteNivelAlturaDtoImplCopyWith<$Res> {
  __$$LoteNivelAlturaDtoImplCopyWithImpl(_$LoteNivelAlturaDtoImpl _value,
      $Res Function(_$LoteNivelAlturaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoteNivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
  }) {
    return _then(_$LoteNivelAlturaDtoImpl(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoteNivelAlturaDtoImpl implements _LoteNivelAlturaDto {
  const _$LoteNivelAlturaDtoImpl({required this.nombre});

  factory _$LoteNivelAlturaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoteNivelAlturaDtoImplFromJson(json);

  @override
  final String nombre;

  @override
  String toString() {
    return 'LoteNivelAlturaDto(nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoteNivelAlturaDtoImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre);

  /// Create a copy of LoteNivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoteNivelAlturaDtoImplCopyWith<_$LoteNivelAlturaDtoImpl> get copyWith =>
      __$$LoteNivelAlturaDtoImplCopyWithImpl<_$LoteNivelAlturaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoteNivelAlturaDtoImplToJson(
      this,
    );
  }
}

abstract class _LoteNivelAlturaDto implements LoteNivelAlturaDto {
  const factory _LoteNivelAlturaDto({required final String nombre}) =
      _$LoteNivelAlturaDtoImpl;

  factory _LoteNivelAlturaDto.fromJson(Map<String, dynamic> json) =
      _$LoteNivelAlturaDtoImpl.fromJson;

  @override
  String get nombre;

  /// Create a copy of LoteNivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoteNivelAlturaDtoImplCopyWith<_$LoteNivelAlturaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
