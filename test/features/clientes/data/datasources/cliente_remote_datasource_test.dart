import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';

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
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse([_clienteJson(), _clienteJson(id: 2)], 200),
      );
      final dataSource = ClienteRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      final dtos = await dataSource.getClientes();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/clientes');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 1);
      expect(dtos.last.id, 2);
    });

    test('crear llama POST /clientes con el body en camelCase', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_clienteJson(), 201),
      );
      final dataSource = ClienteRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
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
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_clienteJson(), 201),
        );
        final dataSource = ClienteRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        await dataSource.crear(nombre: 'Solo Nombre');

        expect(adapter.lastRequest?.data, {'nombre': 'Solo Nombre'});
      },
    );

    test(
      'actualizar llama PATCH /clientes/:id con solo los campos provistos',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_clienteJson(), 200),
        );
        final dataSource = ClienteRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
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