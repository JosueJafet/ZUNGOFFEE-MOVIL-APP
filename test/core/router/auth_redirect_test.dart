import 'package:flutter_test/flutter_test.dart';

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
  });
}
