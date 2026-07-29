import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/shared/data/dtos/resumen_diario_dto.dart';

void main() {
  group('ResumenDiarioDto', () {
    // JSON de ejemplo de `GET /compras/resumen` / `GET /ventas/resumen`
    // (contrato confirmado en producción) — un `groupBy` de Prisma, no
    // un total ya agregado.
    final json = {
      '_sum': {'total': '12292318.84'},
      'fecha': '2026-07-21T00:00:00.000Z',
    };

    test('fromJson parsea el shape anidado del groupBy', () {
      final dto = ResumenDiarioDto.fromJson(json);

      expect(dto.fecha, '2026-07-21T00:00:00.000Z');
      expect(dto.sum.total, '12292318.84');
    });

    test('toDomain mapea al modelo de dominio ResumenDiario', () {
      final resumen = ResumenDiarioDto.fromJson(json).toDomain();

      expect(resumen.fecha, DateTime.parse('2026-07-21T00:00:00.000Z'));
      expect(resumen.total, 12292318.84);
    });
  });
}
