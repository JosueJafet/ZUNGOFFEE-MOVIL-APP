import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';

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

PagoRepository _repositoryWithAdapter(FakeHttpClientAdapter adapter) {
  final apiClient = ApiClient(
    FakeSessionTokenProvider('token-123'),
    dio: dioWithAdapter(adapter),
  );
  return PagoRepository(PagoRemoteDataSource(apiClient));
}

void main() {
  group('PagoRepository', () {
    test('getResumen mapea un 200 a PagosResumen', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter((options) => jsonResponse(_resumenJson(), 200)),
      );

      final resumen = await repository.getResumen();

      expect(resumen.tenantsActivos, 16);
      expect(resumen.ingresosMesActual, 1000.0);
    });

    test('getHistorialPorBodega mapea un 200 a List<Pago>', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter(
          (options) => jsonResponse([_pagoJson(), _pagoJson(id: 2)], 200),
        ),
      );

      final pagos = await repository.getHistorialPorBodega(5);

      expect(pagos, hasLength(2));
      expect(pagos.first.id, 1);
    });

    test('registrar/marcarPagado no lanzan con una respuesta exitosa', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter((options) => jsonResponse(_pagoJson(), 200)),
      );

      await repository.registrar(
        tenantId: 5,
        periodo: DateTime.parse('2099-01-01'),
        monto: 123.45,
        fechaVencimiento: DateTime.parse('2099-01-31'),
      );
      await repository.marcarPagado(1);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          FakeHttpClientAdapter(
            (options) => jsonResponse({
              'statusCode': 403,
              'message': 'Forbidden resource',
              'error': 'Forbidden',
            }, 403),
          ),
        );

        await expectLater(
          repository.getResumen(),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 403)
                .having((e) => e.isForbidden, 'isForbidden', isTrue),
          ),
        );
      },
    );
  });
}
