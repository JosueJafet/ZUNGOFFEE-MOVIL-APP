import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_foto_controller.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _perfilSinFoto = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

final _perfilConFoto = _perfilSinFoto.copyWith(
  fotoUrl: 'https://example.test/avatars/7?t=1753660000000',
);

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository({this.subirFotoError, this.eliminarFotoError})
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? subirFotoError;
  final Object? eliminarFotoError;
  int subirFotoCallCount = 0;
  int eliminarFotoCallCount = 0;
  int getPerfilCallCount = 0;
  bool fotoSubida = false;

  @override
  Future<Perfil> subirFoto({
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    subirFotoCallCount++;
    if (subirFotoError != null) throw subirFotoError!;
    fotoSubida = true;
    return _perfilConFoto;
  }

  @override
  Future<Perfil> eliminarFoto() async {
    eliminarFotoCallCount++;
    if (eliminarFotoError != null) throw eliminarFotoError!;
    fotoSubida = false;
    return _perfilSinFoto;
  }

  @override
  Future<Perfil> getPerfil() async {
    getPerfilCallCount++;
    return fotoSubida ? _perfilConFoto : _perfilSinFoto;
  }
}

void main() {
  group('PerfilFotoController', () {
    test(
      'subir exitoso: loading -> data, e invalida perfilProvider',
      () async {
        final repository = _FakePerfilRepository();
        final container = ProviderContainer(
          overrides: [perfilRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        final perfilInicial = await container.read(perfilProvider.future);
        expect(perfilInicial.fotoUrl, isNull);
        expect(repository.getPerfilCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(perfilFotoControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(perfilFotoControllerProvider.notifier)
            .subir(bytes: [1, 2, 3], nombreArchivo: 'foto.jpg');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.subirFotoCallCount, 1);

        final perfilActualizado = await container.read(perfilProvider.future);
        expect(repository.getPerfilCallCount, 2);
        expect(perfilActualizado.fotoUrl, isNotNull);
      },
    );

    test('subir con error: loading -> error(ApiException)', () async {
      const error = ApiException(
        statusCode: 400,
        message: 'Formato de imagen no soportado',
      );
      final container = ProviderContainer(
        overrides: [
          perfilRepositoryProvider.overrideWithValue(
            _FakePerfilRepository(subirFotoError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(perfilFotoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(perfilFotoControllerProvider.notifier)
          .subir(bytes: [1, 2, 3], nombreArchivo: 'foto.gif');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });

    test(
      'eliminar exitoso: loading -> data, e invalida perfilProvider',
      () async {
        final repository = _FakePerfilRepository()..fotoSubida = true;
        final container = ProviderContainer(
          overrides: [perfilRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        final perfilInicial = await container.read(perfilProvider.future);
        expect(perfilInicial.fotoUrl, isNotNull);
        expect(repository.getPerfilCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(perfilFotoControllerProvider, (previous, next) {
          states.add(next);
        });

        await container.read(perfilFotoControllerProvider.notifier).eliminar();

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.eliminarFotoCallCount, 1);

        final perfilActualizado = await container.read(perfilProvider.future);
        expect(repository.getPerfilCallCount, 2);
        expect(perfilActualizado.fotoUrl, isNull);
      },
    );

    test('eliminar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 401, message: 'Unauthorized');
      final container = ProviderContainer(
        overrides: [
          perfilRepositoryProvider.overrideWithValue(
            _FakePerfilRepository(eliminarFotoError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(perfilFotoControllerProvider, (previous, next) {
        states.add(next);
      });

      await container.read(perfilFotoControllerProvider.notifier).eliminar();

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
