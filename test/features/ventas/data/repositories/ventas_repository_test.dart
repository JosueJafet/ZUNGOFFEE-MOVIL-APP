import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';

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

Map<String, dynamic> _ventaHistorialJson() {
  return {
    'id': 30,
    'fecha': '2026-08-01T00:00:00.000Z',
    'total': '750.00',
    'clientes': {'id': 7, 'nombre': 'Cafeteria El Buen Cafe'},
  };
}

const _lineaDeEjemplo = LineaVentaInput(
  loteId: '78',
  cantidad: 5,
  precioUnitario: 150,
);

VentasRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return VentasRepository(VentasRemoteDataSource(apiClient));
}

void main() {
  group('VentasRepository', () {
    test('crear mapea un 201 a Venta', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_ventaJson(), 201)),
      );

      final venta = await repository.crear(
        clienteId: 7,
        metodoPagoId: 1,
        lineas: const [_lineaDeEjemplo],
      );

      expect(venta.id, 30);
      expect(venta.clienteId, 7);
      expect(venta.total, 750.00);
      expect(venta.anulada, false);
    });

    test(
      'saldo insuficiente (400) se relanza como ApiException con el '
      'mensaje de la API',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 400,
              'message': 'Saldo insuficiente en lote 78',
              'error': 'Bad Request',
            }, 400),
          ),
        );

        await expectLater(
          repository.crear(clienteId: 7, lineas: const [_lineaDeEjemplo]),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.isBadRequest, 'isBadRequest', isTrue)
                .having(
                  (e) => e.message,
                  'message',
                  'Saldo insuficiente en lote 78',
                ),
          ),
        );
      },
    );

    test('listar mapea el array de la API a List<VentaHistorial>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_ventaHistorialJson()], 200),
        ),
      );

      final ventas = await repository.listar();

      expect(ventas, hasLength(1));
      expect(ventas.single.id, 30);
      expect(ventas.single.clienteNombre, 'Cafeteria El Buen Cafe');
    });

    test('anular propaga un ApiException tal cual', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'statusCode': 400,
            'message': 'La venta ya estaba anulada',
            'error': 'Bad Request',
          }, 400),
        ),
      );

      await expectLater(
        repository.anular(30),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'La venta ya estaba anulada',
          ),
        ),
      );
    });

    test('getResumen mapea el groupBy de la API a List<ResumenDiario>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([
            {
              '_sum': {'total': '5000.00'},
              'fecha': '2026-07-21T00:00:00.000Z',
            },
          ], 200),
        ),
      );

      final resumen = await repository.getResumen();

      expect(resumen, hasLength(1));
      expect(resumen.single.total, 5000.00);
    });
  });
}