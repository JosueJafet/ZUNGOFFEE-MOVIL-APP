import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  _FakeSessionTokenProvider(this.accessToken);

  @override
  String? accessToken;
}

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

Map<String, dynamic> _notificacionJson() {
  return {
    'id': '3',
    'titulo': 'Compra registrada',
    'mensaje': 'Se registró una compra de 10 quintales',
    'leida': false,
  };
}

NotificacionesRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return NotificacionesRepository(NotificacionesRemoteDataSource(apiClient));
}

void main() {
  group('NotificacionesRepository', () {
    test('listar mapea el array de la API a List<Notificacion>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_notificacionJson()], 200),
        ),
      );

      final notificaciones = await repository.listar();

      expect(notificaciones, hasLength(1));
      expect(notificaciones.single.id, '3');
      expect(notificaciones.single.leida, isFalse);
    });

    test('marcarLeida propaga un ApiException tal cual', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'statusCode': 404,
            'message': 'Notificación no encontrada',
            'error': 'Not Found',
          }, 404),
        ),
      );

      await expectLater(
        repository.marcarLeida('999'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });

    test('registrarDispositivo llama al datasource sin lanzar', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse({}, 201)),
      );

      await repository.registrarDispositivo(
        token: 'fcm-token-abc',
        plataformaId: 2,
      );
    });

    test('desregistrarDispositivo propaga un ApiException tal cual', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'statusCode': 401,
            'message': 'Unauthorized',
            'error': 'Unauthorized',
          }, 401),
        ),
      );

      await expectLater(
        repository.desregistrarDispositivo('fcm-token-abc'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
