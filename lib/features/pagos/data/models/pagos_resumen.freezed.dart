// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagos_resumen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PagosResumen {
  int get tenantsActivos => throw _privateConstructorUsedError;
  int get tenantsSuspendidos => throw _privateConstructorUsedError;
  double get ingresosMesActual => throw _privateConstructorUsedError;
  double get ingresosTotales => throw _privateConstructorUsedError;

  /// Create a copy of PagosResumen
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagosResumenCopyWith<PagosResumen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagosResumenCopyWith<$Res> {
  factory $PagosResumenCopyWith(
          PagosResumen value, $Res Function(PagosResumen) then) =
      _$PagosResumenCopyWithImpl<$Res, PagosResumen>;
  @useResult
  $Res call(
      {int tenantsActivos,
      int tenantsSuspendidos,
      double ingresosMesActual,
      double ingresosTotales});
}

/// @nodoc
class _$PagosResumenCopyWithImpl<$Res, $Val extends PagosResumen>
    implements $PagosResumenCopyWith<$Res> {
  _$PagosResumenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PagosResumen
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
              as double,
      ingresosTotales: null == ingresosTotales
          ? _value.ingresosTotales
          : ingresosTotales // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PagosResumenImplCopyWith<$Res>
    implements $PagosResumenCopyWith<$Res> {
  factory _$$PagosResumenImplCopyWith(
          _$PagosResumenImpl value, $Res Function(_$PagosResumenImpl) then) =
      __$$PagosResumenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int tenantsActivos,
      int tenantsSuspendidos,
      double ingresosMesActual,
      double ingresosTotales});
}

/// @nodoc
class __$$PagosResumenImplCopyWithImpl<$Res>
    extends _$PagosResumenCopyWithImpl<$Res, _$PagosResumenImpl>
    implements _$$PagosResumenImplCopyWith<$Res> {
  __$$PagosResumenImplCopyWithImpl(
      _$PagosResumenImpl _value, $Res Function(_$PagosResumenImpl) _then)
      : super(_value, _then);

  /// Create a copy of PagosResumen
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantsActivos = null,
    Object? tenantsSuspendidos = null,
    Object? ingresosMesActual = null,
    Object? ingresosTotales = null,
  }) {
    return _then(_$PagosResumenImpl(
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
              as double,
      ingresosTotales: null == ingresosTotales
          ? _value.ingresosTotales
          : ingresosTotales // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PagosResumenImpl implements _PagosResumen {
  const _$PagosResumenImpl(
      {required this.tenantsActivos,
      required this.tenantsSuspendidos,
      required this.ingresosMesActual,
      required this.ingresosTotales});

  @override
  final int tenantsActivos;
  @override
  final int tenantsSuspendidos;
  @override
  final double ingresosMesActual;
  @override
  final double ingresosTotales;

  @override
  String toString() {
    return 'PagosResumen(tenantsActivos: $tenantsActivos, tenantsSuspendidos: $tenantsSuspendidos, ingresosMesActual: $ingresosMesActual, ingresosTotales: $ingresosTotales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagosResumenImpl &&
            (identical(other.tenantsActivos, tenantsActivos) ||
                other.tenantsActivos == tenantsActivos) &&
            (identical(other.tenantsSuspendidos, tenantsSuspendidos) ||
                other.tenantsSuspendidos == tenantsSuspendidos) &&
            (identical(other.ingresosMesActual, ingresosMesActual) ||
                other.ingresosMesActual == ingresosMesActual) &&
            (identical(other.ingresosTotales, ingresosTotales) ||
                other.ingresosTotales == ingresosTotales));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tenantsActivos,
      tenantsSuspendidos, ingresosMesActual, ingresosTotales);

  /// Create a copy of PagosResumen
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagosResumenImplCopyWith<_$PagosResumenImpl> get copyWith =>
      __$$PagosResumenImplCopyWithImpl<_$PagosResumenImpl>(this, _$identity);
}

abstract class _PagosResumen implements PagosResumen {
  const factory _PagosResumen(
      {required final int tenantsActivos,
      required final int tenantsSuspendidos,
      required final double ingresosMesActual,
      required final double ingresosTotales}) = _$PagosResumenImpl;

  @override
  int get tenantsActivos;
  @override
  int get tenantsSuspendidos;
  @override
  double get ingresosMesActual;
  @override
  double get ingresosTotales;

  /// Create a copy of PagosResumen
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagosResumenImplCopyWith<_$PagosResumenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
