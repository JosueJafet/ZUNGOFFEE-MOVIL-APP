import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';

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

void main() {
  group('ProcesamientoRemoteDataSource', () {
    test(
      'crear llama POST /procesamiento con el body en camelCase',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_procesamientoJson(), 201),
        );
        final dataSource = ProcesamientoRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dto = await dataSource.crear(
          loteOrigenId: '78',
          estadoDestinoId: 5,
          cantidadEntrada: 5,
          cantidadSalida: 350,
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/procesamiento');
        expect(adapter.lastRequest?.data, {
          'loteOrigenId': '78',
          'estadoDestinoId': 5,
          'cantidadEntrada': 5.0,
          'cantidadSalida': 350.0,
        });
        expect(dto.id, '9');
      },
    );

    test(
      'listar llama GET /procesamiento?page&pageSize y parsea un array plano',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse([_procesamientoJson()], 200),
        );
        final dataSource = ProcesamientoRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar(page: 2, pageSize: 10);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/procesamiento');
        expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
        expect(dtos, hasLength(1));
        expect(dtos.single.id, '9');
      },
    );

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(Sprint 9, Decisión 5: no depende del nombre de la clave)',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_procesamientoJson()],
          }, 200),
        );
        final dataSource = ProcesamientoRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(dtos, hasLength(1));
      },
    );

    test(
      'anular llama PATCH /procesamiento/:id/anular sin parsear el cuerpo '
      'de la respuesta',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse({'cualquierCosa': true}, 200),
        );
        final dataSource = ProcesamientoRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        await dataSource.anular('9');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/procesamiento/9/anular');
      },
    );
  });
}
