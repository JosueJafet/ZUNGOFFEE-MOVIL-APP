import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';

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

Map<String, dynamic> _catalogosJson() {
  return {
    'metodosPago': [
      {'id': 1, 'nombre': 'Efectivo'},
    ],
    'variedadesCafe': [
      {'id': 1, 'nombre': 'Catuai'},
    ],
    'nivelesAltura': [
      {'id': 1, 'nombre': 'Estandar', 'msnm_min': 800, 'msnm_max': 1200},
    ],
    'estadosCafe': [
      {'id': 1, 'nombre': 'uva', 'unidad_medida_id': 1},
    ],
  };
}

void main() {
  group('CatalogosRemoteDataSource', () {
    test('getCatalogos llama GET /catalogos y decodifica la respuesta', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_catalogosJson(), 200),
      );
      final dataSource = CatalogosRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      final dto = await dataSource.getCatalogos();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/catalogos');
      expect(dto.metodosPago.single.nombre, 'Efectivo');
      expect(dto.estadosCafe.single.unidadMedidaId, 1);
    });
  });
}
