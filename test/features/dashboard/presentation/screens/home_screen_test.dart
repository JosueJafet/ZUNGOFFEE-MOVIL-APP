import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/dashboard/presentation/screens/home_screen.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pagos_resumen.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/ventas_providers.dart';
import 'package:zungofee_mobile/shared/data/models/resumen_diario.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository(super.authSessionService, {this.signOutError, this.signOutDelay});

  final Object? signOutError;
  final Duration? signOutDelay;
  int signOutCallCount = 0;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    if (signOutDelay != null) await Future<void>.delayed(signOutDelay!);
    if (signOutError != null) throw signOutError!;
  }
}

/// Responde con la próxima función de [_responses] en cada llamada
/// (se queda en la última una vez agotadas) — permite simular
/// error -> reintentar -> data, además de los casos simples de éxito.
class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._responses)
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<Perfil> Function()> _responses;
  int callCount = 0;

  @override
  Future<Perfil> getPerfil() {
    final index = callCount < _responses.length
        ? callCount
        : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }
}

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository([this._existencias = const []])
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Lote> _existencias;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _existencias;
}

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository([this._resumen = const []])
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<ResumenDiario> _resumen;

  @override
  Future<List<ResumenDiario>> getResumen() async => _resumen;
}

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository([this._resumen = const []])
    : super(VentasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<ResumenDiario> _resumen;

  @override
  Future<List<ResumenDiario>> getResumen() async => _resumen;
}

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository([this._resumen])
    : super(PagoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final PagosResumen? _resumen;

  @override
  Future<PagosResumen> getResumen() async =>
      _resumen ??
      const PagosResumen(
        tenantsActivos: 16,
        tenantsSuspendidos: 2,
        ingresosMesActual: 1000,
        ingresosTotales: 2500,
      );
}

final _perfilEmpleado = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

final _perfilAdminBodega = Perfil(
  id: 8,
  nombre: 'Ana Bodega',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'admin_bodega',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

final _perfilSuperAdmin = Perfil(
  id: 1,
  nombre: 'Ana Torres',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'super_admin',
  tenantId: null,
  tenantNombre: null,
);

const _loteDeEjemplo = Lote(
  id: '183522',
  saldo: 3.0,
  cantidadInicial: 5.0,
  estadoCafeNombre: 'tostado_medio',
  unidadMedidaId: 3,
  variedadNombre: 'Typica',
);

Widget _wrap(
  PerfilRepository perfilRepository,
  AuthRepository authRepository, {
  LotesRepository? lotesRepository,
  ComprasRepository? comprasRepository,
  VentasRepository? ventasRepository,
  PagoRepository? pagoRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      lotesRepositoryProvider.overrideWithValue(
        lotesRepository ?? _FakeLotesRepository(),
      ),
      comprasRepositoryProvider.overrideWithValue(
        comprasRepository ?? _FakeComprasRepository(),
      ),
      ventasRepositoryProvider.overrideWithValue(
        ventasRepository ?? _FakeVentasRepository(),
      ),
      pagoRepositoryProvider.overrideWithValue(
        pagoRepository ?? _FakePagoRepository(),
      ),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
  );
}

/// A diferencia de `_wrap`, monta `HomeScreen` sobre un `GoRouter` real
/// (con una ruta placeholder para "Ver todo") — lo único que le compete a
/// `HomeScreen` es navegar a la ruta correcta; qué muestra esa ruta es
/// responsabilidad de `existencias_list_screen_test.dart`.
Widget _wrapWithRouter(
  PerfilRepository perfilRepository,
  AuthRepository authRepository, {
  LotesRepository? lotesRepository,
}) {
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.existencias,
        builder: (context, state) =>
            const Scaffold(body: Text('Placeholder de Existencias')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      lotesRepositoryProvider.overrideWithValue(
        lotesRepository ?? _FakeLotesRepository(),
      ),
      comprasRepositoryProvider.overrideWithValue(_FakeComprasRepository()),
      ventasRepositoryProvider.overrideWithValue(_FakeVentasRepository()),
      pagoRepositoryProvider.overrideWithValue(_FakePagoRepository()),
    ],
    child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
}

void main() {
  group('HomeScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets('muestra un indicador de carga mientras resuelve el perfil', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () => Future.delayed(
          const Duration(milliseconds: 100),
          () => _perfilEmpleado,
        ),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('muestra el mensaje de bienvenida y la bodega del perfil', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido, Juan Pérez'), findsOneWidget);
      expect(find.text('Bodega Central'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () async =>
            throw const ApiException(statusCode: 500, message: 'Error del servidor'),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('un NetworkException muestra su mensaje', (tester) async {
      final repository = _FakePerfilRepository([
        () async => throw const NetworkException('Sin conexión'),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir el perfil tras un error', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () async =>
            throw const ApiException(statusCode: 500, message: 'Error del servidor'),
        () async => _perfilEmpleado,
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido, Juan Pérez'), findsOneWidget);
      expect(repository.callCount, 2);
    });

    testWidgets(
      'logout: tap en el ícono llama signOut() exactamente una vez, sin navegar',
      (tester) async {
        final fakeAuthRepository = _FakeAuthRepository(
          AuthSessionService(supabaseClient),
        );
        final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

        await tester.pumpWidget(_wrap(repository, fakeAuthRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Cerrar sesión'));
        await tester.pumpAndSettle();

        expect(fakeAuthRepository.signOutCallCount, 1);
      },
    );

    testWidgets(
      'logout: dos taps seguidos sin pump entre ellos, ¿disparan signOut() '
      'dos veces?',
      (tester) async {
        // Delay para mantener la primera llamada "en vuelo" mientras se
        // dispara el segundo tap, y sin pump() entre los dos taps: el
        // árbol de widgets no se reconstruye entre ambos, así que si el
        // botón no se deshabilita de forma síncrona, el segundo tap
        // vuelve a golpear el mismo IconButton habilitado.
        final fakeAuthRepository = _FakeAuthRepository(
          AuthSessionService(supabaseClient),
          signOutDelay: const Duration(milliseconds: 50),
        );
        final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

        await tester.pumpWidget(_wrap(repository, fakeAuthRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Cerrar sesión'));
        await tester.tap(find.byTooltip('Cerrar sesión'));
        await tester.pumpAndSettle();

        expect(fakeAuthRepository.signOutCallCount, 1);
      },
    );

    testWidgets('logout con error: muestra el mensaje en pantalla', (
      tester,
    ) async {
      const error = ApiException(
        statusCode: 500,
        message: 'Error al cerrar sesión',
      );
      final fakeAuthRepository = _FakeAuthRepository(
        AuthSessionService(supabaseClient),
        signOutError: error,
      );
      final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

      await tester.pumpWidget(_wrap(repository, fakeAuthRepository));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Cerrar sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Error al cerrar sesión'), findsOneWidget);
    });

    testWidgets(
      'empleado: muestra el KPI de lotes en existencia y la lista de '
      'inventario disponible, sin KPIs de compras/ventas',
      (tester) async {
        final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

        await tester.pumpWidget(
          _wrap(
            repository,
            authRepository,
            lotesRepository: _FakeLotesRepository([_loteDeEjemplo]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Lotes en existencia'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('Compras (30 días)'), findsNothing);
        expect(find.text('Ventas (30 días)'), findsNothing);

        expect(find.text('Inventario disponible'), findsOneWidget);
        expect(find.text('Lote #183522'), findsOneWidget);
        expect(find.text('tostado_medio · Typica'), findsOneWidget);
        expect(find.text('3.00'), findsOneWidget);
      },
    );

    testWidgets(
      'admin_bodega: además del KPI de lotes, muestra Compras/Ventas '
      '(30 días) calculados sumando _sum.total del lado del cliente',
      (tester) async {
        final repository = _FakePerfilRepository([() async => _perfilAdminBodega]);

        await tester.pumpWidget(
          _wrap(
            repository,
            authRepository,
            comprasRepository: _FakeComprasRepository([
              ResumenDiario(
                fecha: DateTime.parse('2026-07-21T00:00:00.000Z'),
                total: 12292318.84,
              ),
              ResumenDiario(
                fecha: DateTime.parse('2026-07-20T00:00:00.000Z'),
                total: 2547843.41,
              ),
            ]),
            ventasRepository: _FakeVentasRepository([
              ResumenDiario(
                fecha: DateTime.parse('2026-07-21T00:00:00.000Z'),
                total: 5000,
              ),
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Compras (30 días)'), findsOneWidget);
        expect(find.text('L. 14840162.25'), findsOneWidget);
        expect(find.text('Ventas (30 días)'), findsOneWidget);
        expect(find.text('L. 5000.00'), findsOneWidget);
        expect(find.text('Lotes en existencia'), findsOneWidget);
      },
    );

    testWidgets(
      'inventario disponible vacío: muestra el mensaje correspondiente',
      (tester) async {
        final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

        await tester.pumpWidget(_wrap(repository, authRepository));
        await tester.pumpAndSettle();

        expect(find.text('No hay lotes con saldo disponible'), findsOneWidget);
      },
    );

    testWidgets('"Ver todo" navega a RoutePaths.existencias', (tester) async {
      final repository = _FakePerfilRepository([() async => _perfilEmpleado]);

      await tester.pumpWidget(_wrapWithRouter(repository, authRepository));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ver todo'));
      await tester.pumpAndSettle();

      expect(find.text('Placeholder de Existencias'), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets(
      'super_admin: muestra los KPIs de la plataforma (reutiliza '
      'pagosResumenProvider), sin KPIs operativos',
      (tester) async {
        final repository = _FakePerfilRepository([() async => _perfilSuperAdmin]);

        await tester.pumpWidget(
          _wrap(
            repository,
            authRepository,
            pagoRepository: _FakePagoRepository(
              const PagosResumen(
                tenantsActivos: 16,
                tenantsSuspendidos: 3,
                ingresosMesActual: 1000,
                ingresosTotales: 1000,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Bienvenido, Ana Torres'), findsOneWidget);
        expect(find.text('Panel de administración'), findsOneWidget);
        expect(find.text('Bodegas activas'), findsOneWidget);
        expect(find.text('16'), findsOneWidget);
        expect(find.text('Bodegas suspendidas'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('Ingresos del mes'), findsOneWidget);
        expect(find.text('Ingresos totales'), findsOneWidget);
        expect(find.text('L. 1000.00'), findsNWidgets(2));

        expect(find.text('Lotes en existencia'), findsNothing);
        expect(find.text('Inventario disponible'), findsNothing);
      },
    );
  });
}
