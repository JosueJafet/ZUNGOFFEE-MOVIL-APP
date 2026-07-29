import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_form_controller.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/models/solicitud.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_providers.dart';

class _FakeSolicitudRepository extends SolicitudRepository {
  _FakeSolicitudRepository()
    : super(SolicitudRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  int getSolicitudesCallCount = 0;

  @override
  Future<List<Solicitud>> getSolicitudes() async {
    getSolicitudesCallCount++;
    return [];
  }
}

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository({this.onboardingError, this.actualizarNombreError})
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? onboardingError;
  final Object? actualizarNombreError;
  int onboardingCallCount = 0;
  int actualizarNombreCallCount = 0;
  int getBodegasCallCount = 0;
  int? solicitudIdRecibido;

  @override
  Future<List<Bodega>> getBodegas() async {
    getBodegasCallCount++;
    return [_bodega];
  }

  @override
  Future<Bodega> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    onboardingCallCount++;
    solicitudIdRecibido = solicitudId;
    if (onboardingError != null) throw onboardingError!;
    return _bodega;
  }

  @override
  Future<Bodega> actualizarNombre(int id, {required String nombre}) async {
    actualizarNombreCallCount++;
    if (actualizarNombreError != null) throw actualizarNombreError!;
    return _bodega;
  }
}

void main() {
  group('BodegaFormController', () {
    test('crear exitoso: loading -> data, e invalida bodegasProvider', () async {
      final repository = _FakeBodegaRepository();
      final container = ProviderContainer(
        overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 1);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(bodegaFormControllerProvider.notifier)
          .crear(
            nombreBodega: 'Bodega Nueva',
            emailAdmin: 'admin@bodeganueva.com',
            passwordAdmin: 'password123',
            nombreAdmin: 'Admin Nuevo',
          );

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(repository.onboardingCallCount, 1);
      expect(repository.solicitudIdRecibido, isNull);

      await container.read(bodegasProvider.future);
      expect(repository.getBodegasCallCount, 2);
    });

    test(
      'crear con solicitudId lo propaga al repository e invalida '
      'solicitudesProvider',
      () async {
        final repository = _FakeBodegaRepository();
        final solicitudRepository = _FakeSolicitudRepository();
        final container = ProviderContainer(
          overrides: [
            bodegaRepositoryProvider.overrideWithValue(repository),
            solicitudRepositoryProvider.overrideWithValue(solicitudRepository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(solicitudesProvider.future);
        expect(solicitudRepository.getSolicitudesCallCount, 1);

        await container
            .read(bodegaFormControllerProvider.notifier)
            .crear(
              nombreBodega: 'Bodega Nueva',
              emailAdmin: 'admin@bodeganueva.com',
              passwordAdmin: 'password123',
              nombreAdmin: 'Admin Nuevo',
              solicitudId: 123,
            );

        expect(repository.solicitudIdRecibido, 123);

        await container.read(solicitudesProvider.future);
        expect(solicitudRepository.getSolicitudesCallCount, 2);
      },
    );

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 500, message: 'Error al crear');
      final container = ProviderContainer(
        overrides: [
          bodegaRepositoryProvider.overrideWithValue(
            _FakeBodegaRepository(onboardingError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(bodegaFormControllerProvider.notifier)
          .crear(
            nombreBodega: 'Bodega Nueva',
            emailAdmin: 'admin@bodeganueva.com',
            passwordAdmin: 'password123',
            nombreAdmin: 'Admin Nuevo',
          );

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });

    test(
      'actualizarNombre exitoso: loading -> data, e invalida bodegasProvider',
      () async {
        final repository = _FakeBodegaRepository();
        final container = ProviderContainer(
          overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        await container.read(bodegasProvider.future);
        expect(repository.getBodegasCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(bodegaFormControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(bodegaFormControllerProvider.notifier)
            .actualizarNombre(5, nombre: 'Nuevo nombre');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.actualizarNombreCallCount, 1);

        await container.read(bodegasProvider.future);
        expect(repository.getBodegasCallCount, 2);
      },
    );

    test('actualizarNombre con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          bodegaRepositoryProvider.overrideWithValue(
            _FakeBodegaRepository(actualizarNombreError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(bodegaFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(bodegaFormControllerProvider.notifier)
          .actualizarNombre(5, nombre: 'Otro nombre');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
