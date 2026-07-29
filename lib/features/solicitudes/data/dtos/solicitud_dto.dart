import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../models/solicitud.dart';

part 'solicitud_dto.freezed.dart';
part 'solicitud_dto.g.dart';

/// DTO fiel al JSON de `GET /solicitudes` / `PATCH
/// /solicitudes/:id/rechazar` (contrato confirmado por Rubio, backend —
/// no está en ningún `CONTEXTO-*.md`) — snake_case, tal como llega de la
/// API.
///
/// A diferencia de `GET /tenants`, acá `estado_id` llega sin resolver:
/// no hay un objeto tipo `estados_solicitud: { nombre }` — el cliente
/// mapea el número (ver `Solicitud.estadoLabel`).
@freezed
class SolicitudDto with _$SolicitudDto {
  const SolicitudDto._();

  const factory SolicitudDto({
    required int id,
    @JsonKey(name: 'nombre_bodega') required String nombreBodega,
    @JsonKey(name: 'nombre_contacto') required String nombreContacto,
    required String email,
    // Nullable: al menos una solicitud real en producción llega sin
    // teléfono (visto en el panel web, fila sin número bajo el
    // contacto) — declararlo `required` rompía el parseo de *todo* el
    // array, mismo patrón de bug ya corregido en `PerfilTenantDto`.
    String? telefono,
    String? mensaje,
    @JsonKey(name: 'estado_id') required int estadoId,
    @JsonKey(name: 'tenant_creado_id') int? tenantCreadoId,
    @JsonKey(name: 'fecha_creacion') required String fechaCreacion,
  }) = _SolicitudDto;

  factory SolicitudDto.fromJson(Map<String, dynamic> json) =>
      _$SolicitudDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Solicitud` (camelCase).
  Solicitud toDomain() {
    return Solicitud(
      id: id,
      nombreBodega: nombreBodega,
      nombreContacto: nombreContacto,
      email: email,
      telefono: telefono,
      mensaje: mensaje,
      estadoId: estadoId,
      tenantCreadoId: tenantCreadoId,
      fechaCreacion: ApiDate.fromResponse(fechaCreacion),
    );
  }
}
