import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_form_controller.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _proveedor = Proveedor(
  id: 12,
  tenantId: 5,
  nombre: 'Don Chepe Martinez',
  estado: true,
);

class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository({this.crearError, this.actualizarError})
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  final Object? actualizarError;
  int crearCallCount = 0;
  int actualizarCallCount = 0;
  int getProveedoresCallCount = 0;

  @override
  Future<List<Proveedor>> getProveedores() async {
    getProveedoresCallCount++;
    return [_proveedor];
  }

  @override
  Future<Proveedor> crear({
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    crearCallCount++;
    if (crearError != null) throw crearError!;
    return _proveedor;
  }

  @override
  Future<Proveedor> actualizar(
    int id, {
    String? nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    actualizarCallCount++;
    if (actualizarError != null) throw actualizarError!;
    return _proveedor;
  }
}

void main() {
  group('ProveedorFormController', () {
    test('crear exitoso: loading -> data, e invalida proveedoresProvider', () async {
      final repository = _FakeProveedorRepository();
      final container = ProviderContainer(
        overrides: [
          proveedorRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(proveedoresProvider.future);
      expect(repository.getProveedoresCallCount, 1);

      final states = <AsyncValue<void>>[];
      container.listen(proveedorFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(proveedorFormControllerProvider.notifier)
          .crear(nombre: 'Don Chepe Martinez');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(repository.crearCallCount, 1);

      await container.read(proveedoresProvider.future);
      expect(repository.getProveedoresCallCount, 2);
    });

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 500, message: 'Error al crear');
      final container = ProviderContainer(
        overrides: [
          proveedorRepositoryProvider.overrideWithValue(
            _FakeProveedorRepository(crearError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(proveedorFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(proveedorFormControllerProvider.notifier)
          .crear(nombre: 'Don Chepe Martinez');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });

    test(
      'actualizar exitoso: loading -> data, e invalida proveedoresProvider',
      () async {
        final repository = _FakeProveedorRepository();
        final container = ProviderContainer(
          overrides: [
            proveedorRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(proveedoresProvider.future);
        expect(repository.getProveedoresCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(proveedorFormControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(proveedorFormControllerProvider.notifier)
            .actualizar(12, telefono: '8888-8888');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.actualizarCallCount, 1);

        await container.read(proveedoresProvider.future);
        expect(repository.getProveedoresCallCount, 2);
      },
    );

    test('actualizar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          proveedorRepositoryProvider.overrideWithValue(
            _FakeProveedorRepository(actualizarError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(proveedorFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(proveedorFormControllerProvider.notifier)
          .actualizar(12, nombre: 'Otro Nombre');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}
