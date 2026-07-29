import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';

Map<String, dynamic> _compraJson() {
  return {
    'id': 45,
    'tenant_id': 5,
    'proveedor_id': 12,
    'usuario_id': 3,
    'fecha': '2026-08-01T00:00:00.000Z',
    'total': '1200.00',
    'anulada': false,
  };
}

/// Forma real de `GET /compras` (curl), distinta a la de `POST /compras`
/// que usa `_compraJson()` — sin `tenant_id`/`proveedor_id`/`usuario_id`
/// planos ni `anulada`, con `proveedores`/`usuarios` anidados.
Map<String, dynamic> _compraHistorialJson() {
  return {
    'id': 45,
    'fecha': '2026-08-01T00:00:00.000Z',
    'total': '1200.00',
    'proveedores': {'id': 12, 'nombre': 'Don Chepe Martinez'},
    'usuarios': {'id': 3, 'nombre': 'Admin Bodega Uno'},
  };
}

void main() {
  group('ComprasRemoteDataSource', () {
    test(
      'crear llama POST /compras con proveedorId, metodoPagoId y lineas',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_compraJson(), 201),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dto = await dataSource.crear(
          proveedorId: 12,
          metodoPagoId: 1,
          lineas: const [
            LineaCompraInput(
              estadoCafeId: 3,
              variedadId: 1,
              alturaId: 1,
              humedad: 11.5,
              cantidad: 10,
              costoUnitario: 120,
            ),
          ],
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/compras');
        expect(adapter.lastRequest?.data, {
          'proveedorId': 12,
          'metodoPagoId': 1,
          'lineas': [
            {
              'estadoCafeId': 3,
              'variedadId': 1,
              'alturaId': 1,
              'humedad': 11.5,
              'cantidad': 10.0,
              'costoUnitario': 120.0,
            },
          ],
        });
        expect(dto.id, 45);
      },
    );

    test(
      'crear sin metodoPagoId no manda esa clave en el body',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_compraJson(), 201),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.crear(
          proveedorId: 12,
          lineas: const [
            LineaCompraInput(
              estadoCafeId: 3,
              variedadId: 1,
              alturaId: 1,
              humedad: 11.5,
              cantidad: 10,
              costoUnitario: 120,
            ),
          ],
        );

        final body = adapter.lastRequest?.data as Map<String, dynamic>;
        expect(body.containsKey('metodoPagoId'), isFalse);
      },
    );

    test(
      'crear con humedad nula (línea en uva) no manda esa clave en la línea',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_compraJson(), 201),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.crear(
          proveedorId: 12,
          lineas: const [
            LineaCompraInput(
              estadoCafeId: 1,
              variedadId: 1,
              alturaId: 1,
              cantidad: 10,
              costoUnitario: 120,
            ),
          ],
        );

        final body = adapter.lastRequest?.data as Map<String, dynamic>;
        final linea = (body['lineas'] as List).single as Map<String, dynamic>;
        expect(linea.containsKey('humedad'), isFalse);
      },
    );

    test('crear con varias líneas las manda todas en el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_compraJson(), 201),
      );
      final dataSource = ComprasRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        proveedorId: 12,
        lineas: const [
          LineaCompraInput(
            estadoCafeId: 1,
            variedadId: 1,
            alturaId: 1,
            humedad: 12,
            cantidad: 5,
            costoUnitario: 100,
          ),
          LineaCompraInput(
            estadoCafeId: 2,
            variedadId: 2,
            alturaId: 1,
            humedad: 30,
            cantidad: 8,
            costoUnitario: 80,
          ),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body['lineas'], hasLength(2));
    });

    test(
      'listar llama GET /compras?page&pageSize y parsea la forma real de '
      'la API (proveedores/usuarios anidados)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_compraHistorialJson()], 200),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar(page: 2, pageSize: 10);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/compras');
        expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
        expect(dtos, hasLength(1));
        expect(dtos.single.id, 45);
        expect(dtos.single.proveedores.nombre, 'Don Chepe Martinez');
        expect(dtos.single.usuarios.nombre, 'Admin Bodega Uno');
      },
    );

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(Sprint 9, Decisión 5: no depende del nombre de la clave)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_compraHistorialJson()],
          }, 200),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(dtos, hasLength(1));
      },
    );

    test(
      'anular llama PATCH /compras/:id/anular sin parsear el cuerpo de la '
      'respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({'cualquierCosa': true}, 200),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.anular(45);

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/compras/45/anular');
      },
    );

    test(
      'getResumen llama GET /compras/resumen y decodifica el groupBy '
      '(sin query params, el endpoint los ignora)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([
            {
              '_sum': {'total': '12292318.84'},
              'fecha': '2026-07-21T00:00:00.000Z',
            },
            {
              '_sum': {'total': '2547843.41'},
              'fecha': '2026-07-20T00:00:00.000Z',
            },
          ], 200),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.getResumen();

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/compras/resumen');
        expect(adapter.lastRequest?.queryParameters, isEmpty);
        expect(dtos, hasLength(2));
        expect(dtos.first.sum.total, '12292318.84');
      },
    );
  });
}
