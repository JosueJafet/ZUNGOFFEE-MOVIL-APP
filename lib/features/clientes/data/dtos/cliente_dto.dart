import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/cliente.dart';

part 'cliente_dto.freezed.dart';
part 'cliente_dto.g.dart';

/// DTO fiel al JSON de `GET`/`POST`/`PATCH /clientes`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, secciones 6.2b y 7) — snake_case, tal
/// como llega de la API.
@freezed
class ClienteDto with _$ClienteDto {
  const ClienteDto._();

  const factory ClienteDto({
    required int id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    required String nombre,
    @JsonKey(name: 'tipo_id') int? tipoId,
    String? lugar,
    String? telefono,
    required bool estado,
  }) = _ClienteDto;

  factory ClienteDto.fromJson(Map<String, dynamic> json) =>
      _$ClienteDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Cliente` (camelCase).
  Cliente toDomain() {
    return Cliente(
      id: id,
      tenantId: tenantId,
      nombre: nombre,
      tipoId: tipoId,
      lugar: lugar,
      telefono: telefono,
      estado: estado,
    );
  }
}