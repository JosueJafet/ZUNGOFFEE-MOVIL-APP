import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';

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

void main() {
  group('ComprasRemoteDataSource', () {
    test(
      'crear llama POST /compras con proveedorId, metodoPagoId y lineas',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_compraJson(), 201),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dto = await dataSource.crear(
          proveedorId: 12,
          metodoPagoId: 1,
          lineas: const [
            LineaCompraInput(
              estadoCafeId: 3,
              variedadId: 1,
              alturaId: 1,
              humedad: 11.5,
              cantidad: 10,
              costoUnitario: 120,
            ),
          ],
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/compras');
        expect(adapter.lastRequest?.data, {
          'proveedorId': 12,
          'metodoPagoId': 1,
          'lineas': [
            {
              'estadoCafeId': 3,
              'variedadId': 1,
              'alturaId': 1,
              'humedad': 11.5,
              'cantidad': 10.0,
              'costoUnitario': 120.0,
            },
          ],
        });
        expect(dto.id, 45);
      },
    );

    test(
      'crear sin metodoPagoId no manda esa clave en el body',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_compraJson(), 201),
        );
        final dataSource = ComprasRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        await dataSource.crear(
          proveedorId: 12,
          lineas: const [
            LineaCompraInput(
              estadoCafeId: 3,
              variedadId: 1,
              alturaId: 1,
              humedad: 11.5,
              cantidad: 10,
              costoUnitario: 120,
            ),
          ],
        );

        final body = adapter.lastRequest?.data as Map<String, dynamic>;
        expect(body.containsKey('metodoPagoId'), isFalse);
      },
    );

    test('crear con varias líneas las manda todas en el array', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_compraJson(), 201),
      );
      final dataSource = ComprasRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        proveedorId: 12,
        lineas: const [
          LineaCompraInput(
            estadoCafeId: 1,
            variedadId: 1,
            alturaId: 1,
            humedad: 12,
            cantidad: 5,
            costoUnitario: 100,
          ),
          LineaCompraInput(
            estadoCafeId: 2,
            variedadId: 2,
            alturaId: 1,
            humedad: 30,
            cantidad: 8,
            costoUnitario: 80,
          ),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body['lineas'], hasLength(2));
    });
  });
}
