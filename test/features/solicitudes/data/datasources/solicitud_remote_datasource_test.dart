import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';

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

SolicitudRemoteDataSource _dataSourceWithAdapter(FakeHttpClientAdapter adapter) {
  return SolicitudRemoteDataSource(
    ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
  );
}

void main() {
  group('SolicitudRemoteDataSource', () {
    test('getSolicitudes llama GET /solicitudes y decodifica el array', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_solicitudJson(), _solicitudJson(id: 4)], 200),
      );
      final dataSource = _dataSourceWithAdapter(adapter);

      final dtos = await dataSource.getSolicitudes();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/solicitudes');
      expect(dtos, hasLength(2));
      expect(dtos.first.id, 3);
      expect(dtos.last.id, 4);
    });

    test(
      'rechazar llama PATCH /solicitudes/:id/rechazar sin body y '
      'descarta la respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({...(_solicitudJson()), 'estado_id': 3}, 200),
        );
        final dataSource = _dataSourceWithAdapter(adapter);

        await dataSource.rechazar(3);

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/solicitudes/3/rechazar');
        expect(adapter.lastRequest?.data, isNull);
      },
    );
  });
}
