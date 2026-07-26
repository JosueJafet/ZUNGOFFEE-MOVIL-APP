import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/models/notificacion.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificacion_marcar_leida_controller.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _notificacion = Notificacion(
  id: '3',
  titulo: 'Compra registrada',
  mensaje: 'Se registró una compra de 10 quintales',
  leida: false,
);

class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository({this.marcarLeidaError})
    : super(
        NotificacionesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final Object? marcarLeidaError;
  int marcarLeidaCallCount = 0;
  int listarCallCount = 0;

  @override
  Future<void> marcarLeida(String id) async {
    marcarLeidaCallCount++;
    if (marcarLeidaError != null) throw marcarLeidaError!;
  }

  @override
  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) async {
    listarCallCount++;
    return [_notificacion];
  }
}

void main() {
  group('NotificacionMarcarLeidaController', () {
    test(
      'marcarLeida exitoso: loading -> data, e invalida '
      'notificacionesProvider',
      () async {
        final repository = _FakeNotificacionesRepository();
        final container = ProviderContainer(
          overrides: [
            notificacionesRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificacionesProvider.future);
        expect(repository.listarCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(notificacionMarcarLeidaControllerProvider, (
          previous,
          next,
        ) {
          states.add(next);
        });

        await container
            .read(notificacionMarcarLeidaControllerProvider.notifier)
            .marcarLeida('3');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.marcarLeidaCallCount, 1);

        await container.read(notificacionesProvider.future);
        expect(repository.listarCallCount, 2);
      },
    );

    test('marcarLeida con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 404,
        message: 'Notificación no encontrada',
      );
      final container = ProviderContainer(
        overrides: [
          notificacionesRepositoryProvider.overrideWithValue(
            _FakeNotificacionesRepository(marcarLeidaError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(notificacionMarcarLeidaControllerProvider, (
        previous,
        next,
      ) {
        states.add(next);
      });

      await container
          .read(notificacionMarcarLeidaControllerProvider.notifier)
          .marcarLeida('999');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
