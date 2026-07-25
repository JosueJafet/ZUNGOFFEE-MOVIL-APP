import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/models/procesamiento.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_form_controller.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _procesamiento = Procesamiento(
  id: '9',
  tenantId: 5,
  loteOrigenId: '78',
  loteDestinoId: '80',
  cantidadEntrada: 5,
  cantidadSalida: 350,
);

class _FakeProcesamientoRepository extends ProcesamientoRepository {
  _FakeProcesamientoRepository({this.crearError})
    : super(
        ProcesamientoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final Object? crearError;
  int crearCallCount = 0;

  @override
  Future<Procesamiento> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    crearCallCount++;
    if (crearError != null) throw crearError!;
    return _procesamiento;
  }
}

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository()
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  int getExistenciasCallCount = 0;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async {
    getExistenciasCallCount++;
    return const [];
  }
}

void main() {
  group('ProcesamientoFormController', () {
    test(
      'crear exitoso: loading -> data, e invalida existenciasProvider',
      () async {
        final procesamientoRepository = _FakeProcesamientoRepository();
        final lotesRepository = _FakeLotesRepository();
        final container = ProviderContainer(
          overrides: [
            procesamientoRepositoryProvider.overrideWithValue(
              procesamientoRepository,
            ),
            lotesRepositoryProvider.overrideWithValue(lotesRepository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(procesamientoFormControllerProvider, (
          previous,
          next,
        ) {
          states.add(next);
        });

        await container
            .read(procesamientoFormControllerProvider.notifier)
            .crear(
              loteOrigenId: '78',
              estadoDestinoId: 5,
              cantidadEntrada: 5,
              cantidadSalida: 350,
            );

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(procesamientoRepository.crearCallCount, 1);

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 2);
      },
    );

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'Transición de estado no permitida para este lote',
      );
      final container = ProviderContainer(
        overrides: [
          procesamientoRepositoryProvider.overrideWithValue(
            _FakeProcesamientoRepository(crearError: error),
          ),
          lotesRepositoryProvider.overrideWithValue(_FakeLotesRepository()),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(procesamientoFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(procesamientoFormControllerProvider.notifier)
          .crear(
            loteOrigenId: '78',
            estadoDestinoId: 7,
            cantidadEntrada: 5,
            cantidadSalida: 350,
          );

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
