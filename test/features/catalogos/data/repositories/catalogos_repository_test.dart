import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';

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

CatalogosRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return CatalogosRepository(CatalogosRemoteDataSource(apiClient));
}

void main() {
  group('CatalogosRepository', () {
    test('getCatalogos mapea un 200 a Catalogos', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_catalogosJson(), 200)),
      );

      final catalogos = await repository.getCatalogos();

      expect(catalogos.metodosPago.single.nombre, 'Efectivo');
      expect(catalogos.variedadesCafe.single.nombre, 'Catuai');
      expect(catalogos.nivelesAltura.single.msnmMin, 800);
      expect(catalogos.estadosCafe.single.unidadMedidaId, 1);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 500,
              'message': 'Internal Server Error',
              'error': 'Internal Server Error',
            }, 500),
          ),
        );

        await expectLater(
          repository.getCatalogos(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
          ),
        );
      },
    );
  });
}
