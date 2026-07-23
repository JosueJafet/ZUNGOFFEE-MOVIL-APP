import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/proveedor.dart';

part 'proveedor_dto.freezed.dart';
part 'proveedor_dto.g.dart';

/// DTO fiel al JSON de `GET`/`POST`/`PATCH /proveedores`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.2) — snake_case, tal como
/// llega de la API.
@freezed
class ProveedorDto with _$ProveedorDto {
  const ProveedorDto._();

  const factory ProveedorDto({
    required int id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    @JsonKey(name: 'tipo_id') int? tipoId,
    String? telefono,
    required bool estado,
  }) = _ProveedorDto;

  factory ProveedorDto.fromJson(Map<String, dynamic> json) =>
      _$ProveedorDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Proveedor` (camelCase).
  Proveedor toDomain() {
    return Proveedor(
      id: id,
      tenantId: tenantId,
      nombre: nombre,
      sexo: sexo,
      lugar: lugar,
      finca: finca,
      tipoId: tipoId,
      telefono: telefono,
      estado: estado,
    );
  }
}
