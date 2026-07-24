import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/metodo_pago.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
    : super(CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;
  int callCount = 0;

  @override
  Future<Catalogos> getCatalogos() async {
    callCount++;
    return _catalogos;
  }
}

void main() {
  group('catalogosProvider', () {
    test('resuelve a los Catalogos del repository y se cachea', () async {
      const expected = Catalogos(
        metodosPago: [MetodoPago(id: 1, nombre: 'Efectivo')],
        variedadesCafe: [],
        nivelesAltura: [],
        estadosCafe: [],
      );
      final repository = _FakeCatalogosRepository(expected);

      final container = ProviderContainer(
        overrides: [
          catalogosRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final catalogos = await container.read(catalogosProvider.future);
      // Segunda lectura: no debe volver a llamar al repository.
      await container.read(catalogosProvider.future);

      expect(catalogos, expected);
      expect(repository.callCount, 1);
    });
  });
}
