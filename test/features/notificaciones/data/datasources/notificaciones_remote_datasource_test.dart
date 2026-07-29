import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';

Map<String, dynamic> _notificacionJson() {
  return {
    'id': '3',
    'titulo': 'Compra registrada',
    'mensaje': 'Se registró una compra de 10 quintales',
    'leida': false,
  };
}

void main() {
  group('NotificacionesRemoteDataSource', () {
    test(
      'listar llama GET /notificaciones con page/pageSize=50 por defecto '
      'y parsea un array plano',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_notificacionJson()], 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/notificaciones');
        expect(adapter.lastRequest?.queryParameters, {'page': 1, 'pageSize': 50});
        expect(dtos, hasLength(1));
        expect(dtos.single.id, '3');
      },
    );

    test('listar respeta page/pageSize explícitos', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_notificacionJson()], 200),
      );
      final dataSource = NotificacionesRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      await dataSource.listar(page: 2, pageSize: 10);

      expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
    });

    test(
      'listar también parsea la respuesta si viene envuelta en un Map '
      '(mismo criterio que Sprint 9, Decisión 5)',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({
            'meta': {'page': 1},
            'algunaClave': [_notificacionJson()],
          }, 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.listar();

        expect(dtos, hasLength(1));
      },
    );

    test(
      'marcarLeida llama PATCH /notificaciones/:id/leida sin parsear el '
      'cuerpo de la respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({'cualquierCosa': true}, 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.marcarLeida('3');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/notificaciones/3/leida');
      },
    );

    test(
      'registrarDispositivo llama POST /notificaciones/dispositivos con '
      '{ token, plataformaId }',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({}, 201),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.registrarDispositivo(
          token: 'fcm-token-abc',
          plataformaId: 2,
        );

        expect(adapter.lastRequest?.method, 'POST');
        expect(adapter.lastRequest?.path, '/notificaciones/dispositivos');
        expect(adapter.lastRequest?.data, {
          'token': 'fcm-token-abc',
          'plataformaId': 2,
        });
      },
    );

    test(
      'desregistrarDispositivo llama DELETE /notificaciones/dispositivos '
      'con { token } en el body',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({}, 200),
        );
        final dataSource = NotificacionesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        await dataSource.desregistrarDispositivo('fcm-token-abc');

        expect(adapter.lastRequest?.method, 'DELETE');
        expect(adapter.lastRequest?.path, '/notificaciones/dispositivos');
        expect(adapter.lastRequest?.data, {'token': 'fcm-token-abc'});
      },
    );
  });
}
