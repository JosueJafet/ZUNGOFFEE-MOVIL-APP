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
import 'package:zungofee_mobile/features/auth/presentation/providers/login_controller.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(super.authSessionService, {this.signInError});

  final Object? signInError;

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (signInError != null) throw signInError!;
  }
}

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeFcmService implements FcmService {
  _FakeFcmService({this.token = 'fcm-token-abc'});

  final String? token;
  int solicitarPermisoCallCount = 0;
  int obtenerTokenCallCount = 0;

  @override
  Future<bool> solicitarPermiso() async {
    solicitarPermisoCallCount++;
    return true;
  }

  @override
  Future<String?> obtenerToken() async {
    obtenerTokenCallCount++;
    return token;
  }

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
  _FakeNotificacionesRepository({this.registrarDispositivoError})
    : super(NotificacionesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? registrarDispositivoError;
  int registrarDispositivoCallCount = 0;
  String? ultimoToken;
  int? ultimaPlataformaId;

  @override
  Future<void> registrarDispositivo({
    required String token,
    required int plataformaId,
  }) async {
    registrarDispositivoCallCount++;
    ultimoToken = token;
    ultimaPlataformaId = plataformaId;
    if (registrarDispositivoError != null) throw registrarDispositivoError!;
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
          fcmServiceProvider.overrideWithValue(_FakeFcmService()),
          notificacionesRepositoryProvider.overrideWithValue(
            _FakeNotificacionesRepository(),
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
          fcmServiceProvider.overrideWithValue(_FakeFcmService()),
          notificacionesRepositoryProvider.overrideWithValue(
            _FakeNotificacionesRepository(),
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

    test(
      'signIn exitoso pide permiso y registra el token del dispositivo',
      () async {
        final fcmService = _FakeFcmService(token: 'fcm-token-xyz');
        final notificacionesRepository = _FakeNotificacionesRepository();
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(AuthSessionService(supabaseClient)),
            ),
            fcmServiceProvider.overrideWithValue(fcmService),
            notificacionesRepositoryProvider.overrideWithValue(
              notificacionesRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(loginControllerProvider.notifier)
            .signIn(email: 'user@zungocoffee.com', password: 'secret123');

        expect(fcmService.solicitarPermisoCallCount, 1);
        expect(notificacionesRepository.registrarDispositivoCallCount, 1);
        expect(notificacionesRepository.ultimoToken, 'fcm-token-xyz');
        expect(notificacionesRepository.ultimaPlataformaId, 2);
      },
    );

    test(
      'un fallo al registrar el token FCM no rompe un login exitoso '
      '(best-effort)',
      () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(AuthSessionService(supabaseClient)),
            ),
            fcmServiceProvider.overrideWithValue(_FakeFcmService()),
            notificacionesRepositoryProvider.overrideWithValue(
              _FakeNotificacionesRepository(
                registrarDispositivoError: Exception('sin red'),
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
            .signIn(email: 'user@zungocoffee.com', password: 'secret123');

        expect(states.last, const AsyncData<void>(null));
      },
    );
  });
}
