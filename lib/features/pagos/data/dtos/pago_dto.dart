import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_date.dart';
import '../../../../core/utils/api_decimal.dart';
import '../models/pago.dart';

part 'pago_dto.freezed.dart';
part 'pago_dto.g.dart';

/// DTO fiel al JSON de `GET /pagos/tenant/:tenantId` (contrato confirmado
/// por Rubio, backend — no está en ningún `CONTEXTO-*.md`) — snake_case,
/// tal como llega de la API.
///
/// `estadoCalculado` es `required` a propósito: este DTO **solo** se usa
/// para parsear la respuesta de `GET /pagos/tenant/:tenantId`, que
/// siempre lo trae. `POST /pagos` y `PATCH /pagos/:id/marcar-pagado` NO
/// lo incluyen en su respuesta (gotcha verificado por Rubio) — por eso
/// esos dos datasources descartan su respuesta en vez de parsearla con
/// este DTO (ver `pago_remote_datasource.dart`).
@freezed
class PagoDto with _$PagoDto {
  const PagoDto._();

  const factory PagoDto({
    required int id,
    @JsonKey(name: 'tenant_id') required int tenantId,
    required String periodo,
    required String monto,
    @JsonKey(name: 'fecha_vencimiento') required String fechaVencimiento,
    @JsonKey(name: 'fecha_pago') String? fechaPago,
    @JsonKey(name: 'estado_pago_id') required int estadoPagoId,
    @JsonKey(name: 'registrado_por') required int registradoPor,
    @JsonKey(name: 'estado_calculado') required String estadoCalculado,
  }) = _PagoDto;

  factory PagoDto.fromJson(Map<String, dynamic> json) =>
      _$PagoDtoFromJson(json);

  /// Mapea este DTO (snake_case, fiel al JSON) al modelo de dominio
  /// `Pago` (camelCase, con fechas/decimales ya parseados).
  Pago toDomain() {
    return Pago(
      id: id,
      tenantId: tenantId,
      periodo: ApiDate.fromResponse(periodo),
      monto: ApiDecimal.fromJson(monto),
      fechaVencimiento: ApiDate.fromResponse(fechaVencimiento),
      fechaPago: fechaPago == null ? null : ApiDate.fromResponse(fechaPago!),
      estadoPagoId: estadoPagoId,
      registradoPor: registradoPor,
      estadoCalculado: estadoCalculado,
    );
  }
}
