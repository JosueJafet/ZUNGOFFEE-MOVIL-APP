import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../../../../core/utils/api_decimal.dart';
import '../models/venta_historial.dart';

part 'venta_historial_dto.freezed.dart';
part 'venta_historial_dto.g.dart';

/// DTO fiel al JSON real de `GET /ventas` — confirmado contra la API en
/// vivo, no contra el contrato escrito (que no daba ningún ejemplo de
/// respuesta). Forma completamente distinta a `VentaDto` (la respuesta
/// de `POST /ventas`): `clientes` anidado en vez de `cliente_id` plano,
/// sin `tenant_id` ni `anulada`, y sí trae `fecha`.
@freezed
class VentaHistorialDto with _$VentaHistorialDto {
  const VentaHistorialDto._();

  const factory VentaHistorialDto({
    required int id,
    required String fecha,
    required String total,
    required VentaHistorialClienteDto clientes,
  }) = _VentaHistorialDto;

  factory VentaHistorialDto.fromJson(Map<String, dynamic> json) =>
      _$VentaHistorialDtoFromJson(json);

  VentaHistorial toDomain() {
    return VentaHistorial(
      id: id,
      fecha: ApiDate.fromResponse(fecha),
      total: ApiDecimal.fromJson(total),
      clienteNombre: clientes.nombre,
    );
  }
}

/// Sub-objeto `clientes` de la respuesta de `GET /ventas`.
@freezed
class VentaHistorialClienteDto with _$VentaHistorialClienteDto {
  const factory VentaHistorialClienteDto({
    required int id,
    required String nombre,
  }) = _VentaHistorialClienteDto;

  factory VentaHistorialClienteDto.fromJson(Map<String, dynamic> json) =>
      _$VentaHistorialClienteDtoFromJson(json);
}
