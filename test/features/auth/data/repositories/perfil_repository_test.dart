import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';

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

PerfilRepository _repositoryWithAdapter(HttpClientAdapter adapter) {
  final apiClient = ApiClient(
    _FakeSessionTokenProvider('token-123'),
    dio: _dioWithAdapter(adapter),
  );
  return PerfilRepository(PerfilRemoteDataSource(apiClient));
}

void main() {
  group('PerfilRepository', () {
    test('un 200 se mapea correctamente a Perfil', () async {
      final repository = _repositoryWithAdapter(
        _FakeHttpClientAdapter(
          (options) => _jsonResponse({
            'id': 7,
            'nombre': 'Juan Pérez',
            'estado': true,
            'fecha_creacion': '2026-01-15T10:30:00.000Z',
            'roles': {'nombre': 'empleado'},
            'tenants': {'id': 3, 'nombre': 'Bodega Central'},
          }, 200),
        ),
      );

      final perfil = await repository.getPerfil();

      expect(perfil.id, 7);
      expect(perfil.nombre, 'Juan Pérez');
      expect(perfil.activo, true);
      expect(
        perfil.fechaCreacion,
        DateTime.parse('2026-01-15T10:30:00.000Z'),
      );
      expect(perfil.rol, 'empleado');
      expect(perfil.tenantId, 3);
      expect(perfil.tenantNombre, 'Bodega Central');
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
          repository.getPerfil(),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 401)
                .having((e) => e.message, 'message', 'Unauthorized')
                .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue),
          ),
        );
      },
    );
  });
}
