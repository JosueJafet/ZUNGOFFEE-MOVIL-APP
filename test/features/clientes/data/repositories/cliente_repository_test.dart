import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';

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

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
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

Map<String, dynamic> _clienteJson({int id = 1}) {
  return {
    'id': id,
    'tenant_id': 5,
    'nombre': 'Cafeteria El Buen Cafe',
    'tipo_id': 2,
    'lugar': 'Tegucigalpa',
    'telefono': null,
    'estado': true,
  };
}

ClienteRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return ClienteRepository(ClienteRemoteDataSource(apiClient));
}

void main() {
  group('ClienteRepository', () {
    test('getClientes mapea un 200 a List<Cliente>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_clienteJson(), _clienteJson(id: 2)], 200),
        ),
      );

      final clientes = await repository.getClientes();

      expect(clientes, hasLength(2));
      expect(clientes.first.id, 1);
      expect(clientes.first.nombre, 'Cafeteria El Buen Cafe');
      expect(clientes.last.id, 2);
    });

    test('crear mapea un 201 a Cliente', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_clienteJson(), 201)),
      );

      final cliente = await repository.crear(nombre: 'Cafeteria El Buen Cafe');

      expect(cliente.id, 1);
      expect(cliente.nombre, 'Cafeteria El Buen Cafe');
    });

    test('actualizar mapea un 200 a Cliente', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_clienteJson(), 200)),
      );

      final cliente = await repository.actualizar(1, telefono: '8888-8888');

      expect(cliente.id, 1);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 403,
              'message': 'Forbidden resource',
              'error': 'Forbidden',
            }, 403),
          ),
        );

        await expectLater(
          repository.actualizar(1, nombre: 'Otro Nombre'),
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