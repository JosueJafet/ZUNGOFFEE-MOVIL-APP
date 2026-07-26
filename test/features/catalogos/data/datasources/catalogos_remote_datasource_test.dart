import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';

Map<String, dynamic> _catalogosJson() {
  return {
    'metodosPago': [
      {'id': 1, 'nombre': 'Efectivo'},
    ],
    'variedadesCafe': [
      {'id': 1, 'nombre': 'Catuai'},
    ],
    'nivelesAltura': [
      {'id': 1, 'nombre': 'Estandar', 'msnm_min': 800, 'msnm_max': 1200},
    ],
    'estadosCafe': [
      {'id': 1, 'nombre': 'uva', 'unidad_medida_id': 1},
    ],
    'clientesTipo': [
      {'id': 1, 'nombre': 'persona_natural'},
    ],
  };
}

void main() {
  group('CatalogosRemoteDataSource', () {
    test('getCatalogos llama GET /catalogos y decodifica la respuesta', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse(_catalogosJson(), 200),
      );
      final dataSource = CatalogosRemoteDataSource(
        ApiClient(FakeSessionTokenProvider('token-123'), dio: dioWithAdapter(adapter)),
      );

      final dto = await dataSource.getCatalogos();

      expect(adapter.lastRequest?.method, 'GET');
      expect(adapter.lastRequest?.path, '/catalogos');
      expect(dto.metodosPago.single.nombre, 'Efectivo');
      expect(dto.estadosCafe.single.unidadMedidaId, 1);
    });
  });
}
