import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/router/app_router.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';

void main() {
  group('AppRouter (sin sesión activa)', () {
    // `SupabaseClient` se construye directamente (sin `Supabase.initialize`)
    // para no depender de almacenamiento de plataforma en el test: no hay
    // sesión persistida, por lo que `currentSession` es `null` desde el
    // arranque — exactamente el escenario "sin sesión" que necesita este
    // test. El caso "con sesión" se verifica a nivel de lógica pura en
    // `auth_redirect_test.dart`, ya que simular un login real de Supabase
    // requeriría responder sus llamadas HTTP internas.
    late AuthSessionService authSessionService;

    setUp(() {
      authSessionService = AuthSessionService(
        SupabaseClient('https://example.test', 'test-anon-key'),
      );
    });

    testWidgets('redirige de splash a login al arrancar', (tester) async {
      final router = AppRouter.build(authSessionService);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Login placeholder'), findsOneWidget);
    });

    testWidgets('bloquea la navegación directa a home y redirige a login', (
      tester,
    ) async {
      final router = AppRouter.build(authSessionService);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      router.go('/home');
      await tester.pumpAndSettle();

      expect(find.text('Login placeholder'), findsOneWidget);
      expect(find.text('Home placeholder'), findsNothing);
    });
  });
}
