import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/procesamiento/data/dtos/procesamiento_dto.dart';

void main() {
  group('ProcesamientoDto', () {
    // JSON de ejemplo de `POST /procesamiento` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.6). Sin `anulada` — el ejemplo del contrato no la incluye,
    // a diferencia de CompraDto/VentaDto.
    final json = {
      'id': '9',
      'tenant_id': 5,
      'lote_origen_id': '78',
      'lote_destino_id': '80',
      'cantidad_entrada': '5.00',
      'cantidad_salida': '350.00',
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = ProcesamientoDto.fromJson(json);

      expect(dto.id, '9');
      expect(dto.tenantId, 5);
      expect(dto.loteOrigenId, '78');
      expect(dto.loteDestinoId, '80');
      expect(dto.cantidadEntrada, '5.00');
      expect(dto.cantidadSalida, '350.00');
    });

    test('toDomain mapea al modelo de dominio Procesamiento', () {
      final procesamiento = ProcesamientoDto.fromJson(json).toDomain();

      expect(procesamiento.id, '9');
      expect(procesamiento.tenantId, 5);
      expect(procesamiento.loteOrigenId, '78');
      expect(procesamiento.loteDestinoId, '80');
      expect(procesamiento.cantidadEntrada, 5.0);
      expect(procesamiento.cantidadSalida, 350.0);
    });
  });
}
