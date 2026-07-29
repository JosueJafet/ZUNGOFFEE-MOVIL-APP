import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pagos_resumen.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pago_form_screen.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pago_historial_screen.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pagos_resumen_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` para
/// `/pagos`/`/pagos/historial`/`/pagos/formulario` (Sprint 14) — mismo
/// criterio que `app_routes_bodegas_test.dart`: el guard de rol/sesión no
/// es responsabilidad de este test.
class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository(this._bodegas)
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Bodega> _bodegas;

  @override
  Future<List<Bodega>> getBodegas() async => _bodegas;
}

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository(this._pagos)
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Pago> _pagos;
  int registrarCallCount = 0;

  @override
  Future<PagosResumen> getResumen() async => const PagosResumen(
    tenantsActivos: 1,
    tenantsSuspendidos: 0,
    ingresosMesActual: 500,
    ingresosTotales: 500,
  );

  @override
  Future<List<Pago>> getHistorialPorBodega(int tenantId) async => _pagos;

  @override
  Future<void> registrar({
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
  }) async {
    registrarCallCount++;
  }
}

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

Future<void> _confirmarDatePicker(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  group('AppRoutes — pagos (Sprint 14)', () {
    Future<GoRouter> pumpRouter(
      WidgetTester tester, {
      required BodegaRepository bodegaRepository,
      required PagoRepository pagoRepository,
      String initialLocation = RoutePaths.pagos,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bodegaRepositoryProvider.overrideWithValue(bodegaRepository),
            pagoRepositoryProvider.overrideWithValue(pagoRepository),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      return router;
    }

    testWidgets('/pagos muestra PagosResumenScreen con datos', (tester) async {
      await pumpRouter(
        tester,
        bodegaRepository: _FakeBodegaRepository([_bodega]),
        pagoRepository: _FakePagoRepository([]),
      );

      expect(find.byType(PagosResumenScreen), findsOneWidget);
      expect(find.text('Bodega de Prueba'), findsOneWidget);
    });

    testWidgets(
      '"Ver historial de pagos" navega a /pagos/historial con la Bodega '
      'correcta vía extra',
      (tester) async {
        await pumpRouter(
          tester,
          bodegaRepository: _FakeBodegaRepository([_bodega]),
          pagoRepository: _FakePagoRepository([]),
        );

        await tester.ensureVisible(
          find.widgetWithText(TextButton, 'Ver historial de pagos'),
        );
        await tester.tap(find.widgetWithText(TextButton, 'Ver historial de pagos'));
        await tester.pumpAndSettle();

        expect(find.byType(PagoHistorialScreen), findsOneWidget);
        expect(
          find.widgetWithText(AppBar, 'Pagos — Bodega de Prueba'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'FAB "Nuevo pago" navega a /pagos/formulario con la Bodega '
      'correcta, y guardar exitoso vuelve al historial',
      (tester) async {
        final pagoRepository = _FakePagoRepository([]);
        await pumpRouter(
          tester,
          bodegaRepository: _FakeBodegaRepository([_bodega]),
          pagoRepository: pagoRepository,
        );

        await tester.ensureVisible(
          find.widgetWithText(TextButton, 'Ver historial de pagos'),
        );
        await tester.tap(find.widgetWithText(TextButton, 'Ver historial de pagos'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Nuevo pago'));
        await tester.pumpAndSettle();

        expect(find.byType(PagoFormScreen), findsOneWidget);
        expect(
          find.widgetWithText(AppBar, 'Nuevo pago — Bodega de Prueba'),
          findsOneWidget,
        );

        await tester.tap(find.text('Periodo'));
        await _confirmarDatePicker(tester);
        await tester.tap(find.text('Fecha de vencimiento'));
        await _confirmarDatePicker(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Monto'),
          '123.45',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(pagoRepository.registrarCallCount, 1);
        expect(find.byType(PagoFormScreen), findsNothing);
        expect(find.byType(PagoHistorialScreen), findsOneWidget);
      },
    );
  });
}
