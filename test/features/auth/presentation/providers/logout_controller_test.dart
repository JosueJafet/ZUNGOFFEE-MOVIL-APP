import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/services/fcm_providers.dart';
import 'package:zungofee_mobile/core/services/fcm_service.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/logout_controller.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';

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

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeFcmService implements FcmService {
  _FakeFcmService({this.token = 'fcm-token-abc'});

  final String? token;

  @override
  Future<bool> solicitarPermiso() async => true;

  @override
  Future<String?> obtenerToken() async => token;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMensajeEnPrimerPlano => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMensajeAbrioApp => const Stream.empty();

  @override
  Future<RemoteMessage?> obtenerMensajeInicial() async => null;
}

class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository({
    this.desregistrarDispositivoError,
    this.onDesregistrarDispositivo,
  }) : super(NotificacionesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? desregistrarDispositivoError;
  final void Function()? onDesregistrarDispositivo;
  int desregistrarDispositivoCallCount = 0;
  String? ultimoToken;

  @override
  Future<void> desregistrarDispositivo(String token) async {
    desregistrarDispositivoCallCount++;
    ultimoToken = token;
    onDesregistrarDispositivo?.call();
    if (desregistrarDispositivoError != null) throw desregistrarDispositivoError!;
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
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          fcmServiceProvider.overrideWithValue(_FakeFcmService()),
          notificacionesRepositoryProvider.overrideWithValue(
            _FakeNotificacionesRepository(),
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
          fcmServiceProvider.overrideWithValue(_FakeFcmService()),
          notificacionesRepositoryProvider.overrideWithValue(
            _FakeNotificacionesRepository(),
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

    test(
      'signOut exitoso desregistra el token del dispositivo antes de '
      'cerrar sesión',
      () async {
        final authRepository = _FakeAuthRepository(
          AuthSessionService(supabaseClient),
        );
        final orden = <String>[];
        final notificacionesRepository = _FakeNotificacionesRepository(
          onDesregistrarDispositivo: () => orden.add('desregistrar'),
        );
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            fcmServiceProvider.overrideWithValue(
              _FakeFcmService(token: 'fcm-token-xyz'),
            ),
            notificacionesRepositoryProvider.overrideWithValue(
              notificacionesRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        await container.read(logoutControllerProvider.notifier).signOut();

        expect(notificacionesRepository.desregistrarDispositivoCallCount, 1);
        expect(notificacionesRepository.ultimoToken, 'fcm-token-xyz');
        expect(authRepository.signOutCallCount, 1);
      },
    );

    test(
      'un fallo al desregistrar el token FCM no rompe un logout exitoso '
      '(best-effort)',
      () async {
        final authRepository = _FakeAuthRepository(
          AuthSessionService(supabaseClient),
        );
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            fcmServiceProvider.overrideWithValue(_FakeFcmService()),
            notificacionesRepositoryProvider.overrideWithValue(
              _FakeNotificacionesRepository(
                desregistrarDispositivoError: Exception('sin red'),
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

        expect(states.last, const AsyncData<void>(null));
        expect(authRepository.signOutCallCount, 1);
      },
    );
  });
}
