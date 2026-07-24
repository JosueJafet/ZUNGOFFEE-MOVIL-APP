import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';

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

Map<String, dynamic> _compraJson() {
  return {
    'id': 45,
    'tenant_id': 5,
    'proveedor_id': 12,
    'usuario_id': 3,
    'fecha': '2026-08-01T00:00:00.000Z',
    'total': '1200.00',
    'anulada': false,
  };
}

const _lineaDeEjemplo = LineaCompraInput(
  estadoCafeId: 3,
  variedadId: 1,
  alturaId: 1,
  humedad: 11.5,
  cantidad: 10,
  costoUnitario: 120,
);

ComprasRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return ComprasRepository(ComprasRemoteDataSource(apiClient));
}

void main() {
  group('ComprasRepository', () {
    test('crear mapea un 201 a Compra', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_compraJson(), 201)),
      );

      final compra = await repository.crear(
        proveedorId: 12,
        metodoPagoId: 1,
        lineas: const [_lineaDeEjemplo],
      );

      expect(compra.id, 45);
      expect(compra.proveedorId, 12);
      expect(compra.total, 1200.00);
      expect(compra.anulada, false);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 400,
              'message': 'El proveedor no existe',
              'error': 'Bad Request',
            }, 400),
          ),
        );

        await expectLater(
          repository.crear(proveedorId: 999, lineas: const [_lineaDeEjemplo]),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.isBadRequest, 'isBadRequest', isTrue),
          ),
        );
      },
    );
  });
}
