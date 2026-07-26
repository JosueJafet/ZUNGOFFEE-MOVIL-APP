import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_editar_controller.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _perfil = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository({this.actualizarError})
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? actualizarError;
  int actualizarCallCount = 0;
  int getPerfilCallCount = 0;

  @override
  Future<void> actualizar(String nombre) async {
    actualizarCallCount++;
    if (actualizarError != null) throw actualizarError!;
  }

  @override
  Future<Perfil> getPerfil() async {
    getPerfilCallCount++;
    return _perfil;
  }
}

void main() {
  group('PerfilEditarController', () {
    test(
      'actualizar exitoso: loading -> data, e invalida perfilProvider',
      () async {
        final repository = _FakePerfilRepository();
        final container = ProviderContainer(
          overrides: [perfilRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        await container.read(perfilProvider.future);
        expect(repository.getPerfilCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(perfilEditarControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(perfilEditarControllerProvider.notifier)
            .actualizar('Nuevo Nombre');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.actualizarCallCount, 1);

        await container.read(perfilProvider.future);
        expect(repository.getPerfilCallCount, 2);
      },
    );

    test('actualizar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 400, message: 'Nombre inválido');
      final container = ProviderContainer(
        overrides: [
          perfilRepositoryProvider.overrideWithValue(
            _FakePerfilRepository(actualizarError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(perfilEditarControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(perfilEditarControllerProvider.notifier)
          .actualizar('Nuevo Nombre');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
