import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// El datasource nunca se ejercita realmente: `getExistencias()` se
/// sobreescribe directamente, así que el `ApiClient` de abajo solo existe
/// para satisfacer el constructor de [LotesRepository].
class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._lotes)
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Lote> _lotes;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _lotes;
}

void main() {
  group('existenciasProvider', () {
    test('resuelve a la List<Lote> del repository', () async {
      final expected = [
        const Lote(
          id: '78',
          saldo: 10,
          cantidadInicial: 10,
          estadoCafeNombre: 'pergamino_seco',
          unidadMedidaId: 2,
          variedadNombre: 'Catuai',
          nivelAlturaNombre: 'Estandar',
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          lotesRepositoryProvider.overrideWithValue(
            _FakeLotesRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final lotes = await container.read(existenciasProvider.future);

      expect(lotes, expected);
    });
  });
}
