// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resumen_diario_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResumenDiarioDto _$ResumenDiarioDtoFromJson(Map<String, dynamic> json) {
  return _ResumenDiarioDto.fromJson(json);
}

/// @nodoc
mixin _$ResumenDiarioDto {
  String get fecha => throw _privateConstructorUsedError;
  @JsonKey(name: '_sum')
  ResumenSumaDto get sum => throw _privateConstructorUsedError;

  /// Serializes this ResumenDiarioDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResumenDiarioDtoCopyWith<ResumenDiarioDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumenDiarioDtoCopyWith<$Res> {
  factory $ResumenDiarioDtoCopyWith(
          ResumenDiarioDto value, $Res Function(ResumenDiarioDto) then) =
      _$ResumenDiarioDtoCopyWithImpl<$Res, ResumenDiarioDto>;
  @useResult
  $Res call({String fecha, @JsonKey(name: '_sum') ResumenSumaDto sum});

  $ResumenSumaDtoCopyWith<$Res> get sum;
}

/// @nodoc
class _$ResumenDiarioDtoCopyWithImpl<$Res, $Val extends ResumenDiarioDto>
    implements $ResumenDiarioDtoCopyWith<$Res> {
  _$ResumenDiarioDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = null,
    Object? sum = null,
  }) {
    return _then(_value.copyWith(
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as ResumenSumaDto,
    ) as $Val);
  }

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResumenSumaDtoCopyWith<$Res> get sum {
    return $ResumenSumaDtoCopyWith<$Res>(_value.sum, (value) {
      return _then(_value.copyWith(sum: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResumenDiarioDtoImplCopyWith<$Res>
    implements $ResumenDiarioDtoCopyWith<$Res> {
  factory _$$ResumenDiarioDtoImplCopyWith(_$ResumenDiarioDtoImpl value,
          $Res Function(_$ResumenDiarioDtoImpl) then) =
      __$$ResumenDiarioDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fecha, @JsonKey(name: '_sum') ResumenSumaDto sum});

  @override
  $ResumenSumaDtoCopyWith<$Res> get sum;
}

/// @nodoc
class __$$ResumenDiarioDtoImplCopyWithImpl<$Res>
    extends _$ResumenDiarioDtoCopyWithImpl<$Res, _$ResumenDiarioDtoImpl>
    implements _$$ResumenDiarioDtoImplCopyWith<$Res> {
  __$$ResumenDiarioDtoImplCopyWithImpl(_$ResumenDiarioDtoImpl _value,
      $Res Function(_$ResumenDiarioDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = null,
    Object? sum = null,
  }) {
    return _then(_$ResumenDiarioDtoImpl(
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as ResumenSumaDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResumenDiarioDtoImpl extends _ResumenDiarioDto {
  const _$ResumenDiarioDtoImpl(
      {required this.fecha, @JsonKey(name: '_sum') required this.sum})
      : super._();

  factory _$ResumenDiarioDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResumenDiarioDtoImplFromJson(json);

  @override
  final String fecha;
  @override
  @JsonKey(name: '_sum')
  final ResumenSumaDto sum;

  @override
  String toString() {
    return 'ResumenDiarioDto(fecha: $fecha, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumenDiarioDtoImpl &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.sum, sum) || other.sum == sum));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fecha, sum);

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumenDiarioDtoImplCopyWith<_$ResumenDiarioDtoImpl> get copyWith =>
      __$$ResumenDiarioDtoImplCopyWithImpl<_$ResumenDiarioDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResumenDiarioDtoImplToJson(
      this,
    );
  }
}

abstract class _ResumenDiarioDto extends ResumenDiarioDto {
  const factory _ResumenDiarioDto(
          {required final String fecha,
          @JsonKey(name: '_sum') required final ResumenSumaDto sum}) =
      _$ResumenDiarioDtoImpl;
  const _ResumenDiarioDto._() : super._();

  factory _ResumenDiarioDto.fromJson(Map<String, dynamic> json) =
      _$ResumenDiarioDtoImpl.fromJson;

  @override
  String get fecha;
  @override
  @JsonKey(name: '_sum')
  ResumenSumaDto get sum;

  /// Create a copy of ResumenDiarioDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumenDiarioDtoImplCopyWith<_$ResumenDiarioDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResumenSumaDto _$ResumenSumaDtoFromJson(Map<String, dynamic> json) {
  return _ResumenSumaDto.fromJson(json);
}

/// @nodoc
mixin _$ResumenSumaDto {
  String get total => throw _privateConstructorUsedError;

  /// Serializes this ResumenSumaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResumenSumaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResumenSumaDtoCopyWith<ResumenSumaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumenSumaDtoCopyWith<$Res> {
  factory $ResumenSumaDtoCopyWith(
          ResumenSumaDto value, $Res Function(ResumenSumaDto) then) =
      _$ResumenSumaDtoCopyWithImpl<$Res, ResumenSumaDto>;
  @useResult
  $Res call({String total});
}

/// @nodoc
class _$ResumenSumaDtoCopyWithImpl<$Res, $Val extends ResumenSumaDto>
    implements $ResumenSumaDtoCopyWith<$Res> {
  _$ResumenSumaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResumenSumaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResumenSumaDtoImplCopyWith<$Res>
    implements $ResumenSumaDtoCopyWith<$Res> {
  factory _$$ResumenSumaDtoImplCopyWith(_$ResumenSumaDtoImpl value,
          $Res Function(_$ResumenSumaDtoImpl) then) =
      __$$ResumenSumaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String total});
}

/// @nodoc
class __$$ResumenSumaDtoImplCopyWithImpl<$Res>
    extends _$ResumenSumaDtoCopyWithImpl<$Res, _$ResumenSumaDtoImpl>
    implements _$$ResumenSumaDtoImplCopyWith<$Res> {
  __$$ResumenSumaDtoImplCopyWithImpl(
      _$ResumenSumaDtoImpl _value, $Res Function(_$ResumenSumaDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResumenSumaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
  }) {
    return _then(_$ResumenSumaDtoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResumenSumaDtoImpl implements _ResumenSumaDto {
  const _$ResumenSumaDtoImpl({required this.total});

  factory _$ResumenSumaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResumenSumaDtoImplFromJson(json);

  @override
  final String total;

  @override
  String toString() {
    return 'ResumenSumaDto(total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumenSumaDtoImpl &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total);

  /// Create a copy of ResumenSumaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumenSumaDtoImplCopyWith<_$ResumenSumaDtoImpl> get copyWith =>
      __$$ResumenSumaDtoImplCopyWithImpl<_$ResumenSumaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResumenSumaDtoImplToJson(
      this,
    );
  }
}

abstract class _ResumenSumaDto implements ResumenSumaDto {
  const factory _ResumenSumaDto({required final String total}) =
      _$ResumenSumaDtoImpl;

  factory _ResumenSumaDto.fromJson(Map<String, dynamic> json) =
      _$ResumenSumaDtoImpl.fromJson;

  @override
  String get total;

  /// Create a copy of ResumenSumaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumenSumaDtoImplCopyWith<_$ResumenSumaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
