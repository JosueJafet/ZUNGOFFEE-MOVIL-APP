import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/models/compra_historial.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compra_anular_controller.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _compra = CompraHistorial(
  id: 45,
  fecha: DateTime.parse('2026-08-01T00:00:00.000Z'),
  total: 1200,
  proveedorNombre: 'Don Chepe Martinez',
  usuarioNombre: 'Admin Bodega Uno',
);

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository({this.anularError})
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? anularError;
  int anularCallCount = 0;
  int listarCallCount = 0;

  @override
  Future<void> anular(int id) async {
    anularCallCount++;
    if (anularError != null) throw anularError!;
  }

  @override
  Future<List<CompraHistorial>> listar({
    int page = 1,
    int pageSize = 20,
  }) async {
    listarCallCount++;
    return [_compra];
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
  group('ComprasAnularController', () {
    test(
      'anular exitoso: loading -> data, e invalida comprasHistorialProvider '
      'y existenciasProvider',
      () async {
        final comprasRepository = _FakeComprasRepository();
        final lotesRepository = _FakeLotesRepository();
        final container = ProviderContainer(
          overrides: [
            comprasRepositoryProvider.overrideWithValue(comprasRepository),
            lotesRepositoryProvider.overrideWithValue(lotesRepository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(comprasHistorialProvider.future);
        await container.read(existenciasProvider.future);
        expect(comprasRepository.listarCallCount, 1);
        expect(lotesRepository.getExistenciasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(comprasAnularControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(comprasAnularControllerProvider.notifier)
            .anular(45);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(comprasRepository.anularCallCount, 1);

        await container.read(comprasHistorialProvider.future);
        await container.read(existenciasProvider.future);
        expect(comprasRepository.listarCallCount, 2);
        expect(lotesRepository.getExistenciasCallCount, 2);
      },
    );

    test('anular con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'Algún lote ya se movió',
      );
      final container = ProviderContainer(
        overrides: [
          comprasRepositoryProvider.overrideWithValue(
            _FakeComprasRepository(anularError: error),
          ),
          lotesRepositoryProvider.overrideWithValue(_FakeLotesRepository()),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(comprasAnularControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(comprasAnularControllerProvider.notifier)
          .anular(45);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
