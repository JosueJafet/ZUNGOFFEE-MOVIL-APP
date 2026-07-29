import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../models/bodega.dart';

part 'bodega_dto.freezed.dart';
part 'bodega_dto.g.dart';

/// DTO fiel al JSON de `GET /tenants` / `POST /tenants/onboarding` /
/// `PATCH /tenants/:id` / `PATCH /pagos/tenant/:id/suspender`/`activar`
/// (contrato confirmado por Rubio, backend — no está en ningún
/// `CONTEXTO-*.md`) — snake_case, tal como llega de la API.
///
/// No se declara `estados_tenant` (el objeto resuelto tipo
/// `{ nombre: "activo" }`): viene en 3 de los 4 shapes pero falta en la
/// respuesta de `PATCH /tenants/:id` — `estado_id` (int) sí está presente
/// y confirmado en los 4, así que es la única fuente de verdad para
/// `Bodega.activa`.
@freezed
class BodegaDto with _$BodegaDto {
  const BodegaDto._();

  const factory BodegaDto({
    required int id,
    required String nombre,
    @JsonKey(name: 'estado_id') required int estadoId,
    @JsonKey(name: 'fecha_registro') required String fechaRegistro,
    // Solo vienen en `GET /tenants` (confirmado por
    // `CONTEXTO-PLATAFORMA-WEB.md`, sección 8.12) — ausentes en los otros
    // 3 shapes de este mismo DTO (onboarding/editar/suspender-activar),
    // por eso van opcionales y no `required` como el resto de los
    // campos, no porque el contrato los marque como tal.
    @JsonKey(name: 'dias_restantes') int? diasRestantes,
    @JsonKey(name: 'estado_pago_calculado') String? estadoPagoCalculado,
  }) = _BodegaDto;

  factory BodegaDto.fromJson(Map<String, dynamic> json) =>
      _$BodegaDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Bodega` (camelCase).
  Bodega toDomain() {
    return Bodega(
      id: id,
      nombre: nombre,
      estadoId: estadoId,
      fechaRegistro: ApiDate.fromResponse(fechaRegistro),
      diasRestantes: diasRestantes,
      estadoPagoCalculado: estadoPagoCalculado,
    );
  }
}
