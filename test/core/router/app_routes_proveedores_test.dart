import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/constants/app_role.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
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
import 'package:zungofee_mobile/features/proveedores/presentation/screens/proveedor_form_screen.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/screens/proveedores_list_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` (Sprint 5,
/// Task 6) — `context.push`/`context.pop` disparados desde adentro de
/// los `GoRoute.builder` de `/proveedores` y `/proveedores/formulario` —
/// usando un `GoRouter` construido directamente con `AppRoutes.routes`,
/// SIN pasar por `AppRouter.build`/`AuthRedirect`: simular una sesión
/// autenticada real de Supabase requeriría responder sus llamadas HTTP
/// internas (mismo límite ya documentado en `app_router_test.dart`), y el
/// guard de sesión no es responsabilidad de este Task — ya está cubierto
/// por `auth_redirect_test.dart`.
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

class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository(this._proveedores, {this.crearError})
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Proveedor> _proveedores;
  final Object? crearError;
  int crearCallCount = 0;

  @override
  Future<List<Proveedor>> getProveedores() async => _proveedores;

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
    final creado = Proveedor(
      id: 99,
      tenantId: 5,
      nombre: nombre,
      sexo: sexo,
      lugar: lugar,
      finca: finca,
      telefono: telefono,
      estado: true,
    );
    _proveedores.add(creado);
    return creado;
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

const _proveedorExistente = Proveedor(
  id: 12,
  tenantId: 5,
  nombre: 'Don Chepe Martinez',
  lugar: 'Marcala',
  finca: 'Finca El Roble',
  telefono: '9999-9999',
  estado: true,
);

void main() {
  group('AppRoutes — proveedores (Sprint 5, Task 6)', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    Future<GoRouter> pumpRouter(
      WidgetTester tester, {
      required PerfilRepository perfilRepository,
      required ProveedorRepository proveedorRepository,
      String initialLocation = RoutePaths.proveedores,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            perfilRepositoryProvider.overrideWithValue(perfilRepository),
            proveedorRepositoryProvider.overrideWithValue(proveedorRepository),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      return router;
    }

    testWidgets('/proveedores muestra ProveedoresListScreen con datos', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        perfilRepository: _FakePerfilRepository(
          _perfilConRol(AppRole.empleado),
        ),
        proveedorRepository: _FakeProveedorRepository([_proveedorExistente]),
      );

      expect(find.byType(ProveedoresListScreen), findsOneWidget);
      expect(find.text('Don Chepe Martinez'), findsOneWidget);
    });

    testWidgets(
      'onCrear (FAB) navega a /proveedores/formulario en modo crear',
      (tester) async {
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([_proveedorExistente]),
        );

        await tester.tap(find.byTooltip('Agregar proveedor'));
        await tester.pumpAndSettle();

        expect(find.byType(ProveedorFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Agregar proveedor'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Nombre'), findsOneWidget);
        // Modo crear: el campo de nombre debe llegar vacío.
        final nombreField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Nombre'),
        );
        expect(nombreField.controller?.text, isEmpty);
      },
    );

    testWidgets(
      'onEditar (tap en un item, solo admin_bodega) navega a '
      '/proveedores/formulario con el Proveedor correcto vía extra',
      (tester) async {
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.adminBodega),
          ),
          proveedorRepository: _FakeProveedorRepository([_proveedorExistente]),
        );

        await tester.tap(find.text('Don Chepe Martinez'));
        await tester.pumpAndSettle();

        expect(find.byType(ProveedorFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Editar proveedor'), findsOneWidget);
        expect(find.text('Don Chepe Martinez'), findsOneWidget);
        expect(find.text('Marcala'), findsOneWidget);
      },
    );

    testWidgets(
      'un empleado no puede tocar un item: no navega al formulario',
      (tester) async {
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository([_proveedorExistente]),
        );

        await tester.tap(find.text('Don Chepe Martinez'));
        await tester.pumpAndSettle();

        expect(find.byType(ProveedorFormScreen), findsNothing);
        expect(find.byType(ProveedoresListScreen), findsOneWidget);
      },
    );

    testWidgets(
      'guardar exitoso: onGuardado hace pop y vuelve a la lista actualizada',
      (tester) async {
        final proveedores = [_proveedorExistente];
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository(proveedores),
        );

        await tester.tap(find.byTooltip('Agregar proveedor'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Nuevo Proveedor',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(ProveedorFormScreen), findsNothing);
        expect(find.byType(ProveedoresListScreen), findsOneWidget);
        expect(find.text('Nuevo Proveedor'), findsOneWidget);
      },
    );

    testWidgets(
      'guardar con error: el formulario NO se cierra (no hay pop)',
      (tester) async {
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          proveedorRepository: _FakeProveedorRepository(
            [_proveedorExistente],
            crearError: const ApiException(
              statusCode: 400,
              message: 'El nombre ya está registrado',
            ),
          ),
        );

        await tester.tap(find.byTooltip('Agregar proveedor'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Nuevo Proveedor',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(ProveedorFormScreen), findsOneWidget);
        expect(find.text('El nombre ya está registrado'), findsOneWidget);
      },
    );
  });
}
