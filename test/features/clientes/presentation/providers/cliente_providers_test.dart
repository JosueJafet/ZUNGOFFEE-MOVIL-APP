import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// El datasource nunca se ejercita realmente: `getClientes()` se
/// sobreescribe directamente, así que el `ApiClient` de abajo solo existe
/// para satisfacer el constructor de [ClienteRepository].
class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository(this._clientes)
    : super(ClienteRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Cliente> _clientes;

  @override
  Future<List<Cliente>> getClientes() async => _clientes;
}

void main() {
  group('clientesProvider', () {
    test('resuelve a la List<Cliente> del repository', () async {
      final expected = [
        const Cliente(
          id: 1,
          tenantId: 5,
          nombre: 'Cafeteria El Buen Cafe',
          tipoId: 2,
          lugar: 'Tegucigalpa',
          estado: true,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          clienteRepositoryProvider.overrideWithValue(
            _FakeClienteRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final clientes = await container.read(clientesProvider.future);

      expect(clientes, expected);
    });
  });
}