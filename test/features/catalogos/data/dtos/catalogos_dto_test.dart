import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/catalogos/data/dtos/catalogos_dto.dart';

void main() {
  group('CatalogosDto', () {
    // JSON ASUMIDO para GET /catalogos: el usuario confirmó las 4 claves
    // (metodosPago, variedadesCafe, nivelesAltura, estadosCafe) pero no el
    // JSON textual completo. Los campos internos (msnm_min/msnm_max,
    // unidad_medida_id) se asumen snake_case, igual que el resto de las
    // respuestas de la API (fecha_creacion, unidad_medida_id ya visto en
    // GET /lotes/existencias). Si el contrato real difiere, este test y
    // los @JsonKey de CatalogosDto son el único lugar a corregir.
    final json = {
      'metodosPago': [
        {'id': 1, 'nombre': 'Efectivo'},
        {'id': 2, 'nombre': 'Transferencia'},
      ],
      'variedadesCafe': [
        {'id': 1, 'nombre': 'Catuai'},
      ],
      'nivelesAltura': [
        {'id': 1, 'nombre': 'Estandar', 'msnm_min': 800, 'msnm_max': 1200},
      ],
      'estadosCafe': [
        {'id': 1, 'nombre': 'uva', 'unidad_medida_id': 1},
        {'id': 3, 'nombre': 'pergamino_seco', 'unidad_medida_id': 2},
      ],
    };

    test('fromJson parsea los 4 catálogos', () {
      final dto = CatalogosDto.fromJson(json);

      expect(dto.metodosPago, hasLength(2));
      expect(dto.metodosPago.first.nombre, 'Efectivo');
      expect(dto.variedadesCafe, hasLength(1));
      expect(dto.variedadesCafe.first.nombre, 'Catuai');
      expect(dto.nivelesAltura, hasLength(1));
      expect(dto.nivelesAltura.first.msnmMin, 800);
      expect(dto.nivelesAltura.first.msnmMax, 1200);
      expect(dto.estadosCafe, hasLength(2));
      expect(dto.estadosCafe.first.unidadMedidaId, 1);
    });

    test('toDomain mapea al agregado de dominio Catalogos', () {
      final catalogos = CatalogosDto.fromJson(json).toDomain();

      expect(catalogos.metodosPago.map((m) => m.nombre), [
        'Efectivo',
        'Transferencia',
      ]);
      expect(catalogos.variedadesCafe.single.nombre, 'Catuai');
      expect(catalogos.nivelesAltura.single.msnmMin, 800);
      expect(catalogos.nivelesAltura.single.msnmMax, 1200);
      expect(catalogos.estadosCafe.map((e) => e.id), [1, 3]);
      expect(catalogos.estadosCafe.first.unidadMedidaId, 1);
    });

    test('msnmMin/msnmMax nulos se parsean correctamente', () {
      final jsonSinRango = {
        ...json,
        'nivelesAltura': [
          {'id': 2, 'nombre': 'Sin rango'},
        ],
      };

      final catalogos = CatalogosDto.fromJson(jsonSinRango).toDomain();

      expect(catalogos.nivelesAltura.single.msnmMin, isNull);
      expect(catalogos.nivelesAltura.single.msnmMax, isNull);
    });
  });
}
