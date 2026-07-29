// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resumen_diario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResumenDiario {
  DateTime get fecha => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Create a copy of ResumenDiario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResumenDiarioCopyWith<ResumenDiario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumenDiarioCopyWith<$Res> {
  factory $ResumenDiarioCopyWith(
          ResumenDiario value, $Res Function(ResumenDiario) then) =
      _$ResumenDiarioCopyWithImpl<$Res, ResumenDiario>;
  @useResult
  $Res call({DateTime fecha, double total});
}

/// @nodoc
class _$ResumenDiarioCopyWithImpl<$Res, $Val extends ResumenDiario>
    implements $ResumenDiarioCopyWith<$Res> {
  _$ResumenDiarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResumenDiario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResumenDiarioImplCopyWith<$Res>
    implements $ResumenDiarioCopyWith<$Res> {
  factory _$$ResumenDiarioImplCopyWith(
          _$ResumenDiarioImpl value, $Res Function(_$ResumenDiarioImpl) then) =
      __$$ResumenDiarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime fecha, double total});
}

/// @nodoc
class __$$ResumenDiarioImplCopyWithImpl<$Res>
    extends _$ResumenDiarioCopyWithImpl<$Res, _$ResumenDiarioImpl>
    implements _$$ResumenDiarioImplCopyWith<$Res> {
  __$$ResumenDiarioImplCopyWithImpl(
      _$ResumenDiarioImpl _value, $Res Function(_$ResumenDiarioImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResumenDiario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fecha = null,
    Object? total = null,
  }) {
    return _then(_$ResumenDiarioImpl(
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ResumenDiarioImpl implements _ResumenDiario {
  const _$ResumenDiarioImpl({required this.fecha, required this.total});

  @override
  final DateTime fecha;
  @override
  final double total;

  @override
  String toString() {
    return 'ResumenDiario(fecha: $fecha, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumenDiarioImpl &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fecha, total);

  /// Create a copy of ResumenDiario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumenDiarioImplCopyWith<_$ResumenDiarioImpl> get copyWith =>
      __$$ResumenDiarioImplCopyWithImpl<_$ResumenDiarioImpl>(this, _$identity);
}

abstract class _ResumenDiario implements ResumenDiario {
  const factory _ResumenDiario(
      {required final DateTime fecha,
      required final double total}) = _$ResumenDiarioImpl;

  @override
  DateTime get fecha;
  @override
  double get total;

  /// Create a copy of ResumenDiario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumenDiarioImplCopyWith<_$ResumenDiarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
