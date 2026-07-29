// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagos_resumen_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PagosResumenDto _$PagosResumenDtoFromJson(Map<String, dynamic> json) {
  return _PagosResumenDto.fromJson(json);
}

/// @nodoc
mixin _$PagosResumenDto {
  int get tenantsActivos => throw _privateConstructorUsedError;
  int get tenantsSuspendidos => throw _privateConstructorUsedError;
  String get ingresosMesActual => throw _privateConstructorUsedError;
  String get ingresosTotales => throw _privateConstructorUsedError;

  /// Serializes this PagosResumenDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PagosResumenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagosResumenDtoCopyWith<PagosResumenDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagosResumenDtoCopyWith<$Res> {
  factory $PagosResumenDtoCopyWith(
          PagosResumenDto value, $Res Function(PagosResumenDto) then) =
      _$PagosResumenDtoCopyWithImpl<$Res, PagosResumenDto>;
  @useResult
  $Res call(
      {int tenantsActivos,
      int tenantsSuspendidos,
      String ingresosMesActual,
      String ingresosTotales});
}

/// @nodoc
class _$PagosResumenDtoCopyWithImpl<$Res, $Val extends PagosResumenDto>
    implements $PagosResumenDtoCopyWith<$Res> {
  _$PagosResumenDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PagosResumenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantsActivos = null,
    Object? tenantsSuspendidos = null,
    Object? ingresosMesActual = null,
    Object? ingresosTotales = null,
  }) {
    return _then(_value.copyWith(
      tenantsActivos: null == tenantsActivos
          ? _value.tenantsActivos
          : tenantsActivos // ignore: cast_nullable_to_non_nullable
              as int,
      tenantsSuspendidos: null == tenantsSuspendidos
          ? _value.tenantsSuspendidos
          : tenantsSuspendidos // ignore: cast_nullable_to_non_nullable
              as int,
      ingresosMesActual: null == ingresosMesActual
          ? _value.ingresosMesActual
          : ingresosMesActual // ignore: cast_nullable_to_non_nullable
              as String,
      ingresosTotales: null == ingresosTotales
          ? _value.ingresosTotales
          : ingresosTotales // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PagosResumenDtoImplCopyWith<$Res>
    implements $PagosResumenDtoCopyWith<$Res> {
  factory _$$PagosResumenDtoImplCopyWith(_$PagosResumenDtoImpl value,
          $Res Function(_$PagosResumenDtoImpl) then) =
      __$$PagosResumenDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int tenantsActivos,
      int tenantsSuspendidos,
      String ingresosMesActual,
      String ingresosTotales});
}

/// @nodoc
class __$$PagosResumenDtoImplCopyWithImpl<$Res>
    extends _$PagosResumenDtoCopyWithImpl<$Res, _$PagosResumenDtoImpl>
    implements _$$PagosResumenDtoImplCopyWith<$Res> {
  __$$PagosResumenDtoImplCopyWithImpl(
      _$PagosResumenDtoImpl _value, $Res Function(_$PagosResumenDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagosResumenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantsActivos = null,
    Object? tenantsSuspendidos = null,
    Object? ingresosMesActual = null,
    Object? ingresosTotales = null,
  }) {
    return _then(_$PagosResumenDtoImpl(
      tenantsActivos: null == tenantsActivos
          ? _value.tenantsActivos
          : tenantsActivos // ignore: cast_nullable_to_non_nullable
              as int,
      tenantsSuspendidos: null == tenantsSuspendidos
          ? _value.tenantsSuspendidos
          : tenantsSuspendidos // ignore: cast_nullable_to_non_nullable
              as int,
      ingresosMesActual: null == ingresosMesActual
          ? _value.ingresosMesActual
          : ingresosMesActual // ignore: cast_nullable_to_non_nullable
              as String,
      ingresosTotales: null == ingresosTotales
          ? _value.ingresosTotales
          : ingresosTotales // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PagosResumenDtoImpl extends _PagosResumenDto {
  const _$PagosResumenDtoImpl(
      {required this.tenantsActivos,
      required this.tenantsSuspendidos,
      required this.ingresosMesActual,
      required this.ingresosTotales})
      : super._();

  factory _$PagosResumenDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PagosResumenDtoImplFromJson(json);

  @override
  final int tenantsActivos;
  @override
  final int tenantsSuspendidos;
  @override
  final String ingresosMesActual;
  @override
  final String ingresosTotales;

  @override
  String toString() {
    return 'PagosResumenDto(tenantsActivos: $tenantsActivos, tenantsSuspendidos: $tenantsSuspendidos, ingresosMesActual: $ingresosMesActual, ingresosTotales: $ingresosTotales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagosResumenDtoImpl &&
            (identical(other.tenantsActivos, tenantsActivos) ||
                other.tenantsActivos == tenantsActivos) &&
            (identical(other.tenantsSuspendidos, tenantsSuspendidos) ||
                other.tenantsSuspendidos == tenantsSuspendidos) &&
            (identical(other.ingresosMesActual, ingresosMesActual) ||
                other.ingresosMesActual == ingresosMesActual) &&
            (identical(other.ingresosTotales, ingresosTotales) ||
                other.ingresosTotales == ingresosTotales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tenantsActivos,
      tenantsSuspendidos, ingresosMesActual, ingresosTotales);

  /// Create a copy of PagosResumenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagosResumenDtoImplCopyWith<_$PagosResumenDtoImpl> get copyWith =>
      __$$PagosResumenDtoImplCopyWithImpl<_$PagosResumenDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PagosResumenDtoImplToJson(
      this,
    );
  }
}

abstract class _PagosResumenDto extends PagosResumenDto {
  const factory _PagosResumenDto(
      {required final int tenantsActivos,
      required final int tenantsSuspendidos,
      required final String ingresosMesActual,
      required final String ingresosTotales}) = _$PagosResumenDtoImpl;
  const _PagosResumenDto._() : super._();

  factory _PagosResumenDto.fromJson(Map<String, dynamic> json) =
      _$PagosResumenDtoImpl.fromJson;

  @override
  int get tenantsActivos;
  @override
  int get tenantsSuspendidos;
  @override
  String get ingresosMesActual;
  @override
  String get ingresosTotales;

  /// Create a copy of PagosResumenDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagosResumenDtoImplCopyWith<_$PagosResumenDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
