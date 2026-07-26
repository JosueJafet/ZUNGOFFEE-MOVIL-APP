import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';

Map<String, dynamic> _proveedorJson({
  int id = 12,
  String nombre = 'Don Chepe Martinez',
}) {
  return {
    'id': id,
    'tenant_id': 5,
    'nombre': nombre,
    'sexo': 'M',
    'lugar': 'Marcala',
    'finca': 'Finca El Roble',
    'tipo_id': 1,
    'telefono': '9999-9999',
    'estado': true,
  };
}

void main() {
  group('ProveedorRemoteDataSource', () {
    test('getProveedores llama GET /proveedores y decodifica el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_proveedorJson(), _proveedorJson(id: 13)], 200),
      );
      final dataSource = ProveedorRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      final dtos = await dataSource.getProveedores();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/proveedores');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 12);
      expect(dtos.last.id, 13);
    });

    test('crear llama POST /proveedores con el body en camelCase', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_proveedorJson(), 201),
      );
      final dataSource = ProveedorRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      final dto = await dataSource.crear(
        nombre: 'Don Chepe Martinez',
        sexo: 'M',
        lugar: 'Marcala',
        finca: 'Finca El Roble',
        telefono: '9999-9999',
      );

      expect(adapter.lastRequest?.method, 'POST');
      expect(adapter.lastRequest?.path, '/proveedores');
      expect(adapter.lastRequest?.data, {
        'nombre': 'Don Chepe Martinez',
        'sexo': 'M',
        'lugar': 'Marcala',
        'finca': 'Finca El Roble',
        'telefono': '9999-9999',
      });
      expect(dto.id, 12);
    });

    test(
      'crear con solo el nombre no manda las claves opcionales en el body',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_proveedorJson(), 201),
        );
        final dataSource = ProveedorRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.crear(nombre: 'Solo Nombre');

        expect(adapter.lastRequest?.data, {'nombre': 'Solo Nombre'});
      },
    );

    test(
      'actualizar llama PATCH /proveedores/:id con solo los campos provistos',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse(_proveedorJson(), 200),
        );
        final dataSource = ProveedorRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dto = await dataSource.actualizar(12, telefono: '8888-8888');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/proveedores/12');
        expect(adapter.lastRequest?.data, {'telefono': '8888-8888'});
        expect(dto.id, 12);
      },
    );
  });
}
