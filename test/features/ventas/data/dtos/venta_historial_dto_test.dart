import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/ventas/data/dtos/venta_historial_dto.dart';

void main() {
  group('VentaHistorialDto', () {
    // JSON real de `GET /ventas`, confirmado contra la API en vivo —
    // forma distinta a la de `POST /ventas` (`VentaDto`): sin
    // `tenant_id`/`cliente_id`/`usuario_id`/`anulada`, con `clientes`
    // anidado, y con `fecha` (que la respuesta de creación no tiene).
    final json = {
      'id': 30,
      'fecha': '2026-08-01T00:00:00.000Z',
      'total': '750.00',
      'clientes': {'id': 7, 'nombre': 'Cafeteria El Buen Cafe'},
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = VentaHistorialDto.fromJson(json);

      expect(dto.id, 30);
      expect(dto.fecha, '2026-08-01T00:00:00.000Z');
      expect(dto.total, '750.00');
      expect(dto.clientes.id, 7);
      expect(dto.clientes.nombre, 'Cafeteria El Buen Cafe');
    });

    test('toDomain mapea al modelo de dominio VentaHistorial', () {
      final venta = VentaHistorialDto.fromJson(json).toDomain();

      expect(venta.id, 30);
      expect(venta.fecha, DateTime.parse('2026-08-01T00:00:00.000Z'));
      expect(venta.total, 750.00);
      expect(venta.clienteNombre, 'Cafeteria El Buen Cafe');
    });
  });
}
