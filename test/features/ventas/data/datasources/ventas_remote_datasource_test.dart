import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';

Map<String, dynamic> _ventaJson() {
  return {
    'id': 30,
    'tenant_id': 5,
    'cliente_id': 7,
    'usuario_id': 3,
    'total': '750.00',
    'anulada': false,
  };
}

void main() {
  group('VentasRemoteDataSource', () {
    test(
      'crear llama POST /ventas con clienteId, metodoPagoId y lineas',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_ventaJson(), 201),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dto = await dataSource.crear(
          clienteId: 7,
          metodoPagoId: 1,
          lineas: const [
            LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
          ],
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/ventas');
        expect(adapter.lastRequest?.data, {
          'clienteId': 7,
          'metodoPagoId': 1,
          'lineas': [
            {'loteId': '78', 'cantidad': 5.0, 'precioUnitario': 150.0},
          ],
        });
        expect(dto.id, 30);
      },
    );

    test('crear sin metodoPagoId no manda esa clave en el body', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_ventaJson(), 201),
      );
      final dataSource = VentasRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        clienteId: 7,
        lineas: const [
          LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body.containsKey('metodoPagoId'), isFalse);
    });

    test('crear con varias líneas las manda todas en el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_ventaJson(), 201),
      );
      final dataSource = VentasRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        clienteId: 7,
        lineas: const [
          LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
          LineaVentaInput(loteId: '80', cantidad: 2, precioUnitario: 200),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body['lineas'], hasLength(2));
    });

    test(
      'listar llama GET /ventas?page&pageSize y parsea un array plano',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_ventaJson()], 200),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar(page: 2, pageSize: 10);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/ventas');
        expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
        expect(dtos, hasLength(1));
        expect(dtos.single.id, 30);
      },
    );

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(Sprint 9, Decisión 5: no depende del nombre de la clave)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_ventaJson()],
          }, 200),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(dtos, hasLength(1));
      },
    );

    test(
      'anular llama PATCH /ventas/:id/anular sin parsear el cuerpo de la '
      'respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({'cualquierCosa': true}, 200),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.anular(30);

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/ventas/30/anular');
      },
    );
  });
}
