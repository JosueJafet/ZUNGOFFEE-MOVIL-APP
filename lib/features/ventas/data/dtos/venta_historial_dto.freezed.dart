// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venta_historial_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VentaHistorialDto _$VentaHistorialDtoFromJson(Map<String, dynamic> json) {
  return _VentaHistorialDto.fromJson(json);
}

/// @nodoc
mixin _$VentaHistorialDto {
  int get id => throw _privateConstructorUsedError;
  String get fecha => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  VentaHistorialClienteDto get clientes => throw _privateConstructorUsedError;

  /// Serializes this VentaHistorialDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaHistorialDtoCopyWith<VentaHistorialDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaHistorialDtoCopyWith<$Res> {
  factory $VentaHistorialDtoCopyWith(
          VentaHistorialDto value, $Res Function(VentaHistorialDto) then) =
      _$VentaHistorialDtoCopyWithImpl<$Res, VentaHistorialDto>;
  @useResult
  $Res call(
      {int id, String fecha, String total, VentaHistorialClienteDto clientes});

  $VentaHistorialClienteDtoCopyWith<$Res> get clientes;
}

/// @nodoc
class _$VentaHistorialDtoCopyWithImpl<$Res, $Val extends VentaHistorialDto>
    implements $VentaHistorialDtoCopyWith<$Res> {
  _$VentaHistorialDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? clientes = null,
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
      clientes: null == clientes
          ? _value.clientes
          : clientes // ignore: cast_nullable_to_non_nullable
              as VentaHistorialClienteDto,
    ) as $Val);
  }

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VentaHistorialClienteDtoCopyWith<$Res> get clientes {
    return $VentaHistorialClienteDtoCopyWith<$Res>(_value.clientes, (value) {
      return _then(_value.copyWith(clientes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VentaHistorialDtoImplCopyWith<$Res>
    implements $VentaHistorialDtoCopyWith<$Res> {
  factory _$$VentaHistorialDtoImplCopyWith(_$VentaHistorialDtoImpl value,
          $Res Function(_$VentaHistorialDtoImpl) then) =
      __$$VentaHistorialDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String fecha, String total, VentaHistorialClienteDto clientes});

  @override
  $VentaHistorialClienteDtoCopyWith<$Res> get clientes;
}

/// @nodoc
class __$$VentaHistorialDtoImplCopyWithImpl<$Res>
    extends _$VentaHistorialDtoCopyWithImpl<$Res, _$VentaHistorialDtoImpl>
    implements _$$VentaHistorialDtoImplCopyWith<$Res> {
  __$$VentaHistorialDtoImplCopyWithImpl(_$VentaHistorialDtoImpl _value,
      $Res Function(_$VentaHistorialDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fecha = null,
    Object? total = null,
    Object? clientes = null,
  }) {
    return _then(_$VentaHistorialDtoImpl(
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
      clientes: null == clientes
          ? _value.clientes
          : clientes // ignore: cast_nullable_to_non_nullable
              as VentaHistorialClienteDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VentaHistorialDtoImpl extends _VentaHistorialDto {
  const _$VentaHistorialDtoImpl(
      {required this.id,
      required this.fecha,
      required this.total,
      required this.clientes})
      : super._();

  factory _$VentaHistorialDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VentaHistorialDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String fecha;
  @override
  final String total;
  @override
  final VentaHistorialClienteDto clientes;

  @override
  String toString() {
    return 'VentaHistorialDto(id: $id, fecha: $fecha, total: $total, clientes: $clientes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaHistorialDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.clientes, clientes) ||
                other.clientes == clientes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fecha, total, clientes);

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaHistorialDtoImplCopyWith<_$VentaHistorialDtoImpl> get copyWith =>
      __$$VentaHistorialDtoImplCopyWithImpl<_$VentaHistorialDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VentaHistorialDtoImplToJson(
      this,
    );
  }
}

abstract class _VentaHistorialDto extends VentaHistorialDto {
  const factory _VentaHistorialDto(
          {required final int id,
          required final String fecha,
          required final String total,
          required final VentaHistorialClienteDto clientes}) =
      _$VentaHistorialDtoImpl;
  const _VentaHistorialDto._() : super._();

  factory _VentaHistorialDto.fromJson(Map<String, dynamic> json) =
      _$VentaHistorialDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get fecha;
  @override
  String get total;
  @override
  VentaHistorialClienteDto get clientes;

  /// Create a copy of VentaHistorialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaHistorialDtoImplCopyWith<_$VentaHistorialDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VentaHistorialClienteDto _$VentaHistorialClienteDtoFromJson(
    Map<String, dynamic> json) {
  return _VentaHistorialClienteDto.fromJson(json);
}

/// @nodoc
mixin _$VentaHistorialClienteDto {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;

  /// Serializes this VentaHistorialClienteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VentaHistorialClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaHistorialClienteDtoCopyWith<VentaHistorialClienteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaHistorialClienteDtoCopyWith<$Res> {
  factory $VentaHistorialClienteDtoCopyWith(VentaHistorialClienteDto value,
          $Res Function(VentaHistorialClienteDto) then) =
      _$VentaHistorialClienteDtoCopyWithImpl<$Res, VentaHistorialClienteDto>;
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class _$VentaHistorialClienteDtoCopyWithImpl<$Res,
        $Val extends VentaHistorialClienteDto>
    implements $VentaHistorialClienteDtoCopyWith<$Res> {
  _$VentaHistorialClienteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VentaHistorialClienteDto
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
abstract class _$$VentaHistorialClienteDtoImplCopyWith<$Res>
    implements $VentaHistorialClienteDtoCopyWith<$Res> {
  factory _$$VentaHistorialClienteDtoImplCopyWith(
          _$VentaHistorialClienteDtoImpl value,
          $Res Function(_$VentaHistorialClienteDtoImpl) then) =
      __$$VentaHistorialClienteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombre});
}

/// @nodoc
class __$$VentaHistorialClienteDtoImplCopyWithImpl<$Res>
    extends _$VentaHistorialClienteDtoCopyWithImpl<$Res,
        _$VentaHistorialClienteDtoImpl>
    implements _$$VentaHistorialClienteDtoImplCopyWith<$Res> {
  __$$VentaHistorialClienteDtoImplCopyWithImpl(
      _$VentaHistorialClienteDtoImpl _value,
      $Res Function(_$VentaHistorialClienteDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VentaHistorialClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
  }) {
    return _then(_$VentaHistorialClienteDtoImpl(
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
class _$VentaHistorialClienteDtoImpl implements _VentaHistorialClienteDto {
  const _$VentaHistorialClienteDtoImpl(
      {required this.id, required this.nombre});

  factory _$VentaHistorialClienteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VentaHistorialClienteDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;

  @override
  String toString() {
    return 'VentaHistorialClienteDto(id: $id, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaHistorialClienteDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombre);

  /// Create a copy of VentaHistorialClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaHistorialClienteDtoImplCopyWith<_$VentaHistorialClienteDtoImpl>
      get copyWith => __$$VentaHistorialClienteDtoImplCopyWithImpl<
          _$VentaHistorialClienteDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VentaHistorialClienteDtoImplToJson(
      this,
    );
  }
}

abstract class _VentaHistorialClienteDto implements VentaHistorialClienteDto {
  const factory _VentaHistorialClienteDto(
      {required final int id,
      required final String nombre}) = _$VentaHistorialClienteDtoImpl;

  factory _VentaHistorialClienteDto.fromJson(Map<String, dynamic> json) =
      _$VentaHistorialClienteDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;

  /// Create a copy of VentaHistorialClienteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaHistorialClienteDtoImplCopyWith<_$VentaHistorialClienteDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
