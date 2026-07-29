import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';

Map<String, dynamic> _solicitudJson({int id = 3}) {
  return {
    'id': id,
    'nombre_bodega': 'Bodega Mertens',
    'nombre_contacto': 'Martin Mertens',
    'email': 'mertens@gmail.com',
    'telefono': '+504 99887766',
    'mensaje': '3 empleados.',
    'estado_id': 1,
    'tenant_creado_id': null,
    'fecha_creacion': '2026-07-24T05:16:35.020Z',
  };
}

SolicitudRepository _repositoryWithAdapter(FakeHttpClientAdapter adapter) {
  final apiClient = ApiClient(
    FakeSessionTokenProvider('token-123'),
    dio: dioWithAdapter(adapter),
  );
  return SolicitudRepository(SolicitudRemoteDataSource(apiClient));
}

void main() {
  group('SolicitudRepository', () {
    test('getSolicitudes mapea un 200 a List<Solicitud>', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter(
          (options) => jsonResponse([_solicitudJson(), _solicitudJson(id: 4)], 200),
        ),
      );

      final solicitudes = await repository.getSolicitudes();

      expect(solicitudes, hasLength(2));
      expect(solicitudes.first.id, 3);
      expect(solicitudes.last.id, 4);
    });

    test('rechazar no lanza con una respuesta 200 exitosa', () async {
      final repository = _repositoryWithAdapter(
        FakeHttpClientAdapter((options) => jsonResponse(_solicitudJson(), 200)),
      );

      await repository.rechazar(3);
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
          repository.getSolicitudes(),
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
