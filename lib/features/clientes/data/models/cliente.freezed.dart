// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Cliente {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int? get tipoId => throw _privateConstructorUsedError;
  String? get lugar => throw _privateConstructorUsedError;
  String? get telefono => throw _privateConstructorUsedError;
  bool get estado => throw _privateConstructorUsedError;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClienteCopyWith<Cliente> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClienteCopyWith<$Res> {
  factory $ClienteCopyWith(Cliente value, $Res Function(Cliente) then) =
      _$ClienteCopyWithImpl<$Res, Cliente>;
  @useResult
  $Res call(
      {int id,
      int tenantId,
      String nombre,
      int? tipoId,
      String? lugar,
      String? telefono,
      bool estado});
}

/// @nodoc
class _$ClienteCopyWithImpl<$Res, $Val extends Cliente>
    implements $ClienteCopyWith<$Res> {
  _$ClienteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? tipoId = freezed,
    Object? lugar = freezed,
    Object? telefono = freezed,
    Object? estado = null,
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
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClienteImplCopyWith<$Res> implements $ClienteCopyWith<$Res> {
  factory _$$ClienteImplCopyWith(
          _$ClienteImpl value, $Res Function(_$ClienteImpl) then) =
      __$$ClienteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int tenantId,
      String nombre,
      int? tipoId,
      String? lugar,
      String? telefono,
      bool estado});
}

/// @nodoc
class __$$ClienteImplCopyWithImpl<$Res>
    extends _$ClienteCopyWithImpl<$Res, _$ClienteImpl>
    implements _$$ClienteImplCopyWith<$Res> {
  __$$ClienteImplCopyWithImpl(
      _$ClienteImpl _value, $Res Function(_$ClienteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? nombre = null,
    Object? tipoId = freezed,
    Object? lugar = freezed,
    Object? telefono = freezed,
    Object? estado = null,
  }) {
    return _then(_$ClienteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      tenantId: null == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      tipoId: freezed == tipoId
          ? _value.tipoId
          : tipoId // ignore: cast_nullable_to_non_nullable
              as int?,
      lugar: freezed == lugar
          ? _value.lugar
          : lugar // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ClienteImpl implements _Cliente {
  const _$ClienteImpl(
      {required this.id,
      required this.tenantId,
      required this.nombre,
      this.tipoId,
      this.lugar,
      this.telefono,
      required this.estado});

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final String nombre;
  @override
  final int? tipoId;
  @override
  final String? lugar;
  @override
  final String? telefono;
  @override
  final bool estado;

  @override
  String toString() {
    return 'Cliente(id: $id, tenantId: $tenantId, nombre: $nombre, tipoId: $tipoId, lugar: $lugar, telefono: $telefono, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClienteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.tipoId, tipoId) || other.tipoId == tipoId) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, tenantId, nombre, tipoId, lugar, telefono, estado);

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClienteImplCopyWith<_$ClienteImpl> get copyWith =>
      __$$ClienteImplCopyWithImpl<_$ClienteImpl>(this, _$identity);
}

abstract class _Cliente implements Cliente {
  const factory _Cliente(
      {required final int id,
      required final int tenantId,
      required final String nombre,
      final int? tipoId,
      final String? lugar,
      final String? telefono,
      required final bool estado}) = _$ClienteImpl;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  String get nombre;
  @override
  int? get tipoId;
  @override
  String? get lugar;
  @override
  String? get telefono;
  @override
  bool get estado;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClienteImplCopyWith<_$ClienteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
