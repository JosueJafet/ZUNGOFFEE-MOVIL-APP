import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';

Map<String, dynamic> _loteJson({String id = '78'}) {
  return {
    'id': id,
    'saldo': '10.00',
    'cantidad_inicial': '10.00',
    'estados_cafe': {'nombre': 'pergamino_seco', 'unidad_medida_id': 2},
    'variedades_cafe': {'nombre': 'Catuai'},
    'niveles_altura': {'nombre': 'Estandar'},
  };
}

void main() {
  group('LotesRemoteDataSource', () {
    test(
      'getExistencias llama GET /lotes/existencias con page/pageSize y '
      'decodifica el array',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse([_loteJson(), _loteJson(id: '79')], 200),
        );
        final dataSource = LotesRemoteDataSource(
          ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
        );

        final dtos = await dataSource.getExistencias(page: 2, pageSize: 10);

        expect(adapter.lastRequest?.method, 'GET');
        expect(adapter.lastRequest?.path, '/lotes/existencias');
        expect(adapter.lastRequest?.queryParameters, {'page': 2, 'pageSize': 10});
        expect(dtos, hasLength(2));
        expect(dtos.first.id, '78');
        expect(dtos.last.id, '79');
      },
    );

    test('getExistencias usa page 1 y el pageSize por defecto', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse([_loteJson()], 200),
      );
      final dataSource = LotesRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      await dataSource.getExistencias();

      expect(adapter.lastRequest?.queryParameters, {'page': 1, 'pageSize': 20});
    });
  });
}
