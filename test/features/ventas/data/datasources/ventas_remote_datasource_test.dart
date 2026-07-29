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

/// Forma real de `GET /ventas` (curl), distinta a la de `POST /ventas`
/// que usa `_ventaJson()` — sin `tenant_id`/`cliente_id`/`usuario_id`
/// planos ni `anulada`, con `clientes` anidado, y con `fecha` (que la
/// respuesta de creación no tiene).
Map<String, dynamic> _ventaHistorialJson() {
  return {
    'id': 30,
    'fecha': '2026-08-01T00:00:00.000Z',
    'total': '750.00',
    'clientes': {'id': 7, 'nombre': 'Cafeteria El Buen Cafe'},
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
      'listar llama GET /ventas?page&pageSize y parsea la forma real de '
      'la API (clientes anidado, con fecha)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_ventaHistorialJson()], 200),
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
        expect(dtos.single.clientes.nombre, 'Cafeteria El Buen Cafe');
      },
    );

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(Sprint 9, Decisión 5: no depende del nombre de la clave)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_ventaHistorialJson()],
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

    test(
      'getResumen llama GET /ventas/resumen y decodifica el groupBy',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([
            {
              '_sum': {'total': '5000.00'},
              'fecha': '2026-07-21T00:00:00.000Z',
            },
          ], 200),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.getResumen();

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/ventas/resumen');
        expect(adapter.lastRequest?.queryParameters, isEmpty);
        expect(dtos, hasLength(1));
        expect(dtos.single.sum.total, '5000.00');
      },
    );
  });
}
