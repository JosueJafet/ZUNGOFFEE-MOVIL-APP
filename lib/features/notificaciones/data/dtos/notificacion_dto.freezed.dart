// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notificacion_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificacionDto _$NotificacionDtoFromJson(Map<String, dynamic> json) {
  return _NotificacionDto.fromJson(json);
}

/// @nodoc
mixin _$NotificacionDto {
  String get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get mensaje => throw _privateConstructorUsedError;
  bool get leida => throw _privateConstructorUsedError;

  /// Serializes this NotificacionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificacionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificacionDtoCopyWith<NotificacionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificacionDtoCopyWith<$Res> {
  factory $NotificacionDtoCopyWith(
          NotificacionDto value, $Res Function(NotificacionDto) then) =
      _$NotificacionDtoCopyWithImpl<$Res, NotificacionDto>;
  @useResult
  $Res call({String id, String titulo, String mensaje, bool leida});
}

/// @nodoc
class _$NotificacionDtoCopyWithImpl<$Res, $Val extends NotificacionDto>
    implements $NotificacionDtoCopyWith<$Res> {
  _$NotificacionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificacionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensaje = null,
    Object? leida = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensaje: null == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String,
      leida: null == leida
          ? _value.leida
          : leida // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificacionDtoImplCopyWith<$Res>
    implements $NotificacionDtoCopyWith<$Res> {
  factory _$$NotificacionDtoImplCopyWith(_$NotificacionDtoImpl value,
          $Res Function(_$NotificacionDtoImpl) then) =
      __$$NotificacionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String titulo, String mensaje, bool leida});
}

/// @nodoc
class __$$NotificacionDtoImplCopyWithImpl<$Res>
    extends _$NotificacionDtoCopyWithImpl<$Res, _$NotificacionDtoImpl>
    implements _$$NotificacionDtoImplCopyWith<$Res> {
  __$$NotificacionDtoImplCopyWithImpl(
      _$NotificacionDtoImpl _value, $Res Function(_$NotificacionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificacionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? mensaje = null,
    Object? leida = null,
  }) {
    return _then(_$NotificacionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      mensaje: null == mensaje
          ? _value.mensaje
          : mensaje // ignore: cast_nullable_to_non_nullable
              as String,
      leida: null == leida
          ? _value.leida
          : leida // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificacionDtoImpl extends _NotificacionDto {
  const _$NotificacionDtoImpl(
      {required this.id,
      required this.titulo,
      required this.mensaje,
      required this.leida})
      : super._();

  factory _$NotificacionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificacionDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String titulo;
  @override
  final String mensaje;
  @override
  final bool leida;

  @override
  String toString() {
    return 'NotificacionDto(id: $id, titulo: $titulo, mensaje: $mensaje, leida: $leida)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificacionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.mensaje, mensaje) || other.mensaje == mensaje) &&
            (identical(other.leida, leida) || other.leida == leida));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, titulo, mensaje, leida);

  /// Create a copy of NotificacionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificacionDtoImplCopyWith<_$NotificacionDtoImpl> get copyWith =>
      __$$NotificacionDtoImplCopyWithImpl<_$NotificacionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificacionDtoImplToJson(
      this,
    );
  }
}

abstract class _NotificacionDto extends NotificacionDto {
  const factory _NotificacionDto(
      {required final String id,
      required final String titulo,
      required final String mensaje,
      required final bool leida}) = _$NotificacionDtoImpl;
  const _NotificacionDto._() : super._();

  factory _NotificacionDto.fromJson(Map<String, dynamic> json) =
      _$NotificacionDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get titulo;
  @override
  String get mensaje;
  @override
  bool get leida;

  /// Create a copy of NotificacionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificacionDtoImplCopyWith<_$NotificacionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
