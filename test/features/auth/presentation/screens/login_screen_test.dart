import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/screens/login_screen.dart';

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(super.authSessionService, {this.signInError});

  final Object? signInError;
  int signInCallCount = 0;

  @override
  Future<void> signIn({required String email, required String password}) async {
    signInCallCount++;
    if (signInError != null) throw signInError!;
  }
}

Widget _wrap(AuthRepository authRepository) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
    child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
  );
}

void main() {
  group('LoginScreen', () {
    late SupabaseClient supabaseClient;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets('credenciales válidas: dispara el submit sin mostrar error', (
      tester,
    ) async {
      final authRepository = _FakeAuthRepository(
        AuthSessionService(supabaseClient),
      );

      await tester.pumpWidget(_wrap(authRepository));

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@zungocoffee.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'secret123');
      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await tester.pumpAndSettle();

      expect(authRepository.signInCallCount, 1);
      expect(find.text('Credenciales inválidas'), findsNothing);
    });

    testWidgets(
      'credenciales inválidas: muestra el mensaje de error de la API',
      (tester) async {
        const error = ApiException(
          statusCode: 400,
          message: 'Credenciales inválidas',
        );
        final authRepository = _FakeAuthRepository(
          AuthSessionService(supabaseClient),
          signInError: error,
        );

        await tester.pumpWidget(_wrap(authRepository));

        await tester.enterText(
          find.byType(TextFormField).first,
          'user@zungocoffee.com',
        );
        await tester.enterText(find.byType(TextFormField).last, 'wrong');
        await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
        await tester.pumpAndSettle();

        expect(find.text('Credenciales inválidas'), findsOneWidget);
      },
    );

    testWidgets('no envía el submit si los campos están vacíos', (
      tester,
    ) async {
      final authRepository = _FakeAuthRepository(
        AuthSessionService(supabaseClient),
      );

      await tester.pumpWidget(_wrap(authRepository));

      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await tester.pumpAndSettle();

      expect(authRepository.signInCallCount, 0);
      expect(find.text('Ingresa tu correo'), findsOneWidget);
      expect(find.text('Ingresa tu contraseña'), findsOneWidget);
    });
  });
}
