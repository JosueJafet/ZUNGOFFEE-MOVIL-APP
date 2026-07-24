// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalogos_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CatalogosDto _$CatalogosDtoFromJson(Map<String, dynamic> json) {
  return _CatalogosDto.fromJson(json);
}

/// @nodoc
mixin _$CatalogosDto {
  @JsonKey(name: 'metodosPago')
  List<MetodoPagoDto> get metodosPago => throw _privateConstructorUsedError;
  @JsonKey(name: 'variedadesCafe')
  List<VariedadCafeDto> get variedadesCafe =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'nivelesAltura')
  List<NivelAlturaDto> get nivelesAltura => throw _privateConstructorUsedError;
  @JsonKey(name: 'estadosCafe')
  List<EstadoCafeCatalogoDto> get estadosCafe =>
      throw _privateConstructorUsedError;

  /// Serializes this CatalogosDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogosDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogosDtoCopyWith<CatalogosDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogosDtoCopyWith<$Res> {
  factory $CatalogosDtoCopyWith(
          CatalogosDto value, $Res Function(CatalogosDto) then) =
      _$CatalogosDtoCopyWithImpl<$Res, CatalogosDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'metodosPago') List<MetodoPagoDto> metodosPago,
      @JsonKey(name: 'variedadesCafe') List<VariedadCafeDto> variedadesCafe,
      @JsonKey(name: 'nivelesAltura') List<NivelAlturaDto> nivelesAltura,
      @JsonKey(name: 'estadosCafe') List<EstadoCafeCatalogoDto> estadosCafe});
}

/// @nodoc
class _$CatalogosDtoCopyWithImpl<$Res, $Val extends CatalogosDto>
    implements $CatalogosDtoCopyWith<$Res> {
  _$CatalogosDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogosDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metodosPago = null,
    Object? variedadesCafe = null,
    Object? nivelesAltura = null,
    Object? estadosCafe = null,
  }) {
    return _then(_value.copyWith(
      metodosPago: null == metodosPago
          ? _value.metodosPago
          : metodosPago // ignore: cast_nullable_to_non_nullable
              as List<MetodoPagoDto>,
      variedadesCafe: null == variedadesCafe
          ? _value.variedadesCafe
          : variedadesCafe // ignore: cast_nullable_to_non_nullable
              as List<VariedadCafeDto>,
      nivelesAltura: null == nivelesAltura
          ? _value.nivelesAltura
          : nivelesAltura // ignore: cast_nullable_to_non_nullable
              as List<NivelAlturaDto>,
      estadosCafe: null == estadosCafe
          ? _value.estadosCafe
          : estadosCafe // ignore: cast_nullable_to_non_nullable
              as List<EstadoCafeCatalogoDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogosDtoImplCopyWith<$Res>
    implements $CatalogosDtoCopyWith<$Res> {
  factory _$$CatalogosDtoImplCopyWith(
          _$CatalogosDtoImpl value, $Res Function(_$CatalogosDtoImpl) then) =
      __$$CatalogosDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'metodosPago') List<MetodoPagoDto> metodosPago,
      @JsonKey(name: 'variedadesCafe') List<VariedadCafeDto> variedadesCafe,
      @JsonKey(name: 'nivelesAltura') List<NivelAlturaDto> nivelesAltura,
      @JsonKey(name: 'estadosCafe') List<EstadoCafeCatalogoDto> estadosCafe});
}

