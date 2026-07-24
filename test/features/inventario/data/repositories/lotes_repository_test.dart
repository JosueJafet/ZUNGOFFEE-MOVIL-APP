import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';

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

LotesRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return LotesRepository(LotesRemoteDataSource(apiClient));
}

void main() {
  group('LotesRepository', () {
    test('getExistencias mapea un 200 a List<Lote>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_loteJson(), _loteJson(id: '79')], 200),
        ),
      );

      final lotes = await repository.getExistencias();

      expect(lotes, hasLength(2));
      expect(lotes.first.id, '78');
      expect(lotes.first.saldo, 10.00);
      expect(lotes.first.estadoCafeNombre, 'pergamino_seco');
      expect(lotes.last.id, '79');
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
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
          repository.getExistencias(),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 401)
                .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue),
          ),
        );
      },
    );
  });
}
