import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// El datasource nunca se ejercita realmente: `getProveedores()` se
/// sobreescribe directamente, así que el `ApiClient` de abajo solo existe
/// para satisfacer el constructor de [ProveedorRepository].
class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository(this._proveedores)
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Proveedor> _proveedores;

  @override
  Future<List<Proveedor>> getProveedores() async => _proveedores;
}

void main() {
  group('proveedoresProvider', () {
    test('resuelve a la List<Proveedor> del repository', () async {
      final expected = [
        const Proveedor(
          id: 12,
          tenantId: 5,
          nombre: 'Don Chepe Martinez',
          sexo: 'M',
          lugar: 'Marcala',
          finca: 'Finca El Roble',
          tipoId: 1,
          telefono: '9999-9999',
          estado: true,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          proveedorRepositoryProvider.overrideWithValue(
            _FakeProveedorRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final proveedores = await container.read(proveedoresProvider.future);

      expect(proveedores, expected);
    });
  });
}
