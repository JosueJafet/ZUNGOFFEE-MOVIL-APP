import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';

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

Map<String, dynamic> _ventaJson() {
  return {
    'id': 30,
    'tenant_id': 5,
    'cliente_id': 7,
    'usuario_id': 3,
    'total': '750.00',
    'anulada': false,
  };
}

void main() {
  group('VentasRemoteDataSource', () {
    test(
      'crear llama POST /ventas con clienteId, metodoPagoId y lineas',
      () async {
        final adapter = _FakeHttpClientAdapter(
          (options) => _jsonResponse(_ventaJson(), 201),
        );
        final dataSource = VentasRemoteDataSource(
          ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
        );

        final dto = await dataSource.crear(
          clienteId: 7,
          metodoPagoId: 1,
          lineas: const [
            LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
          ],
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/ventas');
        expect(adapter.lastRequest?.data, {
          'clienteId': 7,
          'metodoPagoId': 1,
          'lineas': [
            {'loteId': '78', 'cantidad': 5.0, 'precioUnitario': 150.0},
          ],
        });
        expect(dto.id, 30);
      },
    );

    test('crear sin metodoPagoId no manda esa clave en el body', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_ventaJson(), 201),
      );
      final dataSource = VentasRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        clienteId: 7,
        lineas: const [
          LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body.containsKey('metodoPagoId'), isFalse);
    });

    test('crear con varias líneas las manda todas en el array', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse(_ventaJson(), 201),
      );
      final dataSource = VentasRemoteDataSource(
        ApiClient(_FakeSessionTokenProvider('token-123'), dio: _dioWithAdapter(adapter)),
      );

      await dataSource.crear(
        clienteId: 7,
        lineas: const [
          LineaVentaInput(loteId: '78', cantidad: 5, precioUnitario: 150),
          LineaVentaInput(loteId: '80', cantidad: 2, precioUnitario: 200),
        ],
      );

      final body = adapter.lastRequest?.data as Map<String, dynamic>;
      expect(body['lineas'], hasLength(2));
    });
  });
}