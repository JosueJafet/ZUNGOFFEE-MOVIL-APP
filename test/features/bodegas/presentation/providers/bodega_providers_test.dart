import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';

/// El datasource nunca se ejercita realmente: `getBodegas()` se
/// sobreescribe directamente, así que el `ApiClient` de abajo solo existe
/// para satisfacer el constructor de [BodegaRepository].
class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository(this._bodegas)
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Bodega> _bodegas;

  @override
  Future<List<Bodega>> getBodegas() async => _bodegas;
}

void main() {
  group('bodegasProvider', () {
    test('resuelve a la List<Bodega> del repository', () async {
      final expected = [
        Bodega(
          id: 5,
          nombre: 'Bodega de Prueba',
          estadoId: 1,
          fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          bodegaRepositoryProvider.overrideWithValue(
            _FakeBodegaRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final bodegas = await container.read(bodegasProvider.future);

      expect(bodegas, expected);
    });
  });
}
