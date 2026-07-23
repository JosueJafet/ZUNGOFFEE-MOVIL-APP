import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/proveedores/data/dtos/proveedor_dto.dart';

void main() {
  group('ProveedorDto', () {
    // JSON de ejemplo de `POST /proveedores` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.2).
    final json = {
      'id': 12,
      'tenant_id': 5,
      'nombre': 'Don Chepe Martinez',
      'sexo': 'M',
      'lugar': 'Marcala',
      'finca': 'Finca El Roble',
      'tipo_id': 1,
      'telefono': '9999-9999',
      'estado': true,
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = ProveedorDto.fromJson(json);

      expect(dto.id, 12);
      expect(dto.tenantId, 5);
      expect(dto.nombre, 'Don Chepe Martinez');
      expect(dto.sexo, 'M');
      expect(dto.lugar, 'Marcala');
      expect(dto.finca, 'Finca El Roble');
      expect(dto.tipoId, 1);
      expect(dto.telefono, '9999-9999');
      expect(dto.estado, true);
    });

    test('toDomain mapea al modelo de dominio Proveedor', () {
      final proveedor = ProveedorDto.fromJson(json).toDomain();

      expect(proveedor.id, 12);
      expect(proveedor.tenantId, 5);
      expect(proveedor.nombre, 'Don Chepe Martinez');
      expect(proveedor.sexo, 'M');
      expect(proveedor.lugar, 'Marcala');
      expect(proveedor.finca, 'Finca El Roble');
      expect(proveedor.tipoId, 1);
      expect(proveedor.telefono, '9999-9999');
      expect(proveedor.estado, true);
    });

    test('campos opcionales nulos se parsean correctamente', () {
      final jsonSinOpcionales = {
        'id': 13,
        'tenant_id': 5,
        'nombre': 'Proveedor Sin Datos',
        'sexo': null,
        'lugar': null,
        'finca': null,
        'tipo_id': null,
        'telefono': null,
        'estado': true,
      };

      final proveedor = ProveedorDto.fromJson(jsonSinOpcionales).toDomain();

      expect(proveedor.nombre, 'Proveedor Sin Datos');
      expect(proveedor.sexo, isNull);
      expect(proveedor.lugar, isNull);
      expect(proveedor.finca, isNull);
      expect(proveedor.tipoId, isNull);
      expect(proveedor.telefono, isNull);
    });
  });
}
