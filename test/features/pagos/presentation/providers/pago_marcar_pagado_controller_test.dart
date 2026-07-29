import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pagos_resumen.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_marcar_pagado_controller.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';

const _resumen = PagosResumen(
  tenantsActivos: 16,
  tenantsSuspendidos: 2,
  ingresosMesActual: 1000,
  ingresosTotales: 1000,
);

final _pago = Pago(
  id: 1,
  tenantId: 5,
  periodo: DateTime.parse('2026-08-01T00:00:00.000Z'),
  monto: 500,
  fechaVencimiento: DateTime.parse('2026-08-31T00:00:00.000Z'),
  estadoPagoId: 1,
  registradoPor: 8,
  estadoCalculado: 'pendiente',
);

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository({this.marcarPagadoError})
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? marcarPagadoError;
  int marcarPagadoCallCount = 0;
  int getHistorialCallCount = 0;
  int getResumenCallCount = 0;

  @override
  Future<PagosResumen> getResumen() async {
    getResumenCallCount++;
    return _resumen;
  }

  @override
  Future<List<Pago>> getHistorialPorBodega(int tenantId) async {
    getHistorialCallCount++;
    return [_pago];
  }

  @override
  Future<void> marcarPagado(int id) async {
    marcarPagadoCallCount++;
    if (marcarPagadoError != null) throw marcarPagadoError!;
  }
}

void main() {
  group('PagoMarcarPagadoController', () {
    test(
      'marcarPagado exitoso: loading -> data, e invalida '
      'pagosHistorialProvider(tenantId) y pagosResumenProvider',
      () async {
        final repository = _FakePagoRepository();
        final container = ProviderContainer(
          overrides: [pagoRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        await container.read(pagosHistorialProvider(5).future);
        await container.read(pagosResumenProvider.future);
        expect(repository.getHistorialCallCount, 1);
        expect(repository.getResumenCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(pagoMarcarPagadoControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(pagoMarcarPagadoControllerProvider.notifier)
            .marcarPagado(1, tenantId: 5);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.marcarPagadoCallCount, 1);

        await container.read(pagosHistorialProvider(5).future);
        await container.read(pagosResumenProvider.future);
        expect(repository.getHistorialCallCount, 2);
        expect(repository.getResumenCallCount, 2);
      },
    );

    test('marcarPagado con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          pagoRepositoryProvider.overrideWithValue(
            _FakePagoRepository(marcarPagadoError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(pagoMarcarPagadoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(pagoMarcarPagadoControllerProvider.notifier)
          .marcarPagado(1, tenantId: 5);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
