import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/screens/perfil_editar_screen.dart';
import 'package:zungofee_mobile/features/dashboard/presentation/screens/home_screen.dart';

/// Ejercita la navegación real de `AppRoutes` (Sprint 11, Task 4) para
/// `/perfil/editar`, mismo enfoque que `app_routes_notificaciones_test.dart`
/// (Sprint 10).
class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
    : super(PerfilRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;

  @override
  Future<void> actualizar(String nombre) async {}
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

void main() {
  testWidgets(
    '/perfil/editar muestra PerfilEditarScreen (Sprint 11, Task 4)',
    (tester) async {
      final router = GoRouter(
        initialLocation: RoutePaths.perfilEditar,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            perfilRepositoryProvider.overrideWithValue(
              _FakePerfilRepository(_perfilDeEjemplo),
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PerfilEditarScreen), findsOneWidget);
    },
  );

  testWidgets(
    'guardar exitoso en /perfil/editar: onGuardado hace pop de vuelta a '
    'la ruta anterior',
    (tester) async {
      final router = GoRouter(
        initialLocation: RoutePaths.home,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            perfilRepositoryProvider.overrideWithValue(
              _FakePerfilRepository(_perfilDeEjemplo),
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      router.push(RoutePaths.perfilEditar);
      await tester.pumpAndSettle();
      expect(find.byType(PerfilEditarScreen), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.byType(PerfilEditarScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
