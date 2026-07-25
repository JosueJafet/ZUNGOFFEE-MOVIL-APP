// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procesamiento.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Procesamiento {
  String get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  String get loteOrigenId => throw _privateConstructorUsedError;
  String get loteDestinoId => throw _privateConstructorUsedError;
  double get cantidadEntrada => throw _privateConstructorUsedError;
  double get cantidadSalida => throw _privateConstructorUsedError;

  /// Create a copy of Procesamiento
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcesamientoCopyWith<Procesamiento> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcesamientoCopyWith<$Res> {
  factory $ProcesamientoCopyWith(
          Procesamiento value, $Res Function(Procesamiento) then) =
      _$ProcesamientoCopyWithImpl<$Res, Procesamiento>;
  @useResult
  $Res call(
      {String id,
      int tenantId,
      String loteOrigenId,
      String loteDestinoId,
      double cantidadEntrada,
      double cantidadSalida});
}

/// @nodoc
class _$ProcesamientoCopyWithImpl<$Res, $Val extends Procesamiento>
    implements $ProcesamientoCopyWith<$Res> {
  _$ProcesamientoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Procesamiento
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
              as double,
      cantidadSalida: null == cantidadSalida
          ? _value.cantidadSalida
          : cantidadSalida // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcesamientoImplCopyWith<$Res>
    implements $ProcesamientoCopyWith<$Res> {
  factory _$$ProcesamientoImplCopyWith(
          _$ProcesamientoImpl value, $Res Function(_$ProcesamientoImpl) then) =
      __$$ProcesamientoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int tenantId,
      String loteOrigenId,
      String loteDestinoId,
      double cantidadEntrada,
      double cantidadSalida});
}

/// @nodoc
class __$$ProcesamientoImplCopyWithImpl<$Res>
    extends _$ProcesamientoCopyWithImpl<$Res, _$ProcesamientoImpl>
    implements _$$ProcesamientoImplCopyWith<$Res> {
  __$$ProcesamientoImplCopyWithImpl(
      _$ProcesamientoImpl _value, $Res Function(_$ProcesamientoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Procesamiento
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
    return _then(_$ProcesamientoImpl(
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
              as double,
      cantidadSalida: null == cantidadSalida
          ? _value.cantidadSalida
          : cantidadSalida // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ProcesamientoImpl implements _Procesamiento {
  const _$ProcesamientoImpl(
      {required this.id,
      required this.tenantId,
      required this.loteOrigenId,
      required this.loteDestinoId,
      required this.cantidadEntrada,
      required this.cantidadSalida});

  @override
  final String id;
  @override
  final int tenantId;
  @override
  final String loteOrigenId;
  @override
  final String loteDestinoId;
  @override
  final double cantidadEntrada;
  @override
  final double cantidadSalida;

  @override
  String toString() {
    return 'Procesamiento(id: $id, tenantId: $tenantId, loteOrigenId: $loteOrigenId, loteDestinoId: $loteDestinoId, cantidadEntrada: $cantidadEntrada, cantidadSalida: $cantidadSalida)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcesamientoImpl &&
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

  @override
  int get hashCode => Object.hash(runtimeType, id, tenantId, loteOrigenId,
      loteDestinoId, cantidadEntrada, cantidadSalida);

  /// Create a copy of Procesamiento
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcesamientoImplCopyWith<_$ProcesamientoImpl> get copyWith =>
      __$$ProcesamientoImplCopyWithImpl<_$ProcesamientoImpl>(this, _$identity);
}

abstract class _Procesamiento implements Procesamiento {
  const factory _Procesamiento(
      {required final String id,
      required final int tenantId,
      required final String loteOrigenId,
      required final String loteDestinoId,
      required final double cantidadEntrada,
      required final double cantidadSalida}) = _$ProcesamientoImpl;

  @override
  String get id;
  @override
  int get tenantId;
  @override
  String get loteOrigenId;
  @override
  String get loteDestinoId;
  @override
  double get cantidadEntrada;
  @override
  double get cantidadSalida;

  /// Create a copy of Procesamiento
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcesamientoImplCopyWith<_$ProcesamientoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
