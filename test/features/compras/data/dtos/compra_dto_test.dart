import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/compras/data/dtos/compra_dto.dart';

void main() {
  group('CompraDto', () {
    // JSON de ejemplo de `POST /compras` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.3).
    final json = {
      'id': 45,
      'tenant_id': 5,
      'proveedor_id': 12,
      'usuario_id': 3,
      'fecha': '2026-08-01T00:00:00.000Z',
      'total': '1200.00',
      'anulada': false,
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = CompraDto.fromJson(json);

      expect(dto.id, 45);
      expect(dto.tenantId, 5);
      expect(dto.proveedorId, 12);
      expect(dto.usuarioId, 3);
      expect(dto.fecha, '2026-08-01T00:00:00.000Z');
      expect(dto.total, '1200.00');
      expect(dto.anulada, false);
    });

    test('toDomain mapea al modelo de dominio Compra', () {
      final compra = CompraDto.fromJson(json).toDomain();

      expect(compra.id, 45);
      expect(compra.tenantId, 5);
      expect(compra.proveedorId, 12);
      expect(compra.usuarioId, 3);
      expect(compra.fecha, DateTime.parse('2026-08-01T00:00:00.000Z'));
      expect(compra.total, 1200.00);
      expect(compra.anulada, false);
    });
  });
}
