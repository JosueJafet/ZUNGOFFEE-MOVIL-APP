import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  _FakeSessionTokenProvider(this.accessToken);

  @override
  String? accessToken;
}

/// Adaptador HTTP falso: nunca toca la red, responde con lo que indique
/// [_handler] (o lanza, para simular una falla de conexión).
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

void main() {
  group('ApiClient', () {
    test('adjunta el JWT como Authorization: Bearer <token>', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse({}, 200),
      );
      final client = ApiClient(
        _FakeSessionTokenProvider('token-123'),
        dio: _dioWithAdapter(adapter),
      );

      await client.get('/perfil');

      expect(adapter.lastRequest?.headers['Authorization'], 'Bearer token-123');
    });

    test('no adjunta Authorization si no hay sesión activa', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse({}, 200),
      );
      final client = ApiClient(
        _FakeSessionTokenProvider(null),
        dio: _dioWithAdapter(adapter),
      );

      await client.get('/catalogos');

      expect(adapter.lastRequest?.headers['Authorization'], isNull);
    });

    test('traduce un error 400 de la API a ApiException', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse({
          'statusCode': 400,
          'message': 'Saldo insuficiente en lote 78',
          'error': 'Bad Request',
        }, 400),
      );
      final client = ApiClient(
        _FakeSessionTokenProvider(null),
        dio: _dioWithAdapter(adapter),
      );

      await expectLater(
        client.post('/ventas', data: {}),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having(
                (e) => e.message,
                'message',
                'Saldo insuficiente en lote 78',
              )
              .having((e) => e.isBadRequest, 'isBadRequest', isTrue),
        ),
      );
    });

    test('traduce un 403 a ApiException.isForbidden', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse({
          'statusCode': 403,
          'message': 'Forbidden resource',
          'error': 'Forbidden',
        }, 403),
      );
      final client = ApiClient(
        _FakeSessionTokenProvider('token-123'),
        dio: _dioWithAdapter(adapter),
      );

      await expectLater(
        client.get('/tenants'),
        throwsA(isA<ApiException>().having((e) => e.isForbidden, 'isForbidden', isTrue)),
      );
    });

    test('traduce una falla de conexión a NetworkException', () async {
      final adapter = _FakeHttpClientAdapter((options) {
        throw Exception('simulated connection failure');
      });
      final client = ApiClient(
        _FakeSessionTokenProvider(null),
        dio: _dioWithAdapter(adapter),
      );

      await expectLater(client.get('/perfil'), throwsA(isA<NetworkException>()));
    });
  });
}
