import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/constants/app_role.dart';
import 'package:zungofee_mobile/core/router/auth_redirect.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';

void main() {
  group('AuthRedirect.resolve', () {
    test('sin sesión y va a una ruta protegida -> redirige a login', () {
      final result = AuthRedirect.resolve(
        isAuthenticated: false,
        location: RoutePaths.home,
      );
      expect(result, RoutePaths.login);
    });

    test('sin sesión y en el splash -> redirige a login', () {
      final result = AuthRedirect.resolve(
        isAuthenticated: false,
        location: RoutePaths.splash,
      );
      expect(result, RoutePaths.login);
    });

    test(
      'con sesión (ya persistida, ej. reabrir la app) y en el splash -> '
      'redirige a home, no se queda atascado ahí',
      () {
        final result = AuthRedirect.resolve(
          isAuthenticated: true,
          location: RoutePaths.splash,
        );
        expect(result, RoutePaths.home);
      },
    );

    test('sin sesión y ya va a login -> no redirige', () {
      final result = AuthRedirect.resolve(
        isAuthenticated: false,
        location: RoutePaths.login,
      );
      expect(result, isNull);
    });

    test('con sesión (simulada) y va a login -> redirige a home', () {
      final result = AuthRedirect.resolve(
        isAuthenticated: true,
        location: RoutePaths.login,
      );
      expect(result, RoutePaths.home);
    });

    test('con sesión (simulada) y va a una ruta protegida -> no redirige', () {
      final result = AuthRedirect.resolve(
        isAuthenticated: true,
        location: RoutePaths.home,
      );
      expect(result, isNull);
    });

    test(
      'super_admin yendo a una ruta operativa (existencias) -> redirige '
      'a home',
      () {
        final result = AuthRedirect.resolve(
          isAuthenticated: true,
          location: RoutePaths.existencias,
          rol: AppRole.superAdmin,
        );
        expect(result, RoutePaths.home);
      },
    );

    test(
      'admin_bodega yendo a una ruta de administración (bodegas) -> '
      'redirige a home',
      () {
        final result = AuthRedirect.resolve(
          isAuthenticated: true,
          location: RoutePaths.bodegas,
          rol: AppRole.adminBodega,
        );
        expect(result, RoutePaths.home);
      },
    );

    test(
      'empleado yendo a una ruta de administración (solicitudes/pagos) -> '
      'redirige a home',
      () {
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.solicitudes,
            rol: AppRole.empleado,
          ),
          RoutePaths.home,
        );
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.pagos,
            rol: AppRole.empleado,
          ),
          RoutePaths.home,
        );
      },
    );

    test(
      'super_admin yendo a una ruta de administración (bodegas) -> no '
      'redirige',
      () {
        final result = AuthRedirect.resolve(
          isAuthenticated: true,
          location: RoutePaths.bodegas,
          rol: AppRole.superAdmin,
        );
        expect(result, isNull);
      },
    );

    test(
      'admin_bodega/empleado yendo a una ruta operativa (existencias) -> '
      'no redirige',
      () {
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.existencias,
            rol: AppRole.adminBodega,
          ),
          isNull,
        );
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.existencias,
            rol: AppRole.empleado,
          ),
          isNull,
        );
      },
    );

    test(
      'super_admin yendo a notificaciones/perfilEditar -> no redirige '
      '(los 3 roles las ven)',
      () {
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.notificaciones,
            rol: AppRole.superAdmin,
          ),
          isNull,
        );
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.perfilEditar,
            rol: AppRole.superAdmin,
          ),
          isNull,
        );
      },
    );

    test(
      'rol nulo (perfil aún no cargó) no bloquea ninguna ruta',
      () {
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.bodegas,
          ),
          isNull,
        );
        expect(
          AuthRedirect.resolve(
            isAuthenticated: true,
            location: RoutePaths.existencias,
          ),
          isNull,
        );
      },
    );
  });
}
