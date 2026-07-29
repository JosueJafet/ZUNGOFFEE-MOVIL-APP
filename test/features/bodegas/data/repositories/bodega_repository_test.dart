import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';

Map<String, dynamic> _bodegaJson({int id = 5, String nombre = 'Bodega de Prueba'}) {
  return {
    'id': id,
    'nombre': nombre,
    'estado_id': 1,
    'fecha_registro': '2026-07-21T00:00:00.000Z',
    'estados_tenant': {'nombre': 'activo'},
  };
}

BodegaRepository _repositoryWithAdapter(FakeHttpClientAdapter adapter) {
  final apiClient = ApiClient(
    FakeSessionTokenProvider('token-123'),
    dio: dioWithAdapter(adapter),
  );
  return BodegaRepository(BodegaRemoteDataSource(apiClient));
}

void main() {
  group('BodegaRepository', () {
    test('getBodegas mapea un 200 a List<Bodega>', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter(
          (options) => jsonResponse([_bodegaJson(), _bodegaJson(id: 6)], 200),
        ),
      );

      final bodegas = await repository.getBodegas();

      expect(bodegas, hasLength(2));
      expect(bodegas.first.id, 5);
      expect(bodegas.last.id, 6);
    });

    test('onboarding mapea un 201 a Bodega', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter(
          (options) => jsonResponse({
            'tenant': _bodegaJson(id: 25, nombre: 'Bodega Nueva'),
            'usuario': {'id': 35},
          }, 201),
        ),
      );

      final bodega = await repository.onboarding(
        nombreBodega: 'Bodega Nueva',
        emailAdmin: 'admin@bodeganueva.com',
        passwordAdmin: 'password123',
        nombreAdmin: 'Admin Nuevo',
      );

      expect(bodega.id, 25);
      expect(bodega.nombre, 'Bodega Nueva');
    });

    test('actualizarNombre mapea un 200 a Bodega', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter(
          (options) => jsonResponse(_bodegaJson(nombre: 'Nuevo nombre'), 200),
        ),
      );

      final bodega = await repository.actualizarNombre(5, nombre: 'Nuevo nombre');

      expect(bodega.nombre, 'Nuevo nombre');
    });

    test('suspender/activar no lanzan con una respuesta 200 exitosa', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter((options) => jsonResponse(_bodegaJson(), 200)),
      );

      await repository.suspender(5);
      await repository.activar(5);
    });

    test(
      'un error de la API se relanza como ApiException sin envolver ni '
      'perder información',
      () async {
        final repository = _repositoryWithAdapter(
          FakeHttpClientAdapter(
            (options) => jsonResponse({
              'statusCode': 403,
              'message': 'Forbidden resource',
              'error': 'Forbidden',
            }, 403),
          ),
        );

        await expectLater(
          repository.getBodegas(),
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
