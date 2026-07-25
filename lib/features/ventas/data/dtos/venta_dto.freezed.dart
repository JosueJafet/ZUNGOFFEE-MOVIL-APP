// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venta_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VentaDto _$VentaDtoFromJson(Map<String, dynamic> json) {
  return _VentaDto.fromJson(json);
}

/// @nodoc
mixin _$VentaDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cliente_id')
  int get clienteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'usuario_id')
  int get usuarioId => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  bool get anulada => throw _privateConstructorUsedError;

  /// Serializes this VentaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VentaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VentaDtoCopyWith<VentaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VentaDtoCopyWith<$Res> {
  factory $VentaDtoCopyWith(VentaDto value, $Res Function(VentaDto) then) =
      _$VentaDtoCopyWithImpl<$Res, VentaDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'cliente_id') int clienteId,
      @JsonKey(name: 'usuario_id') int usuarioId,
      String total,
      bool anulada});
}

/// @nodoc
class _$VentaDtoCopyWithImpl<$Res, $Val extends VentaDto>
    implements $VentaDtoCopyWith<$Res> {
  _$VentaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VentaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? clienteId = null,
    Object? usuarioId = null,
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
      clienteId: null == clienteId
          ? _value.clienteId
          : clienteId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$VentaDtoImplCopyWith<$Res>
    implements $VentaDtoCopyWith<$Res> {
  factory _$$VentaDtoImplCopyWith(
          _$VentaDtoImpl value, $Res Function(_$VentaDtoImpl) then) =
      __$$VentaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'tenant_id') int tenantId,
      @JsonKey(name: 'cliente_id') int clienteId,
      @JsonKey(name: 'usuario_id') int usuarioId,
      String total,
      bool anulada});
}

/// @nodoc
class __$$VentaDtoImplCopyWithImpl<$Res>
    extends _$VentaDtoCopyWithImpl<$Res, _$VentaDtoImpl>
    implements _$$VentaDtoImplCopyWith<$Res> {
  __$$VentaDtoImplCopyWithImpl(
      _$VentaDtoImpl _value, $Res Function(_$VentaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VentaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? clienteId = null,
    Object? usuarioId = null,
    Object? total = null,
    Object? anulada = null,
  }) {
    return _then(_$VentaDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      clienteId: null == clienteId
          ? _value.clienteId
          : clienteId // ignore: cast_nullable_to_non_nullable
              as int,
      usuarioId: null == usuarioId
          ? _value.usuarioId
          : usuarioId // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$VentaDtoImpl extends _VentaDto {
  const _$VentaDtoImpl(
      {required this.id,
      @JsonKey(name: 'tenant_id') required this.tenantId,
      @JsonKey(name: 'cliente_id') required this.clienteId,
      @JsonKey(name: 'usuario_id') required this.usuarioId,
      required this.total,
      required this.anulada})
      : super._();

  factory _$VentaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VentaDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @override
  @JsonKey(name: 'cliente_id')
  final int clienteId;
  @override
  @JsonKey(name: 'usuario_id')
  final int usuarioId;
  @override
  final String total;
  @override
  final bool anulada;

  @override
  String toString() {
    return 'VentaDto(id: $id, tenantId: $tenantId, clienteId: $clienteId, usuarioId: $usuarioId, total: $total, anulada: $anulada)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VentaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.usuarioId, usuarioId) ||
                other.usuarioId == usuarioId) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.anulada, anulada) || other.anulada == anulada));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, clienteId, usuarioId, total, anulada);

  /// Create a copy of VentaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VentaDtoImplCopyWith<_$VentaDtoImpl> get copyWith =>
      __$$VentaDtoImplCopyWithImpl<_$VentaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VentaDtoImplToJson(
      this,
    );
  }
}

abstract class _VentaDto extends VentaDto {
  const factory _VentaDto(
      {required final int id,
      @JsonKey(name: 'tenant_id') required final int tenantId,
      @JsonKey(name: 'cliente_id') required final int clienteId,
      @JsonKey(name: 'usuario_id') required final int usuarioId,
      required final String total,
      required final bool anulada}) = _$VentaDtoImpl;
  const _VentaDto._() : super._();

  factory _VentaDto.fromJson(Map<String, dynamic> json) =
      _$VentaDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'tenant_id')
  int get tenantId;
  @override
  @JsonKey(name: 'cliente_id')
  int get clienteId;
  @override
  @JsonKey(name: 'usuario_id')
  int get usuarioId;
  @override
  String get total;
  @override
  bool get anulada;

  /// Create a copy of VentaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VentaDtoImplCopyWith<_$VentaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
