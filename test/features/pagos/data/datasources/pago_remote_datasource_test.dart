import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';

Map<String, dynamic> _resumenJson() {
  return {
    'tenantsActivos': 16,
    'tenantsSuspendidos': 2,
    'ingresosMesActual': '1000',
    'ingresosTotales': '1000',
  };
}

Map<String, dynamic> _pagoJson({int id = 1}) {
  return {
    'id': id,
    'tenant_id': 5,
    'periodo': '2026-08-01T00:00:00.000Z',
    'monto': '500',
    'fecha_vencimiento': '2026-08-31T00:00:00.000Z',
    'fecha_pago': null,
    'estado_pago_id': 1,
    'registrado_por': 8,
    'estado_calculado': 'pendiente',
  };
}

PagoRemoteDataSource _dataSourceWithAdapter(FakeHttpClientAdapter adapter) {
  return PagoRemoteDataSource(
    ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
  );
}

void main() {
  group('PagoRemoteDataSource', () {
    test('getResumen llama GET /pagos/resumen y decodifica el objeto', () async {
      final adapter = FakeHttpClientAdapter((options) => jsonResponse(_resumenJson(), 200));
      final dataSource = _dataSourceWithAdapter(adapter);

      final dto = await dataSource.getResumen();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/pagos/resumen');
      expect(dto.tenantsActivos, 16);
    });

    test(
      'getHistorialPorBodega llama GET /pagos/tenant/:tenantId y '
      'decodifica el array',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_pagoJson(), _pagoJson(id: 2)], 200),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        final dtos = await dataSource.getHistorialPorBodega(5);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/pagos/tenant/5');
        expect(dtos, hasLength(2));
        expect(dtos.first.id, 1);
        expect(dtos.last.id, 2);
      },
    );

    test(
      'registrar llama POST /pagos con el body correcto y descarta la '
      'respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'id': 5,
            'tenant_id': 5,
            'periodo': '2099-01-01T00:00:00.000Z',
            'monto': '123.45',
            'fecha_vencimiento': '2099-01-31T00:00:00.000Z',
            'fecha_pago': null,
            'estado_pago_id': 1,
            'registrado_por': 8,
            // Gotcha real (Rubio): POST /pagos NO incluye
            // estado_calculado — este test prueba justo que el
            // datasource no intenta parsearlo.
          }, 201),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        await dataSource.registrar(
          tenantId: 5,
          periodo: DateTime.parse('2099-01-01'),
          monto: 123.45,
          fechaVencimiento: DateTime.parse('2099-01-31'),
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/pagos');
        expect(adapter.lastRequest?.data, {
          'tenantId': 5,
          'periodo': '2099-01-01',
          'monto': 123.45,
          'fechaVencimiento': '2099-01-31',
        });
      },
    );

    test(
      'marcarPagado llama PATCH /pagos/:id/marcar-pagado sin body y '
      'descarta la respuesta (sin estado_calculado)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'id': 5,
            'tenant_id': 5,
            'periodo': '2099-01-01T00:00:00.000Z',
            'monto': '123.45',
            'fecha_vencimiento': '2099-01-31T00:00:00.000Z',
            'fecha_pago': '2026-07-27T19:53:09.807Z',
            'estado_pago_id': 2,
            'registrado_por': 8,
          }, 200),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        await dataSource.marcarPagado(5);

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/pagos/5/marcar-pagado');
        expect(adapter.lastRequest?.data, isNull);
      },
    );
  });
}
