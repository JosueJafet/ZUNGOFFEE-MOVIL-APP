import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../../../../core/utils/api_decimal.dart';
import '../models/compra_historial.dart';

part 'compra_historial_dto.freezed.dart';
part 'compra_historial_dto.g.dart';

/// DTO fiel al JSON real de `GET /compras` — confirmado contra la API en
/// vivo, no contra el contrato escrito (que no daba ningún ejemplo de
/// respuesta). Forma completamente distinta a `CompraDto` (la respuesta
/// de `POST /compras`): `proveedores`/`usuarios` anidados en vez de
/// `proveedor_id`/`usuario_id` planos, y sin `tenant_id` ni `anulada`.
@freezed
class CompraHistorialDto with _$CompraHistorialDto {
  const CompraHistorialDto._();

  const factory CompraHistorialDto({
    required int id,
    required String fecha,
    required String total,
    required CompraHistorialProveedorDto proveedores,
    required CompraHistorialUsuarioDto usuarios,
  }) = _CompraHistorialDto;

  factory CompraHistorialDto.fromJson(Map<String, dynamic> json) =>
      _$CompraHistorialDtoFromJson(json);

  CompraHistorial toDomain() {
    return CompraHistorial(
      id: id,
      fecha: ApiDate.fromResponse(fecha),
      total: ApiDecimal.fromJson(total),
      proveedorNombre: proveedores.nombre,
      usuarioNombre: usuarios.nombre,
    );
  }
}

/// Sub-objeto `proveedores` de la respuesta de `GET /compras`.
@freezed
class CompraHistorialProveedorDto with _$CompraHistorialProveedorDto {
  const factory CompraHistorialProveedorDto({
    required int id,
    required String nombre,
  }) = _CompraHistorialProveedorDto;

  factory CompraHistorialProveedorDto.fromJson(Map<String, dynamic> json) =>
      _$CompraHistorialProveedorDtoFromJson(json);
}

/// Sub-objeto `usuarios` de la respuesta de `GET /compras`.
@freezed
class CompraHistorialUsuarioDto with _$CompraHistorialUsuarioDto {
  const factory CompraHistorialUsuarioDto({
    required int id,
    required String nombre,
  }) = _CompraHistorialUsuarioDto;

  factory CompraHistorialUsuarioDto.fromJson(Map<String, dynamic> json) =>
      _$CompraHistorialUsuarioDtoFromJson(json);
}
