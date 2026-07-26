import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';

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

Map<String, dynamic> _notificacionJson() {
  return {
    'id': '3',
    'titulo': 'Compra registrada',
    'mensaje': 'Se registró una compra de 10 quintales',
    'leida': false,
  };
}

void main() {
  group('NotificacionesRemoteDataSource', () {
    test(
      'listar llama GET /notificaciones con page/pageSize=50 por defecto '
      'y parsea un array plano',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse([_notificacionJson()], 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/notificaciones');
        expect(adapter.lastRequest?.queryParameters, {'page': 1, 'pageSize': 50});
        expect(dtos, hasLength(1));
        expect(dtos.single.id, '3');
      },
    );

    test('listar respeta page/pageSize explícitos', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse([_notificacionJson()], 200),
      );
      final dataSource = NotificacionesRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      await dataSource.listar(page: 2, pageSize: 10);

      expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
    });

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(mismo criterio que Sprint 9, Decisión 5)',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_notificacionJson()],
          }, 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(dtos, hasLength(1));
      },
    );

    test(
      'marcarLeida llama PATCH /notificaciones/:id/leida sin parsear el '
      'cuerpo de la respuesta',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse({'cualquierCosa': true}, 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        await dataSource.marcarLeida('3');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/notificaciones/3/leida');
      },
    );
  });
}
