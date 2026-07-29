import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/bodegas/data/dtos/bodega_dto.dart';

void main() {
  group('BodegaDto', () {
    // JSON de ejemplo de `GET /tenants` (contrato confirmado por Rubio,
    // backend).
    final json = {
      'id': 5,
      'nombre': 'Bodega de Prueba',
      'estado_id': 1,
      'fecha_registro': '2026-07-21T00:00:00.000Z',
      'estados_tenant': {'nombre': 'activo'},
    };

    test('fromJson parsea los campos del DTO (ignora estados_tenant)', () {
      final dto = BodegaDto.fromJson(json);

      expect(dto.id, 5);
      expect(dto.nombre, 'Bodega de Prueba');
      expect(dto.estadoId, 1);
      expect(dto.fechaRegistro, '2026-07-21T00:00:00.000Z');
    });

    test('toDomain mapea al modelo de dominio Bodega', () {
      final bodega = BodegaDto.fromJson(json).toDomain();

      expect(bodega.id, 5);
      expect(bodega.nombre, 'Bodega de Prueba');
      expect(bodega.estadoId, 1);
      expect(bodega.activa, isTrue);
      expect(
        bodega.fechaRegistro,
        DateTime.parse('2026-07-21T00:00:00.000Z'),
      );
    });

    test(
      'estado_id 2 (suspendido) mapea activa a false, sin estados_tenant '
      'en el JSON (shape de PATCH /tenants/:id)',
      () {
        final jsonSinEstadosTenant = {
          'id': 5,
          'nombre': 'Bodega de Prueba',
          'estado_id': 2,
          'fecha_registro': '2026-07-21T00:00:00.000Z',
        };

        final bodega = BodegaDto.fromJson(jsonSinEstadosTenant).toDomain();

        expect(bodega.activa, isFalse);
      },
    );

    test(
      'dias_restantes/estado_pago_calculado (solo en GET /tenants) se '
      'mapean cuando vienen',
      () {
        final jsonConSuscripcion = {
          ...json,
          'dias_restantes': 25,
          'estado_pago_calculado': 'pendiente',
        };

        final bodega = BodegaDto.fromJson(jsonConSuscripcion).toDomain();

        expect(bodega.diasRestantes, 25);
        expect(bodega.estadoPagoCalculado, 'pendiente');
      },
    );

    test(
      'sin dias_restantes/estado_pago_calculado en el JSON (los otros 3 '
      'shapes de este DTO no los traen) mapean a null, no revientan',
      () {
        final bodega = BodegaDto.fromJson(json).toDomain();

        expect(bodega.diasRestantes, isNull);
        expect(bodega.estadoPagoCalculado, isNull);
      },
    );
  });
}
