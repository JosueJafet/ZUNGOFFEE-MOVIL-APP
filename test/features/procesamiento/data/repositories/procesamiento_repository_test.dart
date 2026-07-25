import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';

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

Map<String, dynamic> _procesamientoJson() {
  return {
    'id': '9',
    'tenant_id': 5,
    'lote_origen_id': '78',
    'lote_destino_id': '80',
    'cantidad_entrada': '5.00',
    'cantidad_salida': '350.00',
  };
}

ProcesamientoRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return ProcesamientoRepository(ProcesamientoRemoteDataSource(apiClient));
}

void main() {
  group('ProcesamientoRepository', () {
    test('crear mapea un 201 a Procesamiento', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse(_procesamientoJson(), 201),
        ),
      );

      final procesamiento = await repository.crear(
        loteOrigenId: '78',
        estadoDestinoId: 5,
        cantidadEntrada: 5,
        cantidadSalida: 350,
      );

      expect(procesamiento.id, '9');
      expect(procesamiento.loteOrigenId, '78');
      expect(procesamiento.loteDestinoId, '80');
      expect(procesamiento.cantidadSalida, 350.0);
    });

    test(
      'transición inválida (400) se relanza como ApiException con el '
      'mensaje de la API',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 400,
              'message': 'Transición de estado no permitida para este lote',
              'error': 'Bad Request',
            }, 400),
          ),
        );

        await expectLater(
          repository.crear(
            loteOrigenId: '78',
            estadoDestinoId: 7,
            cantidadEntrada: 5,
            cantidadSalida: 350,
          ),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.isBadRequest, 'isBadRequest', isTrue)
                .having(
                  (e) => e.message,
                  'message',
                  'Transición de estado no permitida para este lote',
                ),
          ),
        );
      },
    );

    test('listar mapea el array de la API a List<Procesamiento>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_procesamientoJson()], 200),
        ),
      );

      final procesamientos = await repository.listar();

      expect(procesamientos, hasLength(1));
      expect(procesamientos.single.id, '9');
    });

    test('anular propaga un ApiException tal cual', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'statusCode': 400,
            'message': 'El lote derivado ya se movió',
            'error': 'Bad Request',
          }, 400),
        ),
      );

      await expectLater(
        repository.anular('9'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'El lote derivado ya se movió',
          ),
        ),
      );
    });
  });
}
