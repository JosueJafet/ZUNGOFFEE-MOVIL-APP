import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/constants/app_role.dart';
import 'package:zungofee_mobile/features/auth/data/dtos/perfil_dto.dart';

void main() {
  group('PerfilDto', () {
    // JSON de ejemplo de `GET /perfil` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.8).
    final json = {
      'id': 7,
      'nombre': 'Juan Pérez',
      'estado': true,
      'fecha_creacion': '2026-01-15T10:30:00.000Z',
      'roles': {'nombre': AppRole.empleado},
      'tenants': {'id': 3, 'nombre': 'Bodega Central'},
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = PerfilDto.fromJson(json);

      expect(dto.id, 7);
      expect(dto.nombre, 'Juan Pérez');
      expect(dto.estado, true);
      expect(dto.fechaCreacion, '2026-01-15T10:30:00.000Z');
      expect(dto.roles.nombre, AppRole.empleado);
      expect(dto.tenants.id, 3);
      expect(dto.tenants.nombre, 'Bodega Central');
    });

    test('toDomain mapea al modelo de dominio Perfil', () {
      final perfil = PerfilDto.fromJson(json).toDomain();

      expect(perfil.id, 7);
      expect(perfil.nombre, 'Juan Pérez');
      expect(perfil.activo, true);
      expect(perfil.fechaCreacion, DateTime.parse('2026-01-15T10:30:00.000Z'));
      expect(perfil.rol, AppRole.empleado);
      expect(perfil.tenantId, 3);
      expect(perfil.tenantNombre, 'Bodega Central');
    });
  });
}
