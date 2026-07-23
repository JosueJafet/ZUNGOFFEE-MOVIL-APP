import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  _FakeSessionTokenProvider(this.accessToken);

  @override
  String? accessToken;
}

/// Mismo fake de `test/core/api/api_client_test.dart`: nunca toca la red,
/// responde con lo que indique [_handler].
class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this._handler);

  final ResponseBody Function(RequestOptions options) _handler;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWithAdapter(HttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = adapter;
  return dio;
}

ResponseBody _jsonResponse(Object body, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

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
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse([_proveedorJson(), _proveedorJson(id: 13)], 200),
      );
      final dataSource = ProveedorRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      final dtos = await dataSource.getProveedores();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/proveedores');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 12);
      expect(dtos.last.id, 13);
    });

    test('crear llama POST /proveedores con el body en camelCase', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_proveedorJson(), 201),
      );
      final dataSource = ProveedorRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
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
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_proveedorJson(), 201),
        );
        final dataSource = ProveedorRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        await dataSource.crear(nombre: 'Solo Nombre');

        expect(adapter.lastRequest?.data, {'nombre': 'Solo Nombre'});
      },
    );

    test(
      'actualizar llama PATCH /proveedores/:id con solo los campos provistos',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_proveedorJson(), 200),
        );
        final dataSource = ProveedorRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
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
