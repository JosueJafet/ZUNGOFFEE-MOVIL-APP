import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_estado_controller.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository({this.suspenderError, this.activarError})
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? suspenderError;
  final Object? activarError;
  int suspenderCallCount = 0;
  int activarCallCount = 0;
  int getBodegasCallCount = 0;

  @override
  Future<List<Bodega>> getBodegas() async {
    getBodegasCallCount++;
    return [_bodega];
  }

  @override
  Future<void> suspender(int id) async {
    suspenderCallCount++;
    if (suspenderError != null) throw suspenderError!;
  }

  @override
  Future<void> activar(int id) async {
    activarCallCount++;
    if (activarError != null) throw activarError!;
  }
}

void main() {
  group('BodegaEstadoController', () {
    test('suspender exitoso: loading -> data, e invalida bodegasProvider', () async {
      final repository = _FakeBodegaRepository();
      final container = ProviderContainer(
        overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 1);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaEstadoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(bodegaEstadoControllerProvider.notifier).suspender(5);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(repository.suspenderCallCount, 1);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 2);
    });

    test('suspender con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          bodegaRepositoryProvider.overrideWithValue(
            _FakeBodegaRepository(suspenderError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaEstadoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(bodegaEstadoControllerProvider.notifier).suspender(5);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });

    test('activar exitoso: loading -> data, e invalida bodegasProvider', () async {
      final repository = _FakeBodegaRepository();
      final container = ProviderContainer(
        overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 1);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaEstadoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(bodegaEstadoControllerProvider.notifier).activar(5);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(repository.activarCallCount, 1);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 2);
    });

    test('activar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          bodegaRepositoryProvider.overrideWithValue(
            _FakeBodegaRepository(activarError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaEstadoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(bodegaEstadoControllerProvider.notifier).activar(5);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
