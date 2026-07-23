import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../models/perfil.dart';

part 'perfil_dto.freezed.dart';
part 'perfil_dto.g.dart';

/// DTO fiel al JSON de `GET /perfil` (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.8) — nombres de campo en snake_case, tal como llegan de la API.
@freezed
class PerfilDto with _$PerfilDto {
  const PerfilDto._();

  const factory PerfilDto({
    required int id,
    required String nombre,
    required bool estado,
    @JsonKey(name: 'fecha_creacion') required String fechaCreacion,
    required PerfilRolDto roles,
    required PerfilTenantDto tenants,
  }) = _PerfilDto;

  factory PerfilDto.fromJson(Map<String, dynamic> json) =>
      _$PerfilDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Perfil` (camelCase, listo para el resto de la app).
  Perfil toDomain() {
    return Perfil(
      id: id,
      nombre: nombre,
      activo: estado,
      fechaCreacion: ApiDate.fromResponse(fechaCreacion),
      rol: roles.nombre,
      tenantId: tenants.id,
      tenantNombre: tenants.nombre,
    );
  }
}

/// Sub-objeto `roles` de la respuesta de `GET /perfil`.
@freezed
class PerfilRolDto with _$PerfilRolDto {
  const factory PerfilRolDto({required String nombre}) = _PerfilRolDto;

  factory PerfilRolDto.fromJson(Map<String, dynamic> json) =>
      _$PerfilRolDtoFromJson(json);
}

/// Sub-objeto `tenants` de la respuesta de `GET /perfil`.
@freezed
class PerfilTenantDto with _$PerfilTenantDto {
  const factory PerfilTenantDto({
    required int id,
    required String nombre,
  }) = _PerfilTenantDto;

  factory PerfilTenantDto.fromJson(Map<String, dynamic> json) =>
      _$PerfilTenantDtoFromJson(json);
}
