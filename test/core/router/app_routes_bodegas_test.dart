import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/screens/bodega_form_screen.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/screens/bodegas_list_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` para
/// `/bodegas`/`/bodegas/formulario` (Sprint 14), usando un `GoRouter`
/// construido directamente con `AppRoutes.routes` — mismo criterio que
/// `app_routes_proveedores_test.dart`: el guard de rol/sesión no es
/// responsabilidad de este test.
class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository(this._bodegas, {this.onboardingError})
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Bodega> _bodegas;
  final Object? onboardingError;
  int onboardingCallCount = 0;

  @override
  Future<List<Bodega>> getBodegas() async => _bodegas;

  @override
  Future<Bodega> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    onboardingCallCount++;
    if (onboardingError != null) throw onboardingError!;
    final creada = Bodega(
      id: 99,
      nombre: nombreBodega,
      estadoId: 1,
      fechaRegistro: DateTime.parse('2026-07-27T00:00:00.000Z'),
    );
    _bodegas.add(creada);
    return creada;
  }
}

final _bodegaExistente = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

void main() {
  group('AppRoutes — bodegas (Sprint 14)', () {
    Future<GoRouter> pumpRouter(
      WidgetTester tester, {
      required BodegaRepository bodegaRepository,
      String initialLocation = RoutePaths.bodegas,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bodegaRepositoryProvider.overrideWithValue(bodegaRepository),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      return router;
    }

    testWidgets('/bodegas muestra BodegasListScreen con datos', (tester) async {
      await pumpRouter(
        tester,
        bodegaRepository: _FakeBodegaRepository([_bodegaExistente]),
      );

      expect(find.byType(BodegasListScreen), findsOneWidget);
      expect(find.text('Bodega de Prueba'), findsOneWidget);
    });

    testWidgets(
      'onCrear (FAB) navega a /bodegas/formulario en modo crear',
      (tester) async {
        await pumpRouter(
          tester,
          bodegaRepository: _FakeBodegaRepository([_bodegaExistente]),
        );

        await tester.tap(find.byTooltip('Nueva bodega'));
        await tester.pumpAndSettle();

        expect(find.byType(BodegaFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Nueva bodega'), findsOneWidget);
        expect(
          find.widgetWithText(TextFormField, 'Nombre de la bodega'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'onEditar (tap en un item) navega a /bodegas/formulario con la '
      'Bodega correcta vía extra',
      (tester) async {
        await pumpRouter(
          tester,
          bodegaRepository: _FakeBodegaRepository([_bodegaExistente]),
        );

        await tester.tap(find.text('Bodega de Prueba'));
        await tester.pumpAndSettle();

        expect(find.byType(BodegaFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Editar bodega'), findsOneWidget);
        expect(find.text('Bodega de Prueba'), findsOneWidget);
      },
    );

    testWidgets(
      'crear exitoso: onGuardado hace pop y vuelve a la lista actualizada',
      (tester) async {
        final bodegas = [_bodegaExistente];
        await pumpRouter(tester, bodegaRepository: _FakeBodegaRepository(bodegas));

        await tester.tap(find.byTooltip('Nueva bodega'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre de la bodega'),
          'Bodega Nueva',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre del admin'),
          'Admin Nuevo',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Correo del admin'),
          'admin@bodeganueva.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contraseña del admin'),
          'password123',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(BodegaFormScreen), findsNothing);
        expect(find.byType(BodegasListScreen), findsOneWidget);
        expect(find.text('Bodega Nueva'), findsOneWidget);
      },
    );

    testWidgets(
      'crear con error: el formulario NO se cierra (no hay pop)',
      (tester) async {
        await pumpRouter(
          tester,
          bodegaRepository: _FakeBodegaRepository(
            [_bodegaExistente],
            onboardingError: const ApiException(
              statusCode: 400,
              message: 'El correo ya está registrado',
            ),
          ),
        );

        await tester.tap(find.byTooltip('Nueva bodega'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre de la bodega'),
          'Bodega Nueva',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre del admin'),
          'Admin Nuevo',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Correo del admin'),
          'admin@bodeganueva.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contraseña del admin'),
          'password123',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.byType(BodegaFormScreen), findsOneWidget);
        expect(find.text('El correo ya está registrado'), findsOneWidget);
      },
    );
  });
}
