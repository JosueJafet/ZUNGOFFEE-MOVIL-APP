import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/pagos/data/dtos/pago_dto.dart';

void main() {
  group('PagoDto', () {
    // JSON de ejemplo de `GET /pagos/tenant/:tenantId` (contrato
    // confirmado por Rubio, backend).
    final json = {
      'id': 1,
      'tenant_id': 5,
      'periodo': '2026-08-01T00:00:00.000Z',
      'monto': '500',
      'fecha_vencimiento': '2026-08-31T00:00:00.000Z',
      'fecha_pago': '2026-07-23T17:58:13.123Z',
      'estado_pago_id': 2,
      'registrado_por': 8,
      'estado_calculado': 'pagado',
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = PagoDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.tenantId, 5);
      expect(dto.periodo, '2026-08-01T00:00:00.000Z');
      expect(dto.monto, '500');
      expect(dto.fechaVencimiento, '2026-08-31T00:00:00.000Z');
      expect(dto.fechaPago, '2026-07-23T17:58:13.123Z');
      expect(dto.estadoPagoId, 2);
      expect(dto.registradoPor, 8);
      expect(dto.estadoCalculado, 'pagado');
    });

    test('toDomain mapea al modelo de dominio Pago', () {
      final pago = PagoDto.fromJson(json).toDomain();

      expect(pago.id, 1);
      expect(pago.tenantId, 5);
      expect(pago.periodo, DateTime.parse('2026-08-01T00:00:00.000Z'));
      expect(pago.monto, 500.0);
      expect(
        pago.fechaVencimiento,
        DateTime.parse('2026-08-31T00:00:00.000Z'),
      );
      expect(pago.fechaPago, DateTime.parse('2026-07-23T17:58:13.123Z'));
      expect(pago.estadoPagoId, 2);
      expect(pago.registradoPor, 8);
      expect(pago.estadoCalculado, 'pagado');
    });

    test('fecha_pago nulo (pago pendiente) no rompe el parseo', () {
      final jsonPendiente = {
        ...json,
        'fecha_pago': null,
        'estado_pago_id': 1,
        'estado_calculado': 'pendiente',
      };

      final pago = PagoDto.fromJson(jsonPendiente).toDomain();

      expect(pago.fechaPago, isNull);
      expect(pago.estadoCalculado, 'pendiente');
    });
  });
}
