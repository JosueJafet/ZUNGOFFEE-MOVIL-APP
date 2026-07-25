import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/clientes/data/dtos/cliente_dto.dart';

void main() {
  group('ClienteDto', () {
    // JSON de ejemplo de `POST /clientes` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.2b).
    final json = {
      'id': 1,
      'tenant_id': 5,
      'nombre': 'Cafeteria El Buen Cafe',
      'tipo_id': 2,
      'lugar': 'Tegucigalpa',
      'telefono': null,
      'estado': true,
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = ClienteDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.tenantId, 5);
      expect(dto.nombre, 'Cafeteria El Buen Cafe');
      expect(dto.tipoId, 2);
      expect(dto.lugar, 'Tegucigalpa');
      expect(dto.telefono, isNull);
      expect(dto.estado, true);
    });

    test('toDomain mapea al modelo de dominio Cliente', () {
      final cliente = ClienteDto.fromJson(json).toDomain();

      expect(cliente.id, 1);
      expect(cliente.tenantId, 5);
      expect(cliente.nombre, 'Cafeteria El Buen Cafe');
      expect(cliente.tipoId, 2);
      expect(cliente.lugar, 'Tegucigalpa');
      expect(cliente.telefono, isNull);
      expect(cliente.estado, true);
    });

    test('campos opcionales nulos se parsean correctamente', () {
      final jsonSinOpcionales = {
        'id': 2,
        'tenant_id': 5,
        'nombre': 'Cliente Sin Datos',
        'tipo_id': null,
        'lugar': null,
        'telefono': null,
        'estado': true,
      };

      final cliente = ClienteDto.fromJson(jsonSinOpcionales).toDomain();

      expect(cliente.nombre, 'Cliente Sin Datos');
      expect(cliente.tipoId, isNull);
      expect(cliente.lugar, isNull);
      expect(cliente.telefono, isNull);
    });
  });
}