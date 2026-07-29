import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/models/solicitud.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_providers.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_rechazar_controller.dart';

final _solicitud = Solicitud(
  id: 3,
  nombreBodega: 'Bodega Mertens',
  nombreContacto: 'Martin Mertens',
  email: 'mertens@gmail.com',
  telefono: '+504 99887766',
  estadoId: 1,
  fechaCreacion: DateTime.parse('2026-07-24T05:16:35.020Z'),
);

class _FakeSolicitudRepository extends SolicitudRepository {
  _FakeSolicitudRepository({this.rechazarError})
    : super(SolicitudRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? rechazarError;
  int rechazarCallCount = 0;
  int getSolicitudesCallCount = 0;

  @override
  Future<List<Solicitud>> getSolicitudes() async {
    getSolicitudesCallCount++;
    return [_solicitud];
  }

  @override
  Future<void> rechazar(int id) async {
    rechazarCallCount++;
    if (rechazarError != null) throw rechazarError!;
  }
}

void main() {
  group('SolicitudRechazarController', () {
    test(
      'rechazar exitoso: loading -> data, e invalida solicitudesProvider',
      () async {
        final repository = _FakeSolicitudRepository();
        final container = ProviderContainer(
          overrides: [solicitudRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        await container.read(solicitudesProvider.future);
        expect(repository.getSolicitudesCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(solicitudRechazarControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(solicitudRechazarControllerProvider.notifier)
            .rechazar(3);

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.rechazarCallCount, 1);

        await container.read(solicitudesProvider.future);
        expect(repository.getSolicitudesCallCount, 2);
      },
    );

    test('rechazar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          solicitudRepositoryProvider.overrideWithValue(
            _FakeSolicitudRepository(rechazarError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(solicitudRechazarControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(solicitudRechazarControllerProvider.notifier)
          .rechazar(3);

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
