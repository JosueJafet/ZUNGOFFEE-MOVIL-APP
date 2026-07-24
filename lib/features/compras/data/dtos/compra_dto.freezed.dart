// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compra_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompraDto _$CompraDtoFromJson(Map<String, dynamic> json) {
  return _CompraDto.fromJson(json);
}

/// @nodoc
mixin _$CompraDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'proveedor_id')
  int get proveedorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id')
  int get usuarioId => throw _privateConstructorUsedError;
  String get fecha => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  bool get anulada => throw _privateConstructorUsedError;

  /// Serializes this CompraDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompraDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompraDtoCopyWith<CompraDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompraDtoCopyWith<$Res> {
  factory $CompraDtoCopyWith(CompraDto value, $Res Function(CompraDto) then) =
      _$CompraDtoCopyWithImpl<$Res, CompraDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'proveedor_id') int proveedorId,
      @JsonKey(name: 'usuario_id') int usuarioId,
      String fecha,
      String total,
      bool anulada});
}

/// @nodoc
class _$CompraDtoCopyWithImpl<$Res, $Val extends CompraDto>
    implements $CompraDtoCopyWith<$Res> {
  _$CompraDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompraDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? proveedorId = null,
    Object? usuarioId = null,
    Object? fecha = null,
    Object? total = null,
    Object? anulada = null,
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
      proveedorId: null == proveedorId
          ? _value.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      anulada: null == anulada
          ? _value.anulada
          : anulada // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompraDtoImplCopyWith<$Res>
    implements $CompraDtoCopyWith<$Res> {
  factory _$$CompraDtoImplCopyWith(
          _$CompraDtoImpl value, $Res Function(_$CompraDtoImpl) then) =
      __$$CompraDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'proveedor_id') int proveedorId,
      @JsonKey(name: 'usuario_id') int usuarioId,
      String fecha,
      String total,
      bool anulada});
}

/// @nodoc
class __$$CompraDtoImplCopyWithImpl<$Res>
    extends _$CompraDtoCopyWithImpl<$Res, _$CompraDtoImpl>
    implements _$$CompraDtoImplCopyWith<$Res> {
  __$$CompraDtoImplCopyWithImpl(
      _$CompraDtoImpl _value, $Res Function(_$CompraDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompraDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? proveedorId = null,
    Object? usuarioId = null,
    Object? fecha = null,
    Object? total = null,
    Object? anulada = null,
  }) {
    return _then(_$CompraDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      proveedorId: null == proveedorId
          ? _value.proveedorId
          : proveedorId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
      anulada: null == anulada
          ? _value.anulada
          : anulada // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompraDtoImpl extends _CompraDto {
  const _$CompraDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      @JsonKey(name: 'proveedor_id') required this.proveedorId,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      required this.fecha,
      required this.total,
      required this.anulada})
      : super._();

  factory _$CompraDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompraDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  @JsonKey(name: 'proveedor_id')
  final int proveedorId;
  @override
  @JsonKey(name: 'usuario_id')
  final int usuarioId;
  @override
  final String fecha;
  @override
  final String total;
  @override
  final bool anulada;

  @override
  String toString() {
    return 'CompraDto(id: $id, tenantId: $tenantId, proveedorId: $proveedorId, usuarioId: $usuarioId, fecha: $fecha, total: $total, anulada: $anulada)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompraDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.proveedorId, proveedorId) ||
                other.proveedorId == proveedorId) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.anulada, anulada) || other.anulada == anulada));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, proveedorId, usuarioId, fecha, total, anulada);

  /// Create a copy of CompraDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompraDtoImplCopyWith<_$CompraDtoImpl> get copyWith =>
      __$$CompraDtoImplCopyWithImpl<_$CompraDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompraDtoImplToJson(
      this,
    );
  }
}

abstract class _CompraDto extends CompraDto {
  const factory _CompraDto(
      {required final int id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      @JsonKey(name: 'proveedor_id') required final int proveedorId,
      @JsonKey(name: 'usuario_id') required final int usuarioId,
      required final String fecha,
      required final String total,
      required final bool anulada}) = _$CompraDtoImpl;
  const _CompraDto._() : super._();

  factory _CompraDto.fromJson(Map<String, dynamic> json) =
      _$CompraDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  @JsonKey(name: 'proveedor_id')
  int get proveedorId;
  @override
  @JsonKey(name: 'usuario_id')
  int get usuarioId;
  @override
  String get fecha;
  @override
  String get total;
  @override
  bool get anulada;

  /// Create a copy of CompraDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompraDtoImplCopyWith<_$CompraDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
