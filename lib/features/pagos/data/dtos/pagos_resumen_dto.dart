import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/api_decimal.dart';
import '../models/pagos_resumen.dart';

part 'pagos_resumen_dto.freezed.dart';
part 'pagos_resumen_dto.g.dart';

/// DTO fiel al JSON de `GET /pagos/resumen` (contrato confirmado por
/// Rubio, backend — no está en ningún `CONTEXTO-*.md`).
///
/// A diferencia del resto de la API, esta respuesta ya viene en
/// camelCase — no hace falta `@JsonKey` para ningún campo.
@freezed
class PagosResumenDto with _$PagosResumenDto {
  const PagosResumenDto._();

  const factory PagosResumenDto({
    required int tenantsActivos,
    required int tenantsSuspendidos,
    required String ingresosMesActual,
    required String ingresosTotales,
  }) = _PagosResumenDto;

  factory PagosResumenDto.fromJson(Map<String, dynamic> json) =>
      _$PagosResumenDtoFromJson(json);

  /// Mapea este DTO (fiel al JSON) al modelo de dominio `PagosResumen`
  /// (con los decimales ya parseados).
  PagosResumen toDomain() {
    return PagosResumen(
      tenantsActivos: tenantsActivos,
      tenantsSuspendidos: tenantsSuspendidos,
      ingresosMesActual: ApiDecimal.fromJson(ingresosMesActual),
      ingresosTotales: ApiDecimal.fromJson(ingresosTotales),
    );
  }
}
