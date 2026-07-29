import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/constants/app_role.dart';

void main() {
  group('AppRole.etiquetaDe', () {
    test('super_admin -> "Super admin"', () {
      expect(AppRole.etiquetaDe(AppRole.superAdmin), 'Super admin');
    });

    test('admin_bodega -> "Administrador"', () {
      expect(AppRole.etiquetaDe(AppRole.adminBodega), 'Administrador');
    });

    test('empleado -> "Empleado"', () {
      expect(AppRole.etiquetaDe(AppRole.empleado), 'Empleado');
    });

    test('un rol desconocido cae al valor crudo, no revienta', () {
      expect(AppRole.etiquetaDe('rol_futuro'), 'rol_futuro');
    });
  });
}
