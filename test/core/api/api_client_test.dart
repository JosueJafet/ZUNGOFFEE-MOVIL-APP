import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_http_client_adapter.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';

void main() {
  group('ApiClient', () {
    test('adjunta el JWT como Authorization: Bearer <token>', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({}, 200),
      );
      final client = ApiClient(
        FakeSessionTokenProvider('token-123'),
        dio: dioWithAdapter(adapter),
      );

      await client.get('/perfil');

      expect(adapter.lastRequest?.headers['Authorization'], 'Bearer token-123');
    });

    test('no adjunta Authorization si no hay sesión activa', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({}, 200),
      );
      final client = ApiClient(
        FakeSessionTokenProvider(null),
        dio: dioWithAdapter(adapter),
      );

      await client.get('/catalogos');

      expect(adapter.lastRequest?.headers['Authorization'], isNull);
    });

    test('traduce un error 400 de la API a ApiException', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({
          'statusCode': 400,
          'message': 'Saldo insuficiente en lote 78',
          'error': 'Bad Request',
        }, 400),
      );
      final client = ApiClient(
        FakeSessionTokenProvider(null),
        dio: dioWithAdapter(adapter),
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
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({
          'statusCode': 403,
          'message': 'Forbidden resource',
          'error': 'Forbidden',
        }, 403),
      );
      final client = ApiClient(
        FakeSessionTokenProvider('token-123'),
        dio: dioWithAdapter(adapter),
      );

      await expectLater(
        client.get('/tenants'),
        throwsA(isA<ApiException>().having((e) => e.isForbidden, 'isForbidden', isTrue)),
      );
    });

    test('traduce una falla de conexión a NetworkException', () async {
      final adapter = FakeHttpClientAdapter((options) {
        throw Exception('simulated connection failure');
      });
      final client = ApiClient(
        FakeSessionTokenProvider(null),
        dio: dioWithAdapter(adapter),
      );

      await expectLater(client.get('/perfil'), throwsA(isA<NetworkException>()));
    });
  });
}
