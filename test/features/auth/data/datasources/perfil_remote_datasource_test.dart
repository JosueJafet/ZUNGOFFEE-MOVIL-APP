import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';

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

void main() {
  group('PerfilRemoteDataSource', () {
    test('llama GET /perfil y decodifica la respuesta a PerfilDto', () async {
      final adapter = _FakeHttpClientAdapter(
        (options) => _jsonResponse({
          'id': 7,
          'nombre': 'Juan Pérez',
          'estado': true,
          'fecha_creacion': '2026-01-15T10:30:00.000Z',
          'roles': {'nombre': 'empleado'},
          'tenants': {'id': 3, 'nombre': 'Bodega Central'},
        }, 200),
      );
      final apiClient = ApiClient(
        _FakeSessionTokenProvider('token-123'),
        dio: _dioWithAdapter(adapter),
      );
      final dataSource = PerfilRemoteDataSource(apiClient);

      final dto = await dataSource.getPerfil();

      expect(adapter.lastRequest?.path, '/perfil');
      expect(dto.id, 7);
      expect(dto.nombre, 'Juan Pérez');
      expect(dto.roles.nombre, 'empleado');
      expect(dto.tenants.id, 3);
      expect(dto.tenants.nombre, 'Bodega Central');
    });
  });
}
