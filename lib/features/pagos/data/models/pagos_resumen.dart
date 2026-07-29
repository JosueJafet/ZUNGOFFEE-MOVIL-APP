import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagos_resumen.freezed.dart';

/// Modelo de dominio del resumen de KPIs de pagos (`GET /pagos/resumen`),
/// mapeado desde `PagosResumenDto`. Solo lo ve `super_admin`
/// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.14).
@freezed
class PagosResumen with _$PagosResumen {
  const factory PagosResumen({
    required int tenantsActivos,
    required int tenantsSuspendidos,
    required double ingresosMesActual,
    required double ingresosTotales,
  }) = _PagosResumen;
}
