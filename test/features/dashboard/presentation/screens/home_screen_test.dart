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
import 'package:zungofee_mobile/features/dashboard/presentation/screens/home_screen.dart';

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

final _perfilDeEjemplo = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

Widget _wrap(PerfilRepository perfilRepository, AuthRepository authRepository) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
  );
}

/// A diferencia de `_wrap`, monta `HomeScreen` sobre un `GoRouter` real
/// (con una segunda ruta placeholder, no la `ProveedoresListScreen` real)
/// — lo único que le compete a `HomeScreen` es navegar a la ruta
/// correcta (Sprint 5, Task 6); qué muestra esa ruta es responsabilidad
/// de `app_routes_proveedores_test.dart`.
Widget _wrapWithRouter(
  PerfilRepository perfilRepository,
  AuthRepository authRepository,
) {
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.proveedores,
        builder: (context, state) =>
            const Scaffold(body: Text('Placeholder de Proveedores')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
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
          () => _perfilDeEjemplo,
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
      final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

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
        () async => _perfilDeEjemplo,
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
        final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

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
        final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

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
      final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

      await tester.pumpWidget(_wrap(repository, fakeAuthRepository));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Cerrar sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Error al cerrar sesión'), findsOneWidget);
    });

    testWidgets(
      'tap en "Proveedores" navega a RoutePaths.proveedores (Sprint 5, '
      'Task 6)',
      (tester) async {
        final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

        await tester.pumpWidget(_wrapWithRouter(repository, authRepository));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Proveedores'));
        await tester.pumpAndSettle();

        expect(find.text('Placeholder de Proveedores'), findsOneWidget);
        expect(find.byType(HomeScreen), findsNothing);
      },
    );
  });
}
