import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/ventas/data/dtos/venta_dto.dart';

void main() {
  group('VentaDto', () {
    // JSON de ejemplo de `POST /ventas` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.5). Sin `fecha`, a diferencia de `CompraDto`.
    final json = {
      'id': 30,
      'tenant_id': 5,
      'cliente_id': 7,
      'usuario_id': 3,
      'total': '750.00',
      'anulada': false,
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = VentaDto.fromJson(json);

      expect(dto.id, 30);
      expect(dto.tenantId, 5);
      expect(dto.clienteId, 7);
      expect(dto.usuarioId, 3);
      expect(dto.total, '750.00');
      expect(dto.anulada, false);
    });

    test('toDomain mapea al modelo de dominio Venta', () {
      final venta = VentaDto.fromJson(json).toDomain();

      expect(venta.id, 30);
      expect(venta.tenantId, 5);
      expect(venta.clienteId, 7);
      expect(venta.usuarioId, 3);
      expect(venta.total, 750.00);
      expect(venta.anulada, false);
    });
  });
}