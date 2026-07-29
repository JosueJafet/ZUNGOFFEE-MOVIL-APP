import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
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
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/metodo_pago.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/unidad_medida.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:zungofee_mobile/features/clientes/presentation/screens/cliente_form_screen.dart';
import 'package:zungofee_mobile/features/clientes/presentation/screens/clientes_list_screen.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/inventario/presentation/screens/existencias_list_screen.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/models/venta.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/ventas_providers.dart';
import 'package:zungofee_mobile/features/ventas/presentation/screens/venta_form_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` (Sprint 7,
/// Task 11) para `/clientes`, `/clientes/formulario` y
/// `/ventas/formulario`, usando un `GoRouter` construido directamente con
/// `AppRoutes.routes` — mismo enfoque que
/// `app_routes_compras_inventario_test.dart` (Sprint 6): el guard de
/// sesión no es responsabilidad de este Task, ya está cubierto por
/// `auth_redirect_test.dart`.
class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
      : super(PerfilRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;
}

class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository(this._clientes, {this.crearError})
      : super(ClienteRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Cliente> _clientes;
  final Object? crearError;

  @override
  Future<List<Cliente>> getClientes() async => _clientes;

  @override
  Future<Cliente> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    if (crearError != null) throw crearError!;
    final creado = Cliente(
      id: 99,
      tenantId: 5,
      nombre: nombre,
      tipoId: tipoId,
      lugar: lugar,
      telefono: telefono,
      estado: true,
    );
    _clientes.add(creado);
    return creado;
  }
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
      : super(CatalogosRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._lotes)
      : super(LotesRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Lote> _lotes;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _lotes;
}

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository({this.crearError})
      : super(VentasRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? crearError;

  @override
  Future<Venta> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    if (crearError != null) throw crearError!;
    return Venta(
      id: 30,
      tenantId: 5,
      clienteId: clienteId,
      usuarioId: 3,
      total: 750,
      anulada: false,
    );
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

const _clienteExistente = Cliente(
  id: 12,
  tenantId: 5,
  nombre: 'Cafeteria El Buen Cafe',
  lugar: 'Tegucigalpa',
  telefono: '9999-9999',
  estado: true,
);

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [MetodoPago(id: 1, nombre: 'Efectivo')],
  variedadesCafe: [],
  nivelesAltura: [],
  estadosCafe: [],
  clientesTipo: [],
  unidadesMedida: [UnidadMedida(id: 2, nombre: 'Quintales')],
);

