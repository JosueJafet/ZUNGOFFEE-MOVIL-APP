import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/constants/app_role.dart';
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
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/models/compra.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/compras/presentation/screens/compras_historial_screen.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/models/procesamiento.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/screens/procesamiento_historial_screen.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/models/venta.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/ventas_providers.dart';
import 'package:zungofee_mobile/features/ventas/presentation/screens/ventas_historial_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` (Sprint 9,
/// Task 4) para las tres rutas de historial, usando un `GoRouter`
/// construido directamente con `AppRoutes.routes` — mismo enfoque que
/// `app_routes_procesamiento_test.dart` (Sprint 8).
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

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository(this._compras)
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Compra> _compras;

  @override
  Future<List<Compra>> listar({int page = 1, int pageSize = 20}) async =>
      _compras;
}

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository(this._ventas)
    : super(VentasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Venta> _ventas;

  @override
  Future<List<Venta>> listar({int page = 1, int pageSize = 20}) async =>
      _ventas;
}

class _FakeProcesamientoRepository extends ProcesamientoRepository {
  _FakeProcesamientoRepository(this._procesamientos)
    : super(
        ProcesamientoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final List<Procesamiento> _procesamientos;

  @override
  Future<List<Procesamiento>> listar({int page = 1, int pageSize = 20}) async =>
      _procesamientos;
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

void main() {
  group('AppRoutes — historial (Sprint 9, Task 4)', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    Future<void> pumpRouter(
      WidgetTester tester, {
      required String initialLocation,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            perfilRepositoryProvider.overrideWithValue(
              _FakePerfilRepository(_perfilConRol(AppRole.empleado)),
            ),
            comprasRepositoryProvider.overrideWithValue(
              _FakeComprasRepository(const []),
            ),
            ventasRepositoryProvider.overrideWithValue(
              _FakeVentasRepository(const []),
            ),
            procesamientoRepositoryProvider.overrideWithValue(
              _FakeProcesamientoRepository(const []),
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('/compras/historial muestra ComprasHistorialScreen', (
      tester,
    ) async {
      await pumpRouter(tester, initialLocation: RoutePaths.historialCompras);

      expect(find.byType(ComprasHistorialScreen), findsOneWidget);
    });

    testWidgets('/ventas/historial muestra VentasHistorialScreen', (
      tester,
    ) async {
      await pumpRouter(tester, initialLocation: RoutePaths.historialVentas);

      expect(find.byType(VentasHistorialScreen), findsOneWidget);
    });

    testWidgets(
      '/procesamiento/historial muestra ProcesamientoHistorialScreen',
      (tester) async {
        await pumpRouter(
          tester,
          initialLocation: RoutePaths.historialProcesamiento,
        );

        expect(find.byType(ProcesamientoHistorialScreen), findsOneWidget);
      },
    );
  });
}
