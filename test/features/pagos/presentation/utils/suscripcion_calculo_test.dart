import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/presentation/utils/suscripcion_calculo.dart';

Pago _pago({
  required DateTime fechaVencimiento,
  required String estadoCalculado,
}) {
  return Pago(
    id: 1,
    tenantId: 9,
    periodo: DateTime.utc(2026, 7, 1),
    monto: 500,
    fechaVencimiento: fechaVencimiento,
    estadoPagoId: 1,
    registradoPor: 1,
    estadoCalculado: estadoCalculado,
  );
}

void main() {
  group('calcularSuscripcion', () {
    test('sin pagos: devuelve null ("Sin ciclo de pago registrado")', () {
      expect(calcularSuscripcion(const []), isNull);
    });

    test('un solo ciclo: calcula los días restantes contra la fecha dada', () {
      final info = calcularSuscripcion(
        [
          _pago(
            fechaVencimiento: DateTime.utc(2026, 8, 10),
            estadoCalculado: 'pendiente',
          ),
        ],
        ahora: DateTime.utc(2026, 8, 1),
      );

      expect(info, isNotNull);
      expect(info!.estado, 'pendiente');
      expect(info.diasRestantes, 9);
    });

    test(
      'varios ciclos: usa el de fechaVencimiento más lejana (el vigente)',
      () {
        final info = calcularSuscripcion(
          [
            _pago(
              fechaVencimiento: DateTime.utc(2026, 7, 1),
              estadoCalculado: 'pagado',
            ),
            _pago(
              fechaVencimiento: DateTime.utc(2026, 9, 1),
              estadoCalculado: 'pendiente',
            ),
            _pago(
              fechaVencimiento: DateTime.utc(2026, 8, 1),
              estadoCalculado: 'pagado',
            ),
          ],
          ahora: DateTime.utc(2026, 8, 15),
        );

        expect(info!.estado, 'pendiente');
        expect(info.diasRestantes, 17);
      },
    );

    test('ciclo ya vencido: los días restantes son negativos', () {
      final info = calcularSuscripcion(
        [
          _pago(
            fechaVencimiento: DateTime.utc(2026, 8, 1),
            estadoCalculado: 'vencido',
          ),
        ],
        ahora: DateTime.utc(2026, 8, 10),
      );

      expect(info!.diasRestantes, -9);
    });

    test(
      'no depende de la hora del día, solo de la fecha calendario '
      '(evita el corrimiento de un día por zona horaria)',
      () {
        final info = calcularSuscripcion(
          [
            _pago(
              fechaVencimiento: DateTime.utc(2026, 8, 10, 23, 59),
              estadoCalculado: 'pendiente',
            ),
          ],
          ahora: DateTime.utc(2026, 8, 1, 0, 1),
        );

        expect(info!.diasRestantes, 9);
      },
    );
  });
}
