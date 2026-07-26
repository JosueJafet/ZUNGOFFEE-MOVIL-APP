import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_http_client_adapter.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';

void main() {
  group('PerfilRemoteDataSource', () {
    test('llama GET /perfil y decodifica la respuesta a PerfilDto', () async {
      final adapter = FakeHttpClientAdapter(
        (options) => jsonResponse({
          'id': 7,
          'nombre': 'Juan Pérez',
          'estado': true,
          'fecha_creacion': '2026-01-15T10:30:00.000Z',
          'roles': {'nombre': 'empleado'},
          'tenants': {'id': 3, 'nombre': 'Bodega Central'},
        }, 200),
      );
      final apiClient = ApiClient(
        FakeSessionTokenProvider('token-123'),
        dio: dioWithAdapter(adapter),
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

    test(
      'actualizar llama PATCH /perfil con { nombre } sin parsear el '
      'cuerpo de la respuesta',
      () async {
        final adapter = FakeHttpClientAdapter(
          (options) => jsonResponse({'cualquierCosa': true}, 200),
        );
        final apiClient = ApiClient(
          FakeSessionTokenProvider('token-123'),
          dio: dioWithAdapter(adapter),
        );
        final dataSource = PerfilRemoteDataSource(apiClient);

        await dataSource.actualizar('Nuevo Nombre');

        expect(adapter.lastRequest?.method, 'PATCH');
        expect(adapter.lastRequest?.path, '/perfil');
        expect(adapter.lastRequest?.data, {'nombre': 'Nuevo Nombre'});
      },
    );
  });
}