const _loteDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 10,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('AppRoutes — clientes (Sprint 7, Task 11)', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    Future<void> pumpRouter(
      WidgetTester tester, {
      required PerfilRepository perfilRepository,
      required ClienteRepository clienteRepository,
      String initialLocation = RoutePaths.clientes,
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
            clienteRepositoryProvider.overrideWithValue(clienteRepository),
            catalogosRepositoryProvider.overrideWithValue(
              _FakeCatalogosRepository(_catalogosDeEjemplo),
            ),
          ],
          child:
              MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('/clientes muestra ClientesListScreen con datos', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        perfilRepository: _FakePerfilRepository(
          _perfilConRol(AppRole.empleado),
        ),
        clienteRepository: _FakeClienteRepository([_clienteExistente]),
      );

      expect(find.byType(ClientesListScreen), findsOneWidget);
      expect(find.text('Cafeteria El Buen Cafe'), findsOneWidget);
    });

    testWidgets('onCrear (FAB) navega a /clientes/formulario en modo crear', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        perfilRepository: _FakePerfilRepository(
          _perfilConRol(AppRole.empleado),
        ),
        clienteRepository: _FakeClienteRepository([_clienteExistente]),
      );

      await tester.tap(find.byTooltip('Agregar cliente'));
      await tester.pumpAndSettle();

      expect(find.byType(ClienteFormScreen), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Agregar cliente'), findsOneWidget);
    });

    testWidgets(
      'onEditar (tap en un item, solo admin_bodega) navega a '
      '/clientes/formulario con el Cliente correcto vía extra',
      (tester) async {
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.adminBodega),
          ),
          clienteRepository: _FakeClienteRepository([_clienteExistente]),
        );

        await tester.tap(find.text('Cafeteria El Buen Cafe'));
        await tester.pumpAndSettle();

        expect(find.byType(ClienteFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Editar cliente'), findsOneWidget);
        expect(find.text('Tegucigalpa'), findsOneWidget);
      },
    );

    testWidgets('un empleado no puede tocar un item: no navega al formulario', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        perfilRepository: _FakePerfilRepository(
          _perfilConRol(AppRole.empleado),
        ),
        clienteRepository: _FakeClienteRepository([_clienteExistente]),
      );

      await tester.tap(find.text('Cafeteria El Buen Cafe'));
      await tester.pumpAndSettle();

      expect(find.byType(ClienteFormScreen), findsNothing);
      expect(find.byType(ClientesListScreen), findsOneWidget);
    });

    testWidgets(
      'guardar exitoso: onGuardado hace pop y vuelve a la lista actualizada',
      (tester) async {
        final clientes = [_clienteExistente];
        await pumpRouter(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          clienteRepository: _FakeClienteRepository(clientes),
        );

        await tester.tap(find.byTooltip('Agregar cliente'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Nuevo Cliente',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(ClienteFormScreen), findsNothing);
        expect(find.byType(ClientesListScreen), findsOneWidget);
        expect(find.text('Nuevo Cliente'), findsOneWidget);
      },
    );

    testWidgets('guardar con error: el formulario NO se cierra (no hay pop)', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        perfilRepository: _FakePerfilRepository(
          _perfilConRol(AppRole.empleado),
        ),
        clienteRepository: _FakeClienteRepository(
          [_clienteExistente],
          crearError: const ApiException(
            statusCode: 400,
            message: 'El nombre ya está registrado',
          ),
        ),
      );

      await tester.tap(find.byTooltip('Agregar cliente'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'),
        'Nuevo Cliente',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.byType(ClienteFormScreen), findsOneWidget);
      expect(find.text('El nombre ya está registrado'), findsOneWidget);
    });
  });

  group('AppRoutes — ventas (Sprint 7, Task 11)', () {
    Future<GoRouter> pumpRouter(
      WidgetTester tester, {
      required VentasRepository ventasRepository,
      String initialLocation = RoutePaths.ventaFormulario,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            clienteRepositoryProvider.overrideWithValue(
              _FakeClienteRepository([_clienteExistente]),
            ),
            catalogosRepositoryProvider.overrideWithValue(
              _FakeCatalogosRepository(_catalogosDeEjemplo),
            ),
            lotesRepositoryProvider.overrideWithValue(
              _FakeLotesRepository([_loteDeEjemplo]),
            ),
            ventasRepositoryProvider.overrideWithValue(ventasRepository),
          ],
          child:
              MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      return router;
    }

    testWidgets('/ventas/formulario muestra VentaFormScreen', (tester) async {
      await pumpRouter(tester, ventasRepository: _FakeVentasRepository());

      expect(find.byType(VentaFormScreen), findsOneWidget);
    });

    testWidgets(
      'guardar exitoso en /ventas/formulario: onGuardado hace pop de '
      'vuelta a la ruta anterior',
      (tester) async {
        // Empuja el formulario sobre una ruta real ya en el stack
        // (`/inventario/existencias`, que no depende de perfil/sesión —
        // mismo patrón exacto que `app_routes_compras_inventario_test.dart`,
        // Sprint 6), para que el `pop()` de `onGuardado` tenga a dónde
        // volver sin necesitar un `SupabaseClient` real en este test.
        final router = await pumpRouter(
          tester,
          ventasRepository: _FakeVentasRepository(),
          initialLocation: RoutePaths.existencias,
        );

        router.push(RoutePaths.ventaFormulario);
        await tester.pumpAndSettle();
        expect(find.byType(VentaFormScreen), findsOneWidget);

        await _tapVisible(tester, find.byKey(const Key('dropdown_cliente')));
        await _tapVisible(
          tester,
          find.text('Cafeteria El Buen Cafe').last,
        );
        await _tapVisible(tester, find.byKey(const Key('linea_0_lote')));
        await _tapVisible(
          tester,
          find.text('Catuai · Estandar (saldo: 10.00 Quintales)').last,
        );
        await tester.enterText(find.byKey(const Key('linea_0_cantidad')), '5');
        await tester.enterText(
          find.byKey(const Key('linea_0_precioUnitario')),
          '150',
        );

        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(VentaFormScreen), findsNothing);
        expect(find.byType(ExistenciasListScreen), findsOneWidget);
      },
    );

    testWidgets(
      'guardar con error (saldo insuficiente) en /ventas/formulario: NO '
      'hace pop, el formulario sigue mostrando el error',
      (tester) async {
        await pumpRouter(
          tester,
          ventasRepository: _FakeVentasRepository(
            crearError: const ApiException(
              statusCode: 400,
              message: 'Saldo insuficiente en lote 78',
            ),
          ),
        );

        await _tapVisible(tester, find.byKey(const Key('dropdown_cliente')));
        await _tapVisible(
          tester,
          find.text('Cafeteria El Buen Cafe').last,
        );
        await _tapVisible(tester, find.byKey(const Key('linea_0_lote')));
        await _tapVisible(
          tester,
          find.text('Catuai · Estandar (saldo: 10.00 Quintales)').last,
        );
        await tester.enterText(find.byKey(const Key('linea_0_cantidad')), '5');
        await tester.enterText(
          find.byKey(const Key('linea_0_precioUnitario')),
          '150',
        );

        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(VentaFormScreen), findsOneWidget);
        expect(find.text('Saldo insuficiente en lote 78'), findsOneWidget);
      },
    );
  });
}
