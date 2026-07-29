// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'solicitud.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Solicitud {
  int get id => throw _privateConstructorUsedError;
  String get nombreBodega => throw _privateConstructorUsedError;
  String get nombreContacto => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // `null` cuando la solicitud llegó sin teléfono (dato real de
// producción, no todos los rows lo traen).
  String? get telefono => throw _privateConstructorUsedError;
  String? get mensaje => throw _privateConstructorUsedError;
  int get estadoId => throw _privateConstructorUsedError;
  int? get tenantCreadoId => throw _privateConstructorUsedError;
  DateTime get fechaCreacion => throw _privateConstructorUsedError;

  /// Create a copy of Solicitud
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SolicitudCopyWith<Solicitud> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SolicitudCopyWith<$Res> {
  factory $SolicitudCopyWith(Solicitud value, $Res Function(Solicitud) then) =
      _$SolicitudCopyWithImpl<$Res, Solicitud>;
  @useResult
  $Res call(
      {int id,
      String nombreBodega,
      String nombreContacto,
      String email,
      String? telefono,
      String? mensaje,
      int estadoId,
      int? tenantCreadoId,
      DateTime fechaCreacion});
}

/// @nodoc
class _$SolicitudCopyWithImpl<$Res, $Val extends Solicitud>
    implements $SolicitudCopyWith<$Res> {
  _$SolicitudCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Solicitud
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreBodega = null,
    Object? nombreContacto = null,
    Object? email = null,
    Object? telefono = freezed,
    Object? mensaje = freezed,
    Object? estadoId = null,
    Object? tenantCreadoId = freezed,
    Object? fechaCreacion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreBodega: null == nombreBodega
          ? _value.nombreBodega
          : nombreBodega // ignore: cast_nullable_to_non_nullable
              as String,
      nombreContacto: null == nombreContacto
          ? _value.nombreContacto
          : nombreContacto // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      mensaje: freezed == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantCreadoId: freezed == tenantCreadoId
          ? _value.tenantCreadoId
          : tenantCreadoId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SolicitudImplCopyWith<$Res>
    implements $SolicitudCopyWith<$Res> {
  factory _$$SolicitudImplCopyWith(
          _$SolicitudImpl value, $Res Function(_$SolicitudImpl) then) =
      __$$SolicitudImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombreBodega,
      String nombreContacto,
      String email,
      String? telefono,
      String? mensaje,
      int estadoId,
      int? tenantCreadoId,
      DateTime fechaCreacion});
}

/// @nodoc
class __$$SolicitudImplCopyWithImpl<$Res>
    extends _$SolicitudCopyWithImpl<$Res, _$SolicitudImpl>
    implements _$$SolicitudImplCopyWith<$Res> {
  __$$SolicitudImplCopyWithImpl(
      _$SolicitudImpl _value, $Res Function(_$SolicitudImpl) _then)
      : super(_value, _then);

  /// Create a copy of Solicitud
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreBodega = null,
    Object? nombreContacto = null,
    Object? email = null,
    Object? telefono = freezed,
    Object? mensaje = freezed,
    Object? estadoId = null,
    Object? tenantCreadoId = freezed,
    Object? fechaCreacion = null,
  }) {
    return _then(_$SolicitudImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreBodega: null == nombreBodega
          ? _value.nombreBodega
          : nombreBodega // ignore: cast_nullable_to_non_nullable
              as String,
      nombreContacto: null == nombreContacto
          ? _value.nombreContacto
          : nombreContacto // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      mensaje: freezed == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String?,
      estadoId: null == estadoId
          ? _value.estadoId
          : estadoId // ignore: cast_nullable_to_non_nullable
              as int,
      tenantCreadoId: freezed == tenantCreadoId
          ? _value.tenantCreadoId
          : tenantCreadoId // ignore: cast_nullable_to_non_nullable
              as int?,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SolicitudImpl extends _Solicitud {
  const _$SolicitudImpl(
      {required this.id,
      required this.nombreBodega,
      required this.nombreContacto,
      required this.email,
      this.telefono,
      this.mensaje,
      required this.estadoId,
      this.tenantCreadoId,
      required this.fechaCreacion})
      : super._();

  @override
  final int id;
  @override
  final String nombreBodega;
  @override
  final String nombreContacto;
  @override
  final String email;
// `null` cuando la solicitud llegó sin teléfono (dato real de
// producción, no todos los rows lo traen).
  @override
  final String? telefono;
  @override
  final String? mensaje;
  @override
  final int estadoId;
  @override
  final int? tenantCreadoId;
  @override
  final DateTime fechaCreacion;

  @override
  String toString() {
    return 'Solicitud(id: $id, nombreBodega: $nombreBodega, nombreContacto: $nombreContacto, email: $email, telefono: $telefono, mensaje: $mensaje, estadoId: $estadoId, tenantCreadoId: $tenantCreadoId, fechaCreacion: $fechaCreacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SolicitudImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreBodega, nombreBodega) ||
                other.nombreBodega == nombreBodega) &&
            (identical(other.nombreContacto, nombreContacto) ||
                other.nombreContacto == nombreContacto) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.mensaje, mensaje) || other.mensaje == mensaje) &&
            (identical(other.estadoId, estadoId) ||
                other.estadoId == estadoId) &&
            (identical(other.tenantCreadoId, tenantCreadoId) ||
                other.tenantCreadoId == tenantCreadoId) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nombreBodega, nombreContacto,
      email, telefono, mensaje, estadoId, tenantCreadoId, fechaCreacion);

  /// Create a copy of Solicitud
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SolicitudImplCopyWith<_$SolicitudImpl> get copyWith =>
      __$$SolicitudImplCopyWithImpl<_$SolicitudImpl>(this, _$identity);
}

abstract class _Solicitud extends Solicitud {
  const factory _Solicitud(
      {required final int id,
      required final String nombreBodega,
      required final String nombreContacto,
      required final String email,
      final String? telefono,
      final String? mensaje,
      required final int estadoId,
      final int? tenantCreadoId,
      required final DateTime fechaCreacion}) = _$SolicitudImpl;
  const _Solicitud._() : super._();

  @override
  int get id;
  @override
  String get nombreBodega;
  @override
  String get nombreContacto;
  @override
  String
      get email; // `null` cuando la solicitud llegó sin teléfono (dato real de
// producción, no todos los rows lo traen).
  @override
  String? get telefono;
  @override
  String? get mensaje;
  @override
  int get estadoId;
  @override
  int? get tenantCreadoId;
  @override
  DateTime get fechaCreacion;

  /// Create a copy of Solicitud
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SolicitudImplCopyWith<_$SolicitudImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
