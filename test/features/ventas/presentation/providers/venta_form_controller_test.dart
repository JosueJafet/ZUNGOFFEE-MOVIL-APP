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
import 'package:zungofee_mobile/features/ventas/presentation/providers/venta_form_controller.dart';
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

const _lineaDeEjemplo = LineaVentaInput(
  loteId: '78',
  cantidad: 5,
  precioUnitario: 150,
);

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository({this.crearError})
    : super(VentasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  int crearCallCount = 0;

  @override
  Future<Venta> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    crearCallCount++;
    if (crearError != null) throw crearError!;
    return _venta;
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
  group('VentaFormController', () {
    test(
      'crear exitoso: loading -> data, e invalida existenciasProvider',
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

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(ventaFormControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(ventaFormControllerProvider.notifier)
            .crear(clienteId: 7, metodoPagoId: 1, lineas: const [_lineaDeEjemplo]);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(ventasRepository.crearCallCount, 1);

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 2);
      },
    );

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'Saldo insuficiente en lote 78',
      );
      final container = ProviderContainer(
        overrides: [
          ventasRepositoryProvider.overrideWithValue(
            _FakeVentasRepository(crearError: error),
          ),
          lotesRepositoryProvider.overrideWithValue(_FakeLotesRepository()),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(ventaFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(ventaFormControllerProvider.notifier)
          .crear(clienteId: 7, lineas: const [_lineaDeEjemplo]);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}