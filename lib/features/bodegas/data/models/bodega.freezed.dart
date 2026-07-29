// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodega.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Bodega {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int get estadoId => throw _privateConstructorUsedError;
  DateTime get fechaRegistro =>
      throw _privateConstructorUsedError; // `null` = la bodega nunca registró un ciclo de pago ("Sin ciclo de
// pago", `CONTEXTO-PLATAFORMA-WEB.md` sección 8.12) — ya vienen
// calculados por el backend en `GET /tenants`, no se recalculan acá
// (a diferencia de la suscripción propia de `admin_bodega` en Mi
// perfil, que sí se calcula en el cliente porque ese rol no tiene
// acceso a este endpoint).
  int? get diasRestantes => throw _privateConstructorUsedError;
  String? get estadoPagoCalculado => throw _privateConstructorUsedError;

  /// Create a copy of Bodega
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodegaCopyWith<Bodega> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodegaCopyWith<$Res> {
  factory $BodegaCopyWith(Bodega value, $Res Function(Bodega) then) =
      _$BodegaCopyWithImpl<$Res, Bodega>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      int estadoId,
      DateTime fechaRegistro,
      int? diasRestantes,
      String? estadoPagoCalculado});
}

/// @nodoc
class _$BodegaCopyWithImpl<$Res, $Val extends Bodega>
    implements $BodegaCopyWith<$Res> {
  _$BodegaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bodega
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estadoId = null,
    Object? fechaRegistro = null,
    Object? diasRestantes = freezed,
    Object? estadoPagoCalculado = freezed,
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
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      fechaRegistro: null == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diasRestantes: freezed == diasRestantes
          ? _value.diasRestantes
          : diasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      estadoPagoCalculado: freezed == estadoPagoCalculado
          ? _value.estadoPagoCalculado
          : estadoPagoCalculado // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodegaImplCopyWith<$Res> implements $BodegaCopyWith<$Res> {
  factory _$$BodegaImplCopyWith(
          _$BodegaImpl value, $Res Function(_$BodegaImpl) then) =
      __$$BodegaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      int estadoId,
      DateTime fechaRegistro,
      int? diasRestantes,
      String? estadoPagoCalculado});
}

/// @nodoc
class __$$BodegaImplCopyWithImpl<$Res>
    extends _$BodegaCopyWithImpl<$Res, _$BodegaImpl>
    implements _$$BodegaImplCopyWith<$Res> {
  __$$BodegaImplCopyWithImpl(
      _$BodegaImpl _value, $Res Function(_$BodegaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bodega
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? estadoId = null,
    Object? fechaRegistro = null,
    Object? diasRestantes = freezed,
    Object? estadoPagoCalculado = freezed,
  }) {
    return _then(_$BodegaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      fechaRegistro: null == fechaRegistro
          ? _value.fechaRegistro
          : fechaRegistro // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diasRestantes: freezed == diasRestantes
          ? _value.diasRestantes
          : diasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      estadoPagoCalculado: freezed == estadoPagoCalculado
          ? _value.estadoPagoCalculado
          : estadoPagoCalculado // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BodegaImpl extends _Bodega {
  const _$BodegaImpl(
      {required this.id,
      required this.nombre,
      required this.estadoId,
      required this.fechaRegistro,
      this.diasRestantes,
      this.estadoPagoCalculado})
      : super._();

  @override
  final int id;
  @override
  final String nombre;
  @override
  final int estadoId;
  @override
  final DateTime fechaRegistro;
// `null` = la bodega nunca registró un ciclo de pago ("Sin ciclo de
// pago", `CONTEXTO-PLATAFORMA-WEB.md` sección 8.12) — ya vienen
// calculados por el backend en `GET /tenants`, no se recalculan acá
// (a diferencia de la suscripción propia de `admin_bodega` en Mi
// perfil, que sí se calcula en el cliente porque ese rol no tiene
// acceso a este endpoint).
  @override
  final int? diasRestantes;
  @override
  final String? estadoPagoCalculado;

  @override
  String toString() {
    return 'Bodega(id: $id, nombre: $nombre, estadoId: $estadoId, fechaRegistro: $fechaRegistro, diasRestantes: $diasRestantes, estadoPagoCalculado: $estadoPagoCalculado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodegaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.estadoId, estadoId) ||
                other.estadoId == estadoId) &&
            (identical(other.fechaRegistro, fechaRegistro) ||
                other.fechaRegistro == fechaRegistro) &&
            (identical(other.diasRestantes, diasRestantes) ||
                other.diasRestantes == diasRestantes) &&
            (identical(other.estadoPagoCalculado, estadoPagoCalculado) ||
                other.estadoPagoCalculado == estadoPagoCalculado));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombre, estadoId,
      fechaRegistro, diasRestantes, estadoPagoCalculado);

  /// Create a copy of Bodega
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodegaImplCopyWith<_$BodegaImpl> get copyWith =>
      __$$BodegaImplCopyWithImpl<_$BodegaImpl>(this, _$identity);
}

abstract class _Bodega extends Bodega {
  const factory _Bodega(
      {required final int id,
      required final String nombre,
      required final int estadoId,
      required final DateTime fechaRegistro,
      final int? diasRestantes,
      final String? estadoPagoCalculado}) = _$BodegaImpl;
  const _Bodega._() : super._();

  @override
  int get id;
  @override
  String get nombre;
  @override
  int get estadoId;
  @override
  DateTime
      get fechaRegistro; // `null` = la bodega nunca registró un ciclo de pago ("Sin ciclo de
// pago", `CONTEXTO-PLATAFORMA-WEB.md` sección 8.12) — ya vienen
// calculados por el backend en `GET /tenants`, no se recalculan acá
// (a diferencia de la suscripción propia de `admin_bodega` en Mi
// perfil, que sí se calcula en el cliente porque ese rol no tiene
// acceso a este endpoint).
  @override
  int? get diasRestantes;
  @override
  String? get estadoPagoCalculado;

  /// Create a copy of Bodega
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodegaImplCopyWith<_$BodegaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
