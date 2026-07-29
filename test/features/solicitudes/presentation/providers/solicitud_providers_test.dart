import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/models/solicitud.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_providers.dart';

class _FakeSolicitudRepository extends SolicitudRepository {
  _FakeSolicitudRepository(this._solicitudes)
    : super(SolicitudRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Solicitud> _solicitudes;

  @override
  Future<List<Solicitud>> getSolicitudes() async => _solicitudes;
}

void main() {
  group('solicitudesProvider', () {
    test('resuelve a la List<Solicitud> del repository', () async {
      final expected = [
        Solicitud(
          id: 3,
          nombreBodega: 'Bodega Mertens',
          nombreContacto: 'Martin Mertens',
          email: 'mertens@gmail.com',
          telefono: '+504 99887766',
          estadoId: 1,
          fechaCreacion: DateTime.parse('2026-07-24T05:16:35.020Z'),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          solicitudRepositoryProvider.overrideWithValue(
            _FakeSolicitudRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final solicitudes = await container.read(solicitudesProvider.future);

      expect(solicitudes, expected);
    });
  });
}
