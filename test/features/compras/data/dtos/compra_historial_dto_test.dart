import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/compras/data/dtos/compra_historial_dto.dart';

void main() {
  group('CompraHistorialDto', () {
    // JSON real de `GET /compras`, confirmado contra la API en vivo —
    // forma distinta a la de `POST /compras` (`CompraDto`): sin
    // `tenant_id`/`proveedor_id`/`usuario_id`/`anulada`, con
    // `proveedores`/`usuarios` anidados.
    final json = {
      'id': 45,
      'fecha': '2026-08-01T00:00:00.000Z',
      'total': '1200.00',
      'proveedores': {'id': 12, 'nombre': 'Don Chepe Martinez'},
      'usuarios': {'id': 3, 'nombre': 'Admin Bodega Uno'},
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = CompraHistorialDto.fromJson(json);

      expect(dto.id, 45);
      expect(dto.fecha, '2026-08-01T00:00:00.000Z');
      expect(dto.total, '1200.00');
      expect(dto.proveedores.id, 12);
      expect(dto.proveedores.nombre, 'Don Chepe Martinez');
      expect(dto.usuarios.id, 3);
      expect(dto.usuarios.nombre, 'Admin Bodega Uno');
    });

    test('toDomain mapea al modelo de dominio CompraHistorial', () {
      final compra = CompraHistorialDto.fromJson(json).toDomain();

      expect(compra.id, 45);
      expect(compra.fecha, DateTime.parse('2026-08-01T00:00:00.000Z'));
      expect(compra.total, 1200.00);
      expect(compra.proveedorNombre, 'Don Chepe Martinez');
      expect(compra.usuarioNombre, 'Admin Bodega Uno');
    });
  });
}
