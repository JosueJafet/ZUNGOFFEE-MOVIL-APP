import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/constants/app_role.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:zungofee_mobile/features/clientes/presentation/screens/clientes_list_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;
}

/// Responde con la próxima función de [_responses] en cada llamada (se
/// queda en la última una vez agotadas) — mismo patrón de
/// `proveedores_list_screen_test.dart` para simular error -> reintentar ->
/// data.
class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository(this._responses)
    : super(ClienteRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<List<Cliente>> Function()> _responses;
  int callCount = 0;

  @override
  Future<List<Cliente>> getClientes() {
    final index = callCount < _responses.length
        ? callCount
        : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }
}

Perfil _perfilConRol(String rol) => Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: rol,
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

const _clienteDeEjemplo = Cliente(
  id: 1,
  tenantId: 5,
  nombre: 'Cafeteria El Buen Cafe',
  lugar: 'Tegucigalpa',
  telefono: '9999-9999',
  estado: true,
);

Widget _wrap({
  required PerfilRepository perfilRepository,
  required ClienteRepository clienteRepository,
  required AuthRepository authRepository,
  VoidCallback? onCrear,
  void Function(Cliente)? onEditar,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      clienteRepositoryProvider.overrideWithValue(clienteRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: ClientesListScreen(
        onCrear: onCrear ?? () {},
        onEditar: onEditar ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('ClientesListScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets(
      'admin_bodega: los items son tocables y llaman onEditar con el cliente',
      (tester) async {
        Cliente? editado;

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            clienteRepository: _FakeClienteRepository([
              () async => [_clienteDeEjemplo],
            ]),
            authRepository: authRepository,
            onEditar: (cliente) => editado = cliente,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cafeteria El Buen Cafe'), findsOneWidget);
        expect(find.text('Tegucigalpa · 9999-9999'), findsOneWidget);

        await tester.tap(find.text('Cafeteria El Buen Cafe'));
        await tester.pumpAndSettle();

        expect(editado, _clienteDeEjemplo);
      },
    );

    testWidgets('empleado: los items no son tocables', (tester) async {
      var editadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository([
            () async => [_clienteDeEjemplo],
          ]),
          authRepository: authRepository,
          onEditar: (_) => editadoCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.onTap, isNull);

      await tester.tap(find.text('Cafeteria El Buen Cafe'));
      await tester.pumpAndSettle();

      expect(editadoCallCount, 0);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin clientes"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository([() async => []]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay clientes registrados'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository([
            () async => throw const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('un NetworkException muestra su mensaje', (tester) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir los clientes tras un error', (
      tester,
    ) async {
      final repository = _FakeClienteRepository([
        () async => throw const ApiException(
          statusCode: 500,
          message: 'Error del servidor',
        ),
        () async => [_clienteDeEjemplo],
      ]);

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: repository,
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Cafeteria El Buen Cafe'), findsOneWidget);
      expect(repository.callCount, 2);
    });

    testWidgets('FAB de crear llama onCrear', (tester) async {
      var crearCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository([
            () async => [_clienteDeEjemplo],
          ]),
          authRepository: authRepository,
          onCrear: () => crearCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Agregar cliente'));
      await tester.pumpAndSettle();

      expect(crearCallCount, 1);
    });
  });
}