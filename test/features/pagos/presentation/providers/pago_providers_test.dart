import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pagos_resumen.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository({this.resumen, this.historial})
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final PagosResumen? resumen;
  final List<Pago>? historial;
  int? tenantIdRecibido;

  @override
  Future<PagosResumen> getResumen() async => resumen!;

  @override
  Future<List<Pago>> getHistorialPorBodega(int tenantId) async {
    tenantIdRecibido = tenantId;
    return historial!;
  }
}

void main() {
  group('pagosResumenProvider', () {
    test('resuelve al PagosResumen del repository', () async {
      const expected = PagosResumen(
        tenantsActivos: 16,
        tenantsSuspendidos: 2,
        ingresosMesActual: 1000,
        ingresosTotales: 1000,
      );

      final container = ProviderContainer(
        overrides: [
          pagoRepositoryProvider.overrideWithValue(
            _FakePagoRepository(resumen: expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final resumen = await container.read(pagosResumenProvider.future);

      expect(resumen, expected);
    });
  });

  group('pagosHistorialProvider', () {
    test('resuelve a la List<Pago> del repository, según el tenantId', () async {
      final expected = [
        Pago(
          id: 1,
          tenantId: 5,
          periodo: DateTime.parse('2026-08-01T00:00:00.000Z'),
          monto: 500,
          fechaVencimiento: DateTime.parse('2026-08-31T00:00:00.000Z'),
          estadoPagoId: 1,
          registradoPor: 8,
          estadoCalculado: 'pendiente',
        ),
      ];

      final repository = _FakePagoRepository(historial: expected);
      final container = ProviderContainer(
        overrides: [pagoRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final pagos = await container.read(pagosHistorialProvider(5).future);

      expect(pagos, expected);
      expect(repository.tenantIdRecibido, 5);
    });
  });
}
