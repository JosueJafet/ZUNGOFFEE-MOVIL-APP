import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';

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

Map<String, dynamic> _proveedorJson({int id = 12}) {
  return {
    'id': id,
    'tenant_id': 5,
    'nombre': 'Don Chepe Martinez',
    'sexo': 'M',
    'lugar': 'Marcala',
    'finca': 'Finca El Roble',
    'tipo_id': 1,
    'telefono': '9999-9999',
    'estado': true,
  };
}

ProveedorRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return ProveedorRepository(ProveedorRemoteDataSource(apiClient));
}

void main() {
  group('ProveedorRepository', () {
    test('getProveedores mapea un 200 a List<Proveedor>', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse([_proveedorJson(), _proveedorJson(id: 13)], 200),
        ),
      );

      final proveedores = await repository.getProveedores();

      expect(proveedores, hasLength(2));
      expect(proveedores.first.id, 12);
      expect(proveedores.first.nombre, 'Don Chepe Martinez');
      expect(proveedores.last.id, 13);
    });

    test('crear mapea un 201 a Proveedor', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_proveedorJson(), 201)),
      );

      final proveedor = await repository.crear(nombre: 'Don Chepe Martinez');

      expect(proveedor.id, 12);
      expect(proveedor.nombre, 'Don Chepe Martinez');
    });

    test('actualizar mapea un 200 a Proveedor', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter((options) => _jsonResponse(_proveedorJson(), 200)),
      );

      final proveedor = await repository.actualizar(12, telefono: '8888-8888');

      expect(proveedor.id, 12);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          _FakeHttpClientAdapter(
            (options) => _jsonResponse({
              'statusCode': 403,
              'message': 'Forbidden resource',
              'error': 'Forbidden',
            }, 403),
          ),
        );

        await expectLater(
          repository.actualizar(12, nombre: 'Otro Nombre'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 403)
                .having((e) => e.isForbidden, 'isForbidden', isTrue),
          ),
        );
      },
    );
  });
}