/// @nodoc
class __$$CatalogosDtoImplCopyWithImpl<$Res>
    extends _$CatalogosDtoCopyWithImpl<$Res, _$CatalogosDtoImpl>
    implements _$$CatalogosDtoImplCopyWith<$Res> {
  __$$CatalogosDtoImplCopyWithImpl(
      _$CatalogosDtoImpl _value, $Res Function(_$CatalogosDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CatalogosDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metodosPago = null,
    Object? variedadesCafe = null,
    Object? nivelesAltura = null,
    Object? estadosCafe = null,
  }) {
    return _then(_$CatalogosDtoImpl(
      metodosPago: null == metodosPago
          ? _value._metodosPago
          : metodosPago // ignore: cast_nullable_to_non_nullable
              as List<MetodoPagoDto>,
      variedadesCafe: null == variedadesCafe
          ? _value._variedadesCafe
          : variedadesCafe // ignore: cast_nullable_to_non_nullable
              as List<VariedadCafeDto>,
      nivelesAltura: null == nivelesAltura
          ? _value._nivelesAltura
          : nivelesAltura // ignore: cast_nullable_to_non_nullable
              as List<NivelAlturaDto>,
      estadosCafe: null == estadosCafe
          ? _value._estadosCafe
          : estadosCafe // ignore: cast_nullable_to_non_nullable
              as List<EstadoCafeCatalogoDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogosDtoImpl extends _CatalogosDto {
  const _$CatalogosDtoImpl(
      {@JsonKey(name: 'metodosPago')
      required final List<MetodoPagoDto> metodosPago,
      @JsonKey(name: 'variedadesCafe')
      required final List<VariedadCafeDto> variedadesCafe,
      @JsonKey(name: 'nivelesAltura')
      required final List<NivelAlturaDto> nivelesAltura,
      @JsonKey(name: 'estadosCafe')
      required final List<EstadoCafeCatalogoDto> estadosCafe})
      : _metodosPago = metodosPago,
        _variedadesCafe = variedadesCafe,
        _nivelesAltura = nivelesAltura,
        _estadosCafe = estadosCafe,
        super._();

  factory _$CatalogosDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogosDtoImplFromJson(json);

  final List<MetodoPagoDto> _metodosPago;
  @override
  @JsonKey(name: 'metodosPago')
  List<MetodoPagoDto> get metodosPago {
    if (_metodosPago is EqualUnmodifiableListView) return _metodosPago;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metodosPago);
  }

  final List<VariedadCafeDto> _variedadesCafe;
  @override
  @JsonKey(name: 'variedadesCafe')
  List<VariedadCafeDto> get variedadesCafe {
    if (_variedadesCafe is EqualUnmodifiableListView) return _variedadesCafe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variedadesCafe);
  }

  final List<NivelAlturaDto> _nivelesAltura;
  @override
  @JsonKey(name: 'nivelesAltura')
  List<NivelAlturaDto> get nivelesAltura {
    if (_nivelesAltura is EqualUnmodifiableListView) return _nivelesAltura;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nivelesAltura);
  }

  final List<EstadoCafeCatalogoDto> _estadosCafe;
  @override
  @JsonKey(name: 'estadosCafe')
  List<EstadoCafeCatalogoDto> get estadosCafe {
    if (_estadosCafe is EqualUnmodifiableListView) return _estadosCafe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_estadosCafe);
  }

  @override
  String toString() {
    return 'CatalogosDto(metodosPago: $metodosPago, variedadesCafe: $variedadesCafe, nivelesAltura: $nivelesAltura, estadosCafe: $estadosCafe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogosDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._metodosPago, _metodosPago) &&
            const DeepCollectionEquality()
                .equals(other._variedadesCafe, _variedadesCafe) &&
            const DeepCollectionEquality()
                .equals(other._nivelesAltura, _nivelesAltura) &&
            const DeepCollectionEquality()
                .equals(other._estadosCafe, _estadosCafe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_metodosPago),
      const DeepCollectionEquality().hash(_variedadesCafe),
      const DeepCollectionEquality().hash(_nivelesAltura),
      const DeepCollectionEquality().hash(_estadosCafe));

  /// Create a copy of CatalogosDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogosDtoImplCopyWith<_$CatalogosDtoImpl> get copyWith =>
      __$$CatalogosDtoImplCopyWithImpl<_$CatalogosDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogosDtoImplToJson(
      this,
    );
  }
}

abstract class _CatalogosDto extends CatalogosDto {
  const factory _CatalogosDto(
          {@JsonKey(name: 'metodosPago')
          required final List<MetodoPagoDto> metodosPago,
          @JsonKey(name: 'variedadesCafe')
          required final List<VariedadCafeDto> variedadesCafe,
          @JsonKey(name: 'nivelesAltura')
          required final List<NivelAlturaDto> nivelesAltura,
          @JsonKey(name: 'estadosCafe')
          required final List<EstadoCafeCatalogoDto> estadosCafe}) =
      _$CatalogosDtoImpl;
  const _CatalogosDto._() : super._();

  factory _CatalogosDto.fromJson(Map<String, dynamic> json) =
      _$CatalogosDtoImpl.fromJson;

  @override
  @JsonKey(name: 'metodosPago')
  List<MetodoPagoDto> get metodosPago;
  @override
  @JsonKey(name: 'variedadesCafe')
  List<VariedadCafeDto> get variedadesCafe;
  @override
  @JsonKey(name: 'nivelesAltura')
  List<NivelAlturaDto> get nivelesAltura;
  @override
  @JsonKey(name: 'estadosCafe')
  List<EstadoCafeCatalogoDto> get estadosCafe;

  /// Create a copy of CatalogosDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogosDtoImplCopyWith<_$CatalogosDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetodoPagoDto _$MetodoPagoDtoFromJson(Map<String, dynamic> json) {
  return _MetodoPagoDto.fromJson(json);
}

/// @nodoc
mixin _$MetodoPagoDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this MetodoPagoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetodoPagoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetodoPagoDtoCopyWith<MetodoPagoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetodoPagoDtoCopyWith<$Res> {
  factory $MetodoPagoDtoCopyWith(
          MetodoPagoDto value, $Res Function(MetodoPagoDto) then) =
      _$MetodoPagoDtoCopyWithImpl<$Res, MetodoPagoDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$MetodoPagoDtoCopyWithImpl<$Res, $Val extends MetodoPagoDto>
    implements $MetodoPagoDtoCopyWith<$Res> {
  _$MetodoPagoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetodoPagoDto
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
abstract class _$$MetodoPagoDtoImplCopyWith<$Res>
    implements $MetodoPagoDtoCopyWith<$Res> {
  factory _$$MetodoPagoDtoImplCopyWith(
          _$MetodoPagoDtoImpl value, $Res Function(_$MetodoPagoDtoImpl) then) =
      __$$MetodoPagoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$MetodoPagoDtoImplCopyWithImpl<$Res>
    extends _$MetodoPagoDtoCopyWithImpl<$Res, _$MetodoPagoDtoImpl>
    implements _$$MetodoPagoDtoImplCopyWith<$Res> {
  __$$MetodoPagoDtoImplCopyWithImpl(
      _$MetodoPagoDtoImpl _value, $Res Function(_$MetodoPagoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetodoPagoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$MetodoPagoDtoImpl(
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
class _$MetodoPagoDtoImpl extends _MetodoPagoDto {
  const _$MetodoPagoDtoImpl({required this.id, required this.nombre})
      : super._();

  factory _$MetodoPagoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetodoPagoDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'MetodoPagoDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetodoPagoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of MetodoPagoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetodoPagoDtoImplCopyWith<_$MetodoPagoDtoImpl> get copyWith =>
      __$$MetodoPagoDtoImplCopyWithImpl<_$MetodoPagoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetodoPagoDtoImplToJson(
      this,
    );
  }
}

abstract class _MetodoPagoDto extends MetodoPagoDto {
  const factory _MetodoPagoDto(
      {required final int id,
      required final String nombre}) = _$MetodoPagoDtoImpl;
  const _MetodoPagoDto._() : super._();

  factory _MetodoPagoDto.fromJson(Map<String, dynamic> json) =
      _$MetodoPagoDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of MetodoPagoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetodoPagoDtoImplCopyWith<_$MetodoPagoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VariedadCafeDto _$VariedadCafeDtoFromJson(Map<String, dynamic> json) {
  return _VariedadCafeDto.fromJson(json);
}

/// @nodoc
mixin _$VariedadCafeDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this VariedadCafeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VariedadCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariedadCafeDtoCopyWith<VariedadCafeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariedadCafeDtoCopyWith<$Res> {
  factory $VariedadCafeDtoCopyWith(
          VariedadCafeDto value, $Res Function(VariedadCafeDto) then) =
      _$VariedadCafeDtoCopyWithImpl<$Res, VariedadCafeDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$VariedadCafeDtoCopyWithImpl<$Res, $Val extends VariedadCafeDto>
    implements $VariedadCafeDtoCopyWith<$Res> {
  _$VariedadCafeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariedadCafeDto
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
abstract class _$$VariedadCafeDtoImplCopyWith<$Res>
    implements $VariedadCafeDtoCopyWith<$Res> {
  factory _$$VariedadCafeDtoImplCopyWith(_$VariedadCafeDtoImpl value,
          $Res Function(_$VariedadCafeDtoImpl) then) =
      __$$VariedadCafeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$VariedadCafeDtoImplCopyWithImpl<$Res>
    extends _$VariedadCafeDtoCopyWithImpl<$Res, _$VariedadCafeDtoImpl>
    implements _$$VariedadCafeDtoImplCopyWith<$Res> {
  __$$VariedadCafeDtoImplCopyWithImpl(
      _$VariedadCafeDtoImpl _value, $Res Function(_$VariedadCafeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VariedadCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$VariedadCafeDtoImpl(
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
class _$VariedadCafeDtoImpl extends _VariedadCafeDto {
  const _$VariedadCafeDtoImpl({required this.id, required this.nombre})
      : super._();

  factory _$VariedadCafeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariedadCafeDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'VariedadCafeDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariedadCafeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of VariedadCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariedadCafeDtoImplCopyWith<_$VariedadCafeDtoImpl> get copyWith =>
      __$$VariedadCafeDtoImplCopyWithImpl<_$VariedadCafeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariedadCafeDtoImplToJson(
      this,
    );
  }
}

abstract class _VariedadCafeDto extends VariedadCafeDto {
  const factory _VariedadCafeDto(
      {required final int id,
      required final String nombre}) = _$VariedadCafeDtoImpl;
  const _VariedadCafeDto._() : super._();

  factory _VariedadCafeDto.fromJson(Map<String, dynamic> json) =
      _$VariedadCafeDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of VariedadCafeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariedadCafeDtoImplCopyWith<_$VariedadCafeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NivelAlturaDto _$NivelAlturaDtoFromJson(Map<String, dynamic> json) {
  return _NivelAlturaDto.fromJson(json);
}

/// @nodoc
mixin _$NivelAlturaDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'msnm_min')
  int? get msnmMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'msnm_max')
  int? get msnmMax => throw _privateConstructorUsedError;

  /// Serializes this NivelAlturaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NivelAlturaDtoCopyWith<NivelAlturaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NivelAlturaDtoCopyWith<$Res> {
  factory $NivelAlturaDtoCopyWith(
          NivelAlturaDto value, $Res Function(NivelAlturaDto) then) =
      _$NivelAlturaDtoCopyWithImpl<$Res, NivelAlturaDto>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'msnm_min') int? msnmMin,
      @JsonKey(name: 'msnm_max') int? msnmMax});
}

/// @nodoc
class _$NivelAlturaDtoCopyWithImpl<$Res, $Val extends NivelAlturaDto>
    implements $NivelAlturaDtoCopyWith<$Res> {
  _$NivelAlturaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? msnmMin = freezed,
    Object? msnmMax = freezed,
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
      msnmMin: freezed == msnmMin
          ? _value.msnmMin
          : msnmMin // ignore: cast_nullable_to_non_nullable
              as int?,
      msnmMax: freezed == msnmMax
          ? _value.msnmMax
          : msnmMax // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NivelAlturaDtoImplCopyWith<$Res>
    implements $NivelAlturaDtoCopyWith<$Res> {
  factory _$$NivelAlturaDtoImplCopyWith(_$NivelAlturaDtoImpl value,
          $Res Function(_$NivelAlturaDtoImpl) then) =
      __$$NivelAlturaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'msnm_min') int? msnmMin,
      @JsonKey(name: 'msnm_max') int? msnmMax});
}

/// @nodoc
class __$$NivelAlturaDtoImplCopyWithImpl<$Res>
    extends _$NivelAlturaDtoCopyWithImpl<$Res, _$NivelAlturaDtoImpl>
    implements _$$NivelAlturaDtoImplCopyWith<$Res> {
  __$$NivelAlturaDtoImplCopyWithImpl(
      _$NivelAlturaDtoImpl _value, $Res Function(_$NivelAlturaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? msnmMin = freezed,
    Object? msnmMax = freezed,
  }) {
    return _then(_$NivelAlturaDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      msnmMin: freezed == msnmMin
          ? _value.msnmMin
          : msnmMin // ignore: cast_nullable_to_non_nullable
              as int?,
      msnmMax: freezed == msnmMax
          ? _value.msnmMax
          : msnmMax // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NivelAlturaDtoImpl extends _NivelAlturaDto {
  const _$NivelAlturaDtoImpl(
      {required this.id,
      required this.nombre,
      @JsonKey(name: 'msnm_min') this.msnmMin,
      @JsonKey(name: 'msnm_max') this.msnmMax})
      : super._();

  factory _$NivelAlturaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NivelAlturaDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  @JsonKey(name: 'msnm_min')
  final int? msnmMin;
  @override
  @JsonKey(name: 'msnm_max')
  final int? msnmMax;

  @override
  String toString() {
    return 'NivelAlturaDto(id: $id, nombre: $nombre, msnmMin: $msnmMin, msnmMax: $msnmMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NivelAlturaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.msnmMin, msnmMin) || other.msnmMin == msnmMin) &&
            (identical(other.msnmMax, msnmMax) || other.msnmMax == msnmMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, msnmMin, msnmMax);

  /// Create a copy of NivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NivelAlturaDtoImplCopyWith<_$NivelAlturaDtoImpl> get copyWith =>
      __$$NivelAlturaDtoImplCopyWithImpl<_$NivelAlturaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NivelAlturaDtoImplToJson(
      this,
    );
  }
}

abstract class _NivelAlturaDto extends NivelAlturaDto {
  const factory _NivelAlturaDto(
      {required final int id,
      required final String nombre,
      @JsonKey(name: 'msnm_min') final int? msnmMin,
      @JsonKey(name: 'msnm_max') final int? msnmMax}) = _$NivelAlturaDtoImpl;
  const _NivelAlturaDto._() : super._();

  factory _NivelAlturaDto.fromJson(Map<String, dynamic> json) =
      _$NivelAlturaDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  @JsonKey(name: 'msnm_min')
  int? get msnmMin;
  @override
  @JsonKey(name: 'msnm_max')
  int? get msnmMax;

  /// Create a copy of NivelAlturaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NivelAlturaDtoImplCopyWith<_$NivelAlturaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EstadoCafeCatalogoDto _$EstadoCafeCatalogoDtoFromJson(
    Map<String, dynamic> json) {
  return _EstadoCafeCatalogoDto.fromJson(json);
}

/// @nodoc
mixin _$EstadoCafeCatalogoDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'unidad_medida_id')
  int get unidadMedidaId => throw _privateConstructorUsedError;

  /// Serializes this EstadoCafeCatalogoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EstadoCafeCatalogoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstadoCafeCatalogoDtoCopyWith<EstadoCafeCatalogoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstadoCafeCatalogoDtoCopyWith<$Res> {
  factory $EstadoCafeCatalogoDtoCopyWith(EstadoCafeCatalogoDto value,
          $Res Function(EstadoCafeCatalogoDto) then) =
      _$EstadoCafeCatalogoDtoCopyWithImpl<$Res, EstadoCafeCatalogoDto>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'unidad_medida_id') int unidadMedidaId});
}

/// @nodoc
class _$EstadoCafeCatalogoDtoCopyWithImpl<$Res,
        $Val extends EstadoCafeCatalogoDto>
    implements $EstadoCafeCatalogoDtoCopyWith<$Res> {
  _$EstadoCafeCatalogoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstadoCafeCatalogoDto
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
abstract class _$$EstadoCafeCatalogoDtoImplCopyWith<$Res>
    implements $EstadoCafeCatalogoDtoCopyWith<$Res> {
  factory _$$EstadoCafeCatalogoDtoImplCopyWith(
          _$EstadoCafeCatalogoDtoImpl value,
          $Res Function(_$EstadoCafeCatalogoDtoImpl) then) =
      __$$EstadoCafeCatalogoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      @JsonKey(name: 'unidad_medida_id') int unidadMedidaId});
}

/// @nodoc
class __$$EstadoCafeCatalogoDtoImplCopyWithImpl<$Res>
    extends _$EstadoCafeCatalogoDtoCopyWithImpl<$Res,
        _$EstadoCafeCatalogoDtoImpl>
    implements _$$EstadoCafeCatalogoDtoImplCopyWith<$Res> {
  __$$EstadoCafeCatalogoDtoImplCopyWithImpl(_$EstadoCafeCatalogoDtoImpl _value,
      $Res Function(_$EstadoCafeCatalogoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of EstadoCafeCatalogoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? unidadMedidaId = null,
  }) {
    return _then(_$EstadoCafeCatalogoDtoImpl(
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
@JsonSerializable()
class _$EstadoCafeCatalogoDtoImpl extends _EstadoCafeCatalogoDto {
  const _$EstadoCafeCatalogoDtoImpl(
      {required this.id,
      required this.nombre,
      @JsonKey(name: 'unidad_medida_id') required this.unidadMedidaId})
      : super._();

  factory _$EstadoCafeCatalogoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstadoCafeCatalogoDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  @JsonKey(name: 'unidad_medida_id')
  final int unidadMedidaId;

  @override
  String toString() {
    return 'EstadoCafeCatalogoDto(id: $id, nombre: $nombre, unidadMedidaId: $unidadMedidaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstadoCafeCatalogoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.unidadMedidaId, unidadMedidaId) ||
                other.unidadMedidaId == unidadMedidaId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, unidadMedidaId);

  /// Create a copy of EstadoCafeCatalogoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstadoCafeCatalogoDtoImplCopyWith<_$EstadoCafeCatalogoDtoImpl>
      get copyWith => __$$EstadoCafeCatalogoDtoImplCopyWithImpl<
          _$EstadoCafeCatalogoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstadoCafeCatalogoDtoImplToJson(
      this,
    );
  }
}

abstract class _EstadoCafeCatalogoDto extends EstadoCafeCatalogoDto {
  const factory _EstadoCafeCatalogoDto(
      {required final int id,
      required final String nombre,
      @JsonKey(name: 'unidad_medida_id')
      required final int unidadMedidaId}) = _$EstadoCafeCatalogoDtoImpl;
  const _EstadoCafeCatalogoDto._() : super._();

  factory _EstadoCafeCatalogoDto.fromJson(Map<String, dynamic> json) =
      _$EstadoCafeCatalogoDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  @JsonKey(name: 'unidad_medida_id')
  int get unidadMedidaId;

  /// Create a copy of EstadoCafeCatalogoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstadoCafeCatalogoDtoImplCopyWith<_$EstadoCafeCatalogoDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
