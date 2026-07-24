import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/inventario/data/dtos/lote_dto.dart';

void main() {
  group('LoteDto', () {
    // JSON de ejemplo de `GET /lotes/existencias` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.4).
    final json = {
      'id': '78',
      'saldo': '10.00',
      'cantidad_inicial': '10.00',
      'estados_cafe': {'nombre': 'pergamino_seco', 'unidad_medida_id': 2},
      'variedades_cafe': {'nombre': 'Catuai'},
      'niveles_altura': {'nombre': 'Estandar'},
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = LoteDto.fromJson(json);

      expect(dto.id, '78');
      expect(dto.saldo, '10.00');
      expect(dto.cantidadInicial, '10.00');
      expect(dto.estadosCafe.nombre, 'pergamino_seco');
      expect(dto.estadosCafe.unidadMedidaId, 2);
      expect(dto.variedadesCafe.nombre, 'Catuai');
      expect(dto.nivelesAltura.nombre, 'Estandar');
    });

    test('toDomain mapea al modelo de dominio Lote, aplanado', () {
      final lote = LoteDto.fromJson(json).toDomain();

      expect(lote.id, '78');
      expect(lote.saldo, 10.00);
      expect(lote.cantidadInicial, 10.00);
      expect(lote.estadoCafeNombre, 'pergamino_seco');
      expect(lote.unidadMedidaId, 2);
      expect(lote.variedadNombre, 'Catuai');
      expect(lote.nivelAlturaNombre, 'Estandar');
    });
  });
}
