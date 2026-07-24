import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/models/compra.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compra_form_controller.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _compra = Compra(
  id: 45,
  tenantId: 5,
  proveedorId: 12,
  usuarioId: 3,
  fecha: DateTime.parse('2026-08-01T00:00:00.000Z'),
  total: 1200,
  anulada: false,
);

const _lineaDeEjemplo = LineaCompraInput(
  estadoCafeId: 3,
  variedadId: 1,
  alturaId: 1,
  humedad: 11.5,
  cantidad: 10,
  costoUnitario: 120,
);

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository({this.crearError})
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  int crearCallCount = 0;

  @override
  Future<Compra> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    crearCallCount++;
    if (crearError != null) throw crearError!;
    return _compra;
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
  group('CompraFormController', () {
    test(
      'crear exitoso: loading -> data, e invalida existenciasProvider',
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

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(compraFormControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(compraFormControllerProvider.notifier)
            .crear(proveedorId: 12, metodoPagoId: 1, lineas: const [_lineaDeEjemplo]);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(comprasRepository.crearCallCount, 1);

        await container.read(existenciasProvider.future);
        expect(lotesRepository.getExistenciasCallCount, 2);
      },
    );

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 400, message: 'El proveedor no existe');
      final container = ProviderContainer(
        overrides: [
          comprasRepositoryProvider.overrideWithValue(
            _FakeComprasRepository(crearError: error),
          ),
          lotesRepositoryProvider.overrideWithValue(_FakeLotesRepository()),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(compraFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(compraFormControllerProvider.notifier)
          .crear(proveedorId: 999, lineas: const [_lineaDeEjemplo]);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
