import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/login_controller.dart';

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(super.authSessionService, {this.signInError});

  final Object? signInError;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (signInError != null) throw signInError!;
  }
}

void main() {
  group('LoginController', () {
    late SupabaseClient supabaseClient;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
    });

    tearDown(() => supabaseClient.dispose());

    test('signIn exitoso: loading -> data', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(AuthSessionService(supabaseClient)),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(loginControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(loginControllerProvider.notifier)
          .signIn(email: 'user@zungocoffee.com', password: 'secret123');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
    });

    test('signIn con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'Credenciales inválidas',
      );
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              AuthSessionService(supabaseClient),
              signInError: error,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(loginControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(loginControllerProvider.notifier)
          .signIn(email: 'user@zungocoffee.com', password: 'wrong');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
