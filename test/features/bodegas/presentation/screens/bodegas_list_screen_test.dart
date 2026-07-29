import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/screens/bodegas_list_screen.dart';

/// Responde con la próxima función de [_responses] en cada llamada — mismo
/// patrón de `proveedores_list_screen_test.dart`.
class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository(
    this._responses, {
    this.suspenderError,
    this.activarError,
  }) : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Future<List<Bodega>> Function()> _responses;
  final Object? suspenderError;
  final Object? activarError;
  int callCount = 0;
  int suspenderCallCount = 0;
  int activarCallCount = 0;

  @override
  Future<List<Bodega>> getBodegas() {
    final index =
        callCount < _responses.length ? callCount : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }

  @override
  Future<void> suspender(int id) async {
    suspenderCallCount++;
    if (suspenderError != null) throw suspenderError!;
  }

  @override
  Future<void> activar(int id) async {
    activarCallCount++;
    if (activarError != null) throw activarError!;
  }
}

final _bodegaActiva = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

final _bodegaSuspendida = Bodega(
  id: 6,
  nombre: 'Bodega Suspendida',
  estadoId: 2,
  fechaRegistro: DateTime.parse('2026-07-23T00:00:00.000Z'),
);

final _bodegaConSuscripcion = Bodega(
  id: 7,
  nombre: 'Bodega Con Suscripción',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-23T00:00:00.000Z'),
  diasRestantes: 25,
  estadoPagoCalculado: 'pendiente',
);

Widget _wrap(
  BodegaRepository repository, {
  VoidCallback? onCrear,
  void Function(Bodega)? onEditar,
}) {
  return ProviderScope(
    overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: BodegasListScreen(
        onCrear: onCrear ?? () {},
        onEditar: onEditar ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('BodegasListScreen', () {
    testWidgets('muestra las bodegas con su fecha y estado', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _FakeBodegaRepository([
            () async => [_bodegaActiva, _bodegaSuspendida],
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bodega de Prueba'), findsOneWidget);
      expect(find.text('2026-07-21'), findsOneWidget);
      expect(find.text('Activa'), findsOneWidget);
      expect(find.text('Bodega Suspendida'), findsOneWidget);
      expect(find.text('Suspendida'), findsOneWidget);
    });

    testWidgets(
      'con ciclo de pago: muestra el estado de suscripción y los días '
      'restantes',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeBodegaRepository([
              () async => [_bodegaConSuscripcion],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('pendiente'), findsOneWidget);
        expect(find.text('25 días restantes'), findsOneWidget);
      },
    );

    testWidgets(
      'sin ciclo de pago: muestra "Sin ciclo de pago" en vez de un chip '
      'vacío',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeBodegaRepository([
              () async => [_bodegaActiva],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sin ciclo de pago'), findsOneWidget);
      },
    );

    testWidgets('tap en una fila llama onEditar con la bodega', (tester) async {
      Bodega? editada;

      await tester.pumpWidget(
        _wrap(
          _FakeBodegaRepository([
            () async => [_bodegaActiva]
          ]),
          onEditar: (bodega) => editada = bodega,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bodega de Prueba'));
      await tester.pumpAndSettle();

      expect(editada, _bodegaActiva);
    });

    testWidgets(
      'bodega activa: Suspender pide confirmación y al aceptar invalida '
      'la lista',
      (tester) async {
        final repository = _FakeBodegaRepository([
          () async => [_bodegaActiva],
          () async => [_bodegaSuspendida],
        ]);

        await tester.pumpWidget(_wrap(repository));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Suspender'));
        await tester.pumpAndSettle();

        expect(find.text('Suspender bodega'), findsOneWidget);
        expect(repository.suspenderCallCount, 0);

        await tester.tap(
          find.widgetWithText(FilledButton, 'Suspender').last,
        );
        await tester.pumpAndSettle();

        expect(repository.suspenderCallCount, 1);
        expect(find.text('Bodega Suspendida'), findsOneWidget);
      },
    );

    testWidgets('bodega activa: cancelar el diálogo no suspende',
        (tester) async {
      final repository = _FakeBodegaRepository([
        () async => [_bodegaActiva],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Suspender'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
      await tester.pumpAndSettle();

      expect(repository.suspenderCallCount, 0);
    });

    testWidgets(
      'bodega suspendida: Activar (sin confirmación) invalida la lista',
      (tester) async {
        final repository = _FakeBodegaRepository([
          () async => [_bodegaSuspendida],
          () async => [_bodegaActiva],
        ]);

        await tester.pumpWidget(_wrap(repository));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(FilledButton, 'Activar'));
        await tester.pumpAndSettle();

        expect(repository.activarCallCount, 1);
        expect(find.text('Activa'), findsOneWidget);
      },
    );

    testWidgets('un error al suspender se muestra en un SnackBar',
        (tester) async {
      final repository = _FakeBodegaRepository(
        [
          () async => [_bodegaActiva]
        ],
        suspenderError: const ApiException(
          statusCode: 400,
          message: 'No se pudo suspender',
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Suspender'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Suspender').last);
      await tester.pumpAndSettle();

      expect(find.text('No se pudo suspender'), findsOneWidget);
    });

    testWidgets('un error al activar se muestra en un SnackBar',
        (tester) async {
      final repository = _FakeBodegaRepository(
        [
          () async => [_bodegaSuspendida]
        ],
        activarError: const ApiException(
          statusCode: 400,
          message: 'No se pudo activar',
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Activar'));
      await tester.pumpAndSettle();

      expect(find.text('No se pudo activar'), findsOneWidget);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin bodegas"',
        (tester) async {
      await tester.pumpWidget(_wrap(_FakeBodegaRepository([() async => []])));
      await tester.pumpAndSettle();

      expect(find.text('No hay bodegas registradas'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeBodegaRepository([
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
          _FakeBodegaRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir las bodegas tras un error', (
      tester,
    ) async {
      final repository = _FakeBodegaRepository([
        () async => throw const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
        () async => [_bodegaActiva],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Bodega de Prueba'), findsOneWidget);
      expect(repository.callCount, 2);
    });

    testWidgets('FAB de crear llama onCrear', (tester) async {
      var crearCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          _FakeBodegaRepository([
            () async => [_bodegaActiva]
          ]),
          onCrear: () => crearCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Nueva bodega'));
      await tester.pumpAndSettle();

      expect(crearCallCount, 1);
    });
  });
}
