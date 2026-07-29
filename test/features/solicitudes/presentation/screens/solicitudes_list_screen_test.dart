import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:zungofee_mobile/features/solicitudes/data/models/solicitud.dart';
import 'package:zungofee_mobile/features/solicitudes/data/repositories/solicitud_repository.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/providers/solicitud_providers.dart';
import 'package:zungofee_mobile/features/solicitudes/presentation/screens/solicitudes_list_screen.dart';

/// Responde con la próxima función de [_responses] en cada llamada —
/// mismo patrón de `bodegas_list_screen_test.dart`.
class _FakeSolicitudRepository extends SolicitudRepository {
  _FakeSolicitudRepository(this._responses, {this.rechazarError})
    : super(SolicitudRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Future<List<Solicitud>> Function()> _responses;
  final Object? rechazarError;
  int callCount = 0;
  int rechazarCallCount = 0;

  @override
  Future<List<Solicitud>> getSolicitudes() {
    final index = callCount < _responses.length ? callCount : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }

  @override
  Future<void> rechazar(int id) async {
    rechazarCallCount++;
    if (rechazarError != null) throw rechazarError!;
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

final _solicitudProcesada = Solicitud(
  id: 4,
  nombreBodega: 'Bodega Procesada',
  nombreContacto: 'Ana Torres',
  email: 'ana@bodegaprocesada.com',
  telefono: '+504 88776655',
  estadoId: 2,
  tenantCreadoId: 21,
  fechaCreacion: DateTime.parse('2026-07-25T00:00:00.000Z'),
);

final _solicitudSinTelefono = Solicitud(
  id: 5,
  nombreBodega: 'Bodega Ejemplo',
  nombreContacto: 'Zunga Mayor',
  email: 'zungamayor@gmail.com',
  mensaje: 'Ayudenme a hacer mi perfil.',
  estadoId: 2,
  tenantCreadoId: 30,
  fechaCreacion: DateTime.parse('2026-07-23T00:00:00.000Z'),
);

Widget _wrap(
  SolicitudRepository repository, {
  void Function(Solicitud)? onCrearBodega,
}) {
  return ProviderScope(
    overrides: [solicitudRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: SolicitudesListScreen(onCrearBodega: onCrearBodega ?? (_) {}),
    ),
  );
}

void main() {
  group('SolicitudesListScreen', () {
    testWidgets('muestra las solicitudes con su contacto y estado', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeSolicitudRepository([
            () async => [_solicitudPendiente, _solicitudProcesada],
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bodega Mertens'), findsOneWidget);
      expect(
        find.text(
          'Martin Mertens · mertens@gmail.com · +504 99887766 · '
          '3 empleados.',
        ),
        findsOneWidget,
      );
      expect(find.text('Pendiente'), findsOneWidget);
      expect(find.text('Bodega Procesada'), findsOneWidget);
      expect(find.text('Procesada'), findsOneWidget);
    });

    testWidgets(
      'solicitud sin teléfono (dato real de producción) se muestra sin '
      'romper, sin el separador de más',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeSolicitudRepository([
              () async => [_solicitudSinTelefono],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Bodega Ejemplo'), findsOneWidget);
        expect(
          find.text(
            'Zunga Mayor · zungamayor@gmail.com · '
            'Ayudenme a hacer mi perfil.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'solicitud pendiente: muestra "Crear bodega" y "Descartar"',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_FakeSolicitudRepository([() async => [_solicitudPendiente]])),
        );
        await tester.pumpAndSettle();

        expect(find.widgetWithText(FilledButton, 'Crear bodega'), findsOneWidget);
        expect(find.byTooltip('Descartar'), findsOneWidget);
      },
    );

    testWidgets(
      'solicitud procesada: no muestra "Crear bodega" ni "Descartar"',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_FakeSolicitudRepository([() async => [_solicitudProcesada]])),
        );
        await tester.pumpAndSettle();

        expect(find.widgetWithText(FilledButton, 'Crear bodega'), findsNothing);
        expect(find.byTooltip('Descartar'), findsNothing);
      },
    );

    testWidgets('"Crear bodega" llama onCrearBodega con la solicitud', (
      tester,
    ) async {
      Solicitud? recibida;

      await tester.pumpWidget(
        _wrap(
          _FakeSolicitudRepository([() async => [_solicitudPendiente]]),
          onCrearBodega: (solicitud) => recibida = solicitud,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Crear bodega'));
      await tester.pumpAndSettle();

      expect(recibida, _solicitudPendiente);
    });

    testWidgets(
      'Descartar pide confirmación y al aceptar invalida la lista',
      (tester) async {
        final repository = _FakeSolicitudRepository([
          () async => [_solicitudPendiente],
          () async => [_solicitudProcesada],
        ]);

        await tester.pumpWidget(_wrap(repository));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Descartar'));
        await tester.pumpAndSettle();

        expect(find.text('Rechazar solicitud'), findsOneWidget);
        expect(repository.rechazarCallCount, 0);

        await tester.tap(find.widgetWithText(FilledButton, 'Rechazar'));
        await tester.pumpAndSettle();

        expect(repository.rechazarCallCount, 1);
        expect(find.text('Bodega Procesada'), findsOneWidget);
      },
    );

    testWidgets('cancelar el diálogo no rechaza', (tester) async {
      final repository = _FakeSolicitudRepository([
        () async => [_solicitudPendiente],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Descartar'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
      await tester.pumpAndSettle();

      expect(repository.rechazarCallCount, 0);
    });

    testWidgets('un error al rechazar se muestra en un SnackBar', (tester) async {
      final repository = _FakeSolicitudRepository(
        [() async => [_solicitudPendiente]],
        rechazarError: const ApiException(
          statusCode: 400,
          message: 'No se pudo rechazar',
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Descartar'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Rechazar'));
      await tester.pumpAndSettle();

      expect(find.text('No se pudo rechazar'), findsOneWidget);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin solicitudes"', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakeSolicitudRepository([() async => []])));
      await tester.pumpAndSettle();

      expect(find.text('No hay solicitudes registradas'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeSolicitudRepository([
            () async => throw const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('un NetworkException muestra su mensaje', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _FakeSolicitudRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir las solicitudes tras un error', (
      tester,
    ) async {
      final repository = _FakeSolicitudRepository([
        () async => throw const ApiException(
          statusCode: 500,
          message: 'Error del servidor',
        ),
        () async => [_solicitudPendiente],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Bodega Mertens'), findsOneWidget);
      expect(repository.callCount, 2);
    });
  });
}
