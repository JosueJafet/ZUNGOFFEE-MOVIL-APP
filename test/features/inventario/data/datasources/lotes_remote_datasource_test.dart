import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';

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

Map<String, dynamic> _loteJson({String id = '78'}) {
  return {
    'id': id,
    'saldo': '10.00',
    'cantidad_inicial': '10.00',
    'estados_cafe': {'nombre': 'pergamino_seco', 'unidad_medida_id': 2},
    'variedades_cafe': {'nombre': 'Catuai'},
    'niveles_altura': {'nombre': 'Estandar'},
  };
}

void main() {
  group('LotesRemoteDataSource', () {
    test(
      'getExistencias llama GET /lotes/existencias con page/pageSize y '
      'decodifica el array',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse([_loteJson(), _loteJson(id: '79')], 200),
        );
        final dataSource = LotesRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.getExistencias(page: 2, pageSize: 10);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/lotes/existencias');
        expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
        expect(dtos, hasLength(2));
        expect(dtos.first.id, '78');
        expect(dtos.last.id, '79');
      },
    );

    test('getExistencias usa page 1 y el pageSize por defecto', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse([_loteJson()], 200),
      );
      final dataSource = LotesRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      await dataSource.getExistencias();

      expect(adapter.lastRequest?.queryParameters, {'page': 1, 'pageSize': 20});
    });
  });
}
