import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/pagos/data/dtos/pagos_resumen_dto.dart';

void main() {
  group('PagosResumenDto', () {
    // JSON de ejemplo de `GET /pagos/resumen` (contrato confirmado por
    // Rubio, backend) — a diferencia del resto de la API, ya viene en
    // camelCase.
    final json = {
      'tenantsActivos': 16,
      'tenantsSuspendidos': 2,
      'ingresosMesActual': '1000',
      'ingresosTotales': '1000',
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = PagosResumenDto.fromJson(json);

      expect(dto.tenantsActivos, 16);
      expect(dto.tenantsSuspendidos, 2);
      expect(dto.ingresosMesActual, '1000');
      expect(dto.ingresosTotales, '1000');
    });

    test('toDomain mapea al modelo de dominio PagosResumen', () {
      final resumen = PagosResumenDto.fromJson(json).toDomain();

      expect(resumen.tenantsActivos, 16);
      expect(resumen.tenantsSuspendidos, 2);
      expect(resumen.ingresosMesActual, 1000.0);
      expect(resumen.ingresosTotales, 1000.0);
    });
  });
}
