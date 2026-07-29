import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/api_date.dart';
import '../../../core/utils/api_decimal.dart';
import '../models/resumen_diario.dart';

part 'resumen_diario_dto.freezed.dart';
part 'resumen_diario_dto.g.dart';

/// DTO fiel al JSON de `GET /compras/resumen` / `GET /ventas/resumen`
/// (contrato confirmado en producción — no está en ningún
/// `CONTEXTO-*.md`, que solo menciona "totales por fecha, 30 días" sin
/// el shape exacto). Es un `groupBy` de Prisma, **no** un total ya
/// agregado:
///
/// ```
/// [{ "_sum": { "total": "12292318.84" }, "fecha": "2026-07-21T00:00:00.000Z" }, ...]
/// ```
///
/// Gotchas verificados: el endpoint ignora cualquier query param
/// (`?desde&hasta` no hacen nada, está fijo a `take: 30` en el
/// backend); y "30" son los últimos 30 *grupos de fecha con actividad*,
/// no 30 días de calendario — si un día no tuvo compras/ventas, no
/// aparece una fila para ese día. El total mostrado en la UI ("Compras
/// (30 días)") es la suma de `_sum.total` de todas las filas,
/// calculada del lado del cliente (ver `home_screen.dart`).
@freezed
class ResumenDiarioDto with _$ResumenDiarioDto {
  const ResumenDiarioDto._();

  const factory ResumenDiarioDto({
    required String fecha,
    @JsonKey(name: '_sum') required ResumenSumaDto sum,
  }) = _ResumenDiarioDto;

  factory ResumenDiarioDto.fromJson(Map<String, dynamic> json) =>
      _$ResumenDiarioDtoFromJson(json);

  ResumenDiario toDomain() {
    return ResumenDiario(
      fecha: ApiDate.fromResponse(fecha),
      total: ApiDecimal.fromJson(sum.total),
    );
  }
}

/// Sub-objeto `_sum` del `groupBy` de Prisma.
@freezed
class ResumenSumaDto with _$ResumenSumaDto {
  const factory ResumenSumaDto({required String total}) = _ResumenSumaDto;

  factory ResumenSumaDto.fromJson(Map<String, dynamic> json) =>
      _$ResumenSumaDtoFromJson(json);
}
