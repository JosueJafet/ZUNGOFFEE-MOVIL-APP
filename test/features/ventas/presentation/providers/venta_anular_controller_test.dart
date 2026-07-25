import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/models/venta.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/venta_anular_controller.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/ventas_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _venta = Venta(
  id: 30,
  tenantId: 5,
  clienteId: 7,
  usuarioId: 3,
  total: 750,
  anulada: false,
);

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository({this.anularError})
    : super(VentasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? anularError;
  int anularCallCount = 0;
  int listarCallCount = 0;

  @override
  Future<void> anular(int id) async {
    anularCallCount++;
    if (anularError != null) throw anularError!;
  }

  @override
  Future<List<Venta>> listar({int page = 1, int pageSize = 20}) async {
    listarCallCount++;
    return [_venta];
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
  group('VentasAnularController', () {
    test(
      'anular exitoso: loading -> data, e invalida ventasHistorialProvider '
      'y existenciasProvider',
      () async {
        final ventasRepository = _FakeVentasRepository();
        final lotesRepository = _FakeLotesRepository();
        final container = ProviderContainer(
          overrides: [
            ventasRepositoryProvider.overrideWithValue(ventasRepository),
            lotesRepositoryProvider.overrideWithValue(lotesRepository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(ventasHistorialProvider.future);
        await container.read(existenciasProvider.future);
        expect(ventasRepository.listarCallCount, 1);
        expect(lotesRepository.getExistenciasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(ventasAnularControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(ventasAnularControllerProvider.notifier)
            .anular(30);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(ventasRepository.anularCallCount, 1);

        await container.read(ventasHistorialProvider.future);
        await container.read(existenciasProvider.future);
        expect(ventasRepository.listarCallCount, 2);
        expect(lotesRepository.getExistenciasCallCount, 2);
      },
    );

    test('anular con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'La venta ya estaba anulada',
      );
      final container = ProviderContainer(
        overrides: [
          ventasRepositoryProvider.overrideWithValue(
            _FakeVentasRepository(anularError: error),
          ),
          lotesRepositoryProvider.overrideWithValue(_FakeLotesRepository()),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(ventasAnularControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(ventasAnularControllerProvider.notifier)
          .anular(30);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
