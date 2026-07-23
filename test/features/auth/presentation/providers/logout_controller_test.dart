import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/logout_controller.dart';

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(super.authSessionService, {this.signOutError});

  final Object? signOutError;
  int signOutCallCount = 0;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    if (signOutError != null) throw signOutError!;
  }
}

void main() {
  group('LogoutController', () {
    late SupabaseClient supabaseClient;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
    });

    tearDown(() => supabaseClient.dispose());

    test('signOut exitoso: loading -> data', () async {
      final authRepository = _FakeAuthRepository(
        AuthSessionService(supabaseClient),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(logoutControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(logoutControllerProvider.notifier).signOut();

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(authRepository.signOutCallCount, 1);
    });

    test('signOut con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 500,
        message: 'Error al cerrar sesión',
      );
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(
              AuthSessionService(supabaseClient),
              signOutError: error,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(logoutControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(logoutControllerProvider.notifier).signOut();

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
