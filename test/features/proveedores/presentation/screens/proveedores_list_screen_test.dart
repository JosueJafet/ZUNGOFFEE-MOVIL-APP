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
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/screens/proveedores_list_screen.dart';

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
/// `home_screen_test.dart` para simular error -> reintentar -> data.
class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository(this._responses)
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<List<Proveedor>> Function()> _responses;
  int callCount = 0;

  @override
  Future<List<Proveedor>> getProveedores() {
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

const _proveedorDeEjemplo = Proveedor(
  id: 12,
  tenantId: 5,
  nombre: 'Don Chepe Martinez',
  lugar: 'Marcala',
  finca: 'Finca El Roble',
  telefono: '9999-9999',
  estado: true,
);

Widget _wrap({
  required PerfilRepository perfilRepository,
  required ProveedorRepository proveedorRepository,
  required AuthRepository authRepository,
  VoidCallback? onCrear,
  void Function(Proveedor)? onEditar,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      proveedorRepositoryProvider.overrideWithValue(proveedorRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: ProveedoresListScreen(
        onCrear: onCrear ?? () {},
        onEditar: onEditar ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('ProveedoresListScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets(
      'admin_bodega: los items son tocables y llaman onEditar con el proveedor',
      (tester) async {
        Proveedor? editado;

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            proveedorRepository: _FakeProveedorRepository([
              () async => [_proveedorDeEjemplo],
            ]),
            authRepository: authRepository,
            onEditar: (proveedor) => editado = proveedor,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Don Chepe Martinez'), findsOneWidget);
        expect(find.text('Marcala · Finca El Roble · 9999-9999'), findsOneWidget);

        await tester.tap(find.text('Don Chepe Martinez'));
        await tester.pumpAndSettle();

        expect(editado, _proveedorDeEjemplo);
      },
    );

    testWidgets('empleado: los items no son tocables', (tester) async {
      var editadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([
            () async => [_proveedorDeEjemplo],
          ]),
          authRepository: authRepository,
          onEditar: (_) => editadoCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.onTap, isNull);

      await tester.tap(find.text('Don Chepe Martinez'));
      await tester.pumpAndSettle();

      expect(editadoCallCount, 0);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin proveedores"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([() async => []]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay proveedores registrados'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([
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
          proveedorRepository: _FakeProveedorRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir los proveedores tras un error', (
      tester,
    ) async {
      final repository = _FakeProveedorRepository([
        () async => throw const ApiException(
          statusCode: 500,
          message: 'Error del servidor',
        ),
        () async => [_proveedorDeEjemplo],
      ]);

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: repository,
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Don Chepe Martinez'), findsOneWidget);
      expect(repository.callCount, 2);
    });

    testWidgets('FAB de crear llama onCrear', (tester) async {
      var crearCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([
            () async => [_proveedorDeEjemplo],
          ]),
          authRepository: authRepository,
          onCrear: () => crearCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Agregar proveedor'));
      await tester.pumpAndSettle();

      expect(crearCallCount, 1);
    });
  });
}
