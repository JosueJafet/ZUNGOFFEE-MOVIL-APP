import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/cliente_tipo.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:zungofee_mobile/features/clientes/presentation/screens/cliente_form_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
    : super(CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [],
  variedadesCafe: [],
  nivelesAltura: [],
  estadosCafe: [],
  clientesTipo: [
    ClienteTipo(id: 1, nombre: 'persona_natural'),
    ClienteTipo(id: 2, nombre: 'cafeteria_pequena'),
  ],
);

class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository({this.crearError, this.actualizarError})
    : super(ClienteRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  final Object? actualizarError;

  int crearCallCount = 0;
  int actualizarCallCount = 0;
  Map<String, dynamic>? ultimoCrear;
  Map<String, dynamic>? ultimoActualizar;

  static const _clienteGuardado = Cliente(
    id: 99,
    tenantId: 5,
    nombre: 'Nombre Guardado',
    estado: true,
  );

  @override
  Future<Cliente> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    crearCallCount++;
    ultimoCrear = {
      'nombre': nombre,
      'tipoId': tipoId,
      'lugar': lugar,
      'telefono': telefono,
    };
    if (crearError != null) throw crearError!;
    return _clienteGuardado;
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
    ultimoActualizar = {
      'id': id,
      'nombre': nombre,
      'tipoId': tipoId,
      'lugar': lugar,
      'telefono': telefono,
    };
    if (actualizarError != null) throw actualizarError!;
    return _clienteGuardado;
  }

  @override
  Future<List<Cliente>> getClientes() async => [];
}

const _clienteExistente = Cliente(
  id: 1,
  tenantId: 5,
  nombre: 'Cafeteria El Buen Cafe',
  tipoId: 2,
  lugar: 'Tegucigalpa',
  telefono: '9999-9999',
  estado: true,
);

Widget _wrap(
  ClienteRepository repository, {
  Cliente? clienteExistente,
  VoidCallback? onGuardado,
  Catalogos catalogos = _catalogosDeEjemplo,
}) {
  return ProviderScope(
    overrides: [
      clienteRepositoryProvider.overrideWithValue(repository),
      catalogosRepositoryProvider.overrideWithValue(
        _FakeCatalogosRepository(catalogos),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: ClienteFormScreen(
        clienteExistente: clienteExistente,
        onGuardado: onGuardado ?? () {},
      ),
    ),
  );
}

void main() {
  group('ClienteFormScreen', () {
    testWidgets('modo crear: no envía el submit si el nombre está vacío', (
      tester,
    ) async {
      final repository = _FakeClienteRepository();

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.crearCallCount, 0);
      expect(find.text('Ingresa el nombre'), findsOneWidget);
    });

    testWidgets(
      'modo crear: éxito llama crear() con los valores ingresados y llama '
      'onGuardado',
      (tester) async {
        final repository = _FakeClienteRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Cafeteria El Buen Cafe',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Lugar'),
          'Tegucigalpa',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.crearCallCount, 1);
        expect(repository.ultimoCrear?['nombre'], 'Cafeteria El Buen Cafe');
        expect(repository.ultimoCrear?['lugar'], 'Tegucigalpa');
        expect(repository.ultimoCrear?['tipoId'], isNull);
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('modo crear: el selector de tipo de cliente arma el body', (
      tester,
    ) async {
      final repository = _FakeClienteRepository();

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'),
        'Cafeteria El Buen Cafe',
      );
      await tester.tap(find.widgetWithText(DropdownButtonFormField<int?>, 'Sin especificar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('cafeteria_pequena').last);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.ultimoCrear?['tipoId'], 2);
    });

    testWidgets('modo editar: los campos llegan prellenados', (tester) async {
      final repository = _FakeClienteRepository();

      await tester.pumpWidget(
        _wrap(repository, clienteExistente: _clienteExistente),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cafeteria El Buen Cafe'), findsOneWidget);
      expect(find.text('Tegucigalpa'), findsOneWidget);
      expect(find.text('9999-9999'), findsOneWidget);
      expect(find.text('cafeteria_pequena'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Editar cliente'), findsOneWidget);
    });

    testWidgets(
      'modo editar: éxito llama actualizar(id, ...) y llama onGuardado',
      (tester) async {
        final repository = _FakeClienteRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            clienteExistente: _clienteExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Nombre Editado',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.actualizarCallCount, 1);
        expect(repository.ultimoActualizar?['id'], 1);
        expect(repository.ultimoActualizar?['nombre'], 'Nombre Editado');
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('un error de la API se muestra inline y no llama onGuardado', (
      tester,
    ) async {
      final repository = _FakeClienteRepository(
        crearError: const ApiException(
          statusCode: 400,
          message: 'El nombre ya está registrado',
        ),
      );
      var guardadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(repository, onGuardado: () => guardadoCallCount++),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'),
        'Cafeteria El Buen Cafe',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('El nombre ya está registrado'), findsOneWidget);
      expect(guardadoCallCount, 0);
    });

    testWidgets(
      'modo editar: un error de la API se muestra inline y no llama '
      'onGuardado',
      (tester) async {
        final repository = _FakeClienteRepository(
          actualizarError: const ApiException(
            statusCode: 403,
            message: 'Forbidden resource',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            clienteExistente: _clienteExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('Forbidden resource'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );
  });
}