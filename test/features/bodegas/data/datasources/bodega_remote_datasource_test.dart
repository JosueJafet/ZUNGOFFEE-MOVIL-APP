import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';

Map<String, dynamic> _bodegaJson({int id = 5, String nombre = 'Bodega de Prueba'}) {
  return {
    'id': id,
    'nombre': nombre,
    'estado_id': 1,
    'fecha_registro': '2026-07-21T00:00:00.000Z',
    'estados_tenant': {'nombre': 'activo'},
  };
}

BodegaRemoteDataSource _dataSourceWithAdapter(FakeHttpClientAdapter adapter) {
  return BodegaRemoteDataSource(
    ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
  );
}

void main() {
  group('BodegaRemoteDataSource', () {
    test('getBodegas llama GET /tenants y decodifica el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_bodegaJson(), _bodegaJson(id: 6)], 200),
      );
      final dataSource = _dataSourceWithAdapter(adapter);

      final dtos = await dataSource.getBodegas();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/tenants');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 5);
      expect(dtos.last.id, 6);
    });

    test(
      'onboarding llama POST /tenants/onboarding con el body en camelCase '
      'y parsea solo el campo tenant de la respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'tenant': _bodegaJson(id: 25, nombre: 'Bodega Nueva'),
            'usuario': {'id': 35, 'tenant_id': 25, 'nombre': 'Admin Nuevo'},
          }, 201),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        final dto = await dataSource.onboarding(
          nombreBodega: 'Bodega Nueva',
          emailAdmin: 'admin@bodeganueva.com',
          passwordAdmin: 'password123',
          nombreAdmin: 'Admin Nuevo',
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/tenants/onboarding');
        expect(adapter.lastRequest?.data, {
          'nombreBodega': 'Bodega Nueva',
          'emailAdmin': 'admin@bodeganueva.com',
          'passwordAdmin': 'password123',
          'nombreAdmin': 'Admin Nuevo',
        });
        expect(dto.id, 25);
        expect(dto.nombre, 'Bodega Nueva');
      },
    );

    test('onboarding con solicitudId lo incluye en el body', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({'tenant': _bodegaJson(), 'usuario': {}}, 201),
      );
      final dataSource = _dataSourceWithAdapter(adapter);

      await dataSource.onboarding(
        nombreBodega: 'Bodega Nueva',
        emailAdmin: 'admin@bodeganueva.com',
        passwordAdmin: 'password123',
        nombreAdmin: 'Admin Nuevo',
        solicitudId: 123,
      );

      expect(adapter.lastRequest?.data, {
        'nombreBodega': 'Bodega Nueva',
        'emailAdmin': 'admin@bodeganueva.com',
        'passwordAdmin': 'password123',
        'nombreAdmin': 'Admin Nuevo',
        'solicitudId': 123,
      });
    });

    test('actualizarNombre llama PATCH /tenants/:id con { nombre }', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_bodegaJson(nombre: 'Nuevo nombre'), 200),
      );
      final dataSource = _dataSourceWithAdapter(adapter);

      final dto = await dataSource.actualizarNombre(5, nombre: 'Nuevo nombre');

      expect(adapter.lastRequest?.method, 'PATCH');
      expect(adapter.lastRequest?.path, '/tenants/5');
      expect(adapter.lastRequest?.data, {'nombre': 'Nuevo nombre'});
      expect(dto.nombre, 'Nuevo nombre');
    });

    test(
      'suspender llama PATCH /pagos/tenant/:id/suspender sin body y '
      'descarta la respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_bodegaJson(), 200),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        await dataSource.suspender(5);

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/pagos/tenant/5/suspender');
        expect(adapter.lastRequest?.data, isNull);
      },
    );

    test('activar llama PATCH /pagos/tenant/:id/activar sin body', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_bodegaJson(), 200),
      );
      final dataSource = _dataSourceWithAdapter(adapter);

      await dataSource.activar(5);

      expect(adapter.lastRequest?.method, 'PATCH');
      expect(adapter.lastRequest?.path, '/pagos/tenant/5/activar');
      expect(adapter.lastRequest?.data, isNull);
    });
  });
}
