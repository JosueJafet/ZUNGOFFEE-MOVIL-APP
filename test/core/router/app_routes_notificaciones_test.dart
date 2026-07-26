import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/models/notificacion.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/screens/notificaciones_list_screen.dart';

/// Ejercita la navegación real de `AppRoutes` (Sprint 10, Task 5) para
/// `/notificaciones`, mismo enfoque que `app_routes_historial_test.dart`
/// (Sprint 9).
class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository(this._notificaciones)
    : super(
        NotificacionesRemoteDataSource(ApiClient(FakeSessionTokenProvider())),
      );

  final List<Notificacion> _notificaciones;

  @override
  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) async =>
      _notificaciones;
}

void main() {
  testWidgets(
    '/notificaciones muestra NotificacionesListScreen (Sprint 10, Task 5)',
    (tester) async {
      final router = GoRouter(
        initialLocation: RoutePaths.notificaciones,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificacionesRepositoryProvider.overrideWithValue(
              _FakeNotificacionesRepository(const []),
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NotificacionesListScreen), findsOneWidget);
    },
  );
}
