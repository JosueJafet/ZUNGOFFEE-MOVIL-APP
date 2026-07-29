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
import 'package:zungofee_mobile/features/bodegas/presentation/screens/bodega_form_screen.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/models/solicitud.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_providers.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/screens/solicitudes_list_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` para
/// `/solicitudes` y su salida hacia `/bodegas/formulario` con prellenado
/// (Sprint 14) — mismo criterio que `app_routes_bodegas_test.dart`: el
/// guard de rol/sesión no es responsabilidad de este test.
class _FakeSolicitudRepository extends SolicitudRepository {
  _FakeSolicitudRepository(this._solicitudes)
    : super(SolicitudRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Solicitud> _solicitudes;

  @override
  Future<List<Solicitud>> getSolicitudes() async => _solicitudes;
}

class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository()
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  int onboardingCallCount = 0;
  int? solicitudIdRecibido;
  String? nombreBodegaRecibido;
  String? nombreAdminRecibido;
  String? emailAdminRecibido;

  @override
  Future<List<Bodega>> getBodegas() async => [];

  @override
  Future<Bodega> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    onboardingCallCount++;
    solicitudIdRecibido = solicitudId;
    nombreBodegaRecibido = nombreBodega;
    nombreAdminRecibido = nombreAdmin;
    emailAdminRecibido = emailAdmin;
    return Bodega(
      id: 99,
      nombre: nombreBodega,
      estadoId: 1,
      fechaRegistro: DateTime.parse('2026-07-27T00:00:00.000Z'),
    );
  }
}

final _solicitudPendiente = Solicitud(
  id: 3,
  nombreBodega: 'Bodega Mertens',
  nombreContacto: 'Martin Mertens',
  email: 'mertens@gmail.com',
  telefono: '+504 99887766',
  mensaje: '3 empleados.',
  estadoId: 1,
  fechaCreacion: DateTime.parse('2026-07-24T05:16:35.020Z'),
);

void main() {
  group('AppRoutes — solicitudes (Sprint 14)', () {
    Future<GoRouter> pumpRouter(
      WidgetTester tester, {
      required SolicitudRepository solicitudRepository,
      required BodegaRepository bodegaRepository,
      String initialLocation = RoutePaths.solicitudes,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            solicitudRepositoryProvider.overrideWithValue(solicitudRepository),
            bodegaRepositoryProvider.overrideWithValue(bodegaRepository),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      return router;
    }

    testWidgets('/solicitudes muestra SolicitudesListScreen con datos', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        solicitudRepository: _FakeSolicitudRepository([_solicitudPendiente]),
        bodegaRepository: _FakeBodegaRepository(),
      );

      expect(find.byType(SolicitudesListScreen), findsOneWidget);
      expect(find.text('Bodega Mertens'), findsOneWidget);
    });

    testWidgets(
      '"Crear bodega" navega a /bodegas/formulario con los campos '
      'prellenados desde la Solicitud',
      (tester) async {
        await pumpRouter(
          tester,
          solicitudRepository: _FakeSolicitudRepository([_solicitudPendiente]),
          bodegaRepository: _FakeBodegaRepository(),
        );

        await tester.tap(find.widgetWithText(FilledButton, 'Crear bodega'));
        await tester.pumpAndSettle();

        expect(find.byType(BodegaFormScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Nueva bodega'), findsOneWidget);
        expect(find.text('Bodega Mertens'), findsOneWidget);
        expect(find.text('Martin Mertens'), findsOneWidget);
        expect(find.text('mertens@gmail.com'), findsOneWidget);
        expect(
          find.text('Teléfono de referencia: +504 99887766'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'guardar desde el prellenado manda solicitudId al crear la bodega',
      (tester) async {
        final bodegaRepository = _FakeBodegaRepository();
        await pumpRouter(
          tester,
          solicitudRepository: _FakeSolicitudRepository([_solicitudPendiente]),
          bodegaRepository: bodegaRepository,
        );

        await tester.tap(find.widgetWithText(FilledButton, 'Crear bodega'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contraseña del admin'),
          'password123',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(bodegaRepository.onboardingCallCount, 1);
        expect(bodegaRepository.solicitudIdRecibido, 3);
        expect(bodegaRepository.nombreBodegaRecibido, 'Bodega Mertens');
        expect(bodegaRepository.nombreAdminRecibido, 'Martin Mertens');
        expect(bodegaRepository.emailAdminRecibido, 'mertens@gmail.com');
        expect(find.byType(BodegaFormScreen), findsNothing);
        expect(find.byType(SolicitudesListScreen), findsOneWidget);
      },
    );
  });
}
