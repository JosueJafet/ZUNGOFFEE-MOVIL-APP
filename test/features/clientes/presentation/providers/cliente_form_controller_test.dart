import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_form_controller.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _cliente = Cliente(
  id: 1,
  tenantId: 5,
  nombre: 'Cafeteria El Buen Cafe',
  estado: true,
);

class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository({this.crearError, this.actualizarError})
    : super(ClienteRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  final Object? actualizarError;
  int crearCallCount = 0;
  int actualizarCallCount = 0;
  int getClientesCallCount = 0;

  @override
  Future<List<Cliente>> getClientes() async {
    getClientesCallCount++;
    return [_cliente];
  }

  @override
  Future<Cliente> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    crearCallCount++;
    if (crearError != null) throw crearError!;
    return _cliente;
  }

  @override
  Future<Cliente> actualizar(
    int id, {
    String? nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    actualizarCallCount++;
    if (actualizarError != null) throw actualizarError!;
    return _cliente;
  }
}

void main() {
  group('ClienteFormController', () {
    test('crear exitoso: loading -> data, e invalida clientesProvider', () async {
      final repository = _FakeClienteRepository();
      final container = ProviderContainer(
        overrides: [clienteRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(clientesProvider.future);
      expect(repository.getClientesCallCount, 1);

      final states = <AsyncValue<void>>[];
      container.listen(clienteFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(clienteFormControllerProvider.notifier)
          .crear(nombre: 'Cafeteria El Buen Cafe');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1], const AsyncData<void>(null));
      expect(repository.crearCallCount, 1);

      await container.read(clientesProvider.future);
      expect(repository.getClientesCallCount, 2);
    });

    test('crear con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 500, message: 'Error al crear');
      final container = ProviderContainer(
        overrides: [
          clienteRepositoryProvider.overrideWithValue(
            _FakeClienteRepository(crearError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(clienteFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(clienteFormControllerProvider.notifier)
          .crear(nombre: 'Cafeteria El Buen Cafe');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });

    test(
      'actualizar exitoso: loading -> data, e invalida clientesProvider',
      () async {
        final repository = _FakeClienteRepository();
        final container = ProviderContainer(
          overrides: [clienteRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        await container.read(clientesProvider.future);
        expect(repository.getClientesCallCount, 1);

        final states = <AsyncValue<void>>[];
        container.listen(clienteFormControllerProvider, (previous, next) {
          states.add(next);
        });

        await container
            .read(clienteFormControllerProvider.notifier)
            .actualizar(1, telefono: '8888-8888');

        expect(states.length, 2);
        expect(states[0].isLoading, isTrue);
        expect(states[1], const AsyncData<void>(null));
        expect(repository.actualizarCallCount, 1);

        await container.read(clientesProvider.future);
        expect(repository.getClientesCallCount, 2);
      },
    );

    test('actualizar con error: loading -> error(ApiException)', () async {
      const error = ApiException(statusCode: 403, message: 'Forbidden resource');
      final container = ProviderContainer(
        overrides: [
          clienteRepositoryProvider.overrideWithValue(
            _FakeClienteRepository(actualizarError: error),
          ),
        ],
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(clienteFormControllerProvider, (previous, next) {
        states.add(next);
      });

      await container
          .read(clienteFormControllerProvider.notifier)
          .actualizar(1, nombre: 'Otro Nombre');

      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasError, isTrue);
      expect(states[1].error, same(error));
    });
  });
}