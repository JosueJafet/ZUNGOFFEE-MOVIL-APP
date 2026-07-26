import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';

Map<String, dynamic> _clienteJson({
  int id = 1,
  String nombre = 'Cafeteria El Buen Cafe',
}) {
  return {
    'id': id,
    'tenant_id': 5,
    'nombre': nombre,
    'tipo_id': 2,
    'lugar': 'Tegucigalpa',
    'telefono': null,
    'estado': true,
  };
}

void main() {
  group('ClienteRemoteDataSource', () {
    test('getClientes llama GET /clientes y decodifica el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_clienteJson(), _clienteJson(id: 2)], 200),
      );
      final dataSource = ClienteRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      final dtos = await dataSource.getClientes();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/clientes');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 1);
      expect(dtos.last.id, 2);
    });

    test('crear llama POST /clientes con el body en camelCase', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_clienteJson(), 201),
      );
      final dataSource = ClienteRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      final dto = await dataSource.crear(
        nombre: 'Cafeteria El Buen Cafe',
        tipoId: 2,
        lugar: 'Tegucigalpa',
      );

      expect(adapter.lastRequest?.method, 'POST');
      expect(adapter.lastRequest?.path, '/clientes');
      expect(adapter.lastRequest?.data, {
        'nombre': 'Cafeteria El Buen Cafe',
        'tipoId': 2,
        'lugar': 'Tegucigalpa',
      });
      expect(dto.id, 1);
    });

    test(
      'crear con solo el nombre no manda las claves opcionales en el body',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_clienteJson(), 201),
        );
        final dataSource = ClienteRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.crear(nombre: 'Solo Nombre');

        expect(adapter.lastRequest?.data, {'nombre': 'Solo Nombre'});
      },
    );

    test(
      'actualizar llama PATCH /clientes/:id con solo los campos provistos',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_clienteJson(), 200),
        );
        final dataSource = ClienteRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dto = await dataSource.actualizar(1, telefono: '8888-8888');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/clientes/1');
        expect(adapter.lastRequest?.data, {'telefono': '8888-8888'});
        expect(dto.id, 1);
      },
    );
  });
}
