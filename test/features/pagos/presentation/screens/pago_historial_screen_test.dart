import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pago_historial_screen.dart';

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository(this._pagos, {this.marcarPagadoError})
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Pago> _pagos;
  final Object? marcarPagadoError;
  int marcarPagadoCallCount = 0;

  @override
  Future<List<Pago>> getHistorialPorBodega(int tenantId) async => _pagos;

  @override
  Future<void> marcarPagado(int id) async {
    marcarPagadoCallCount++;
    if (marcarPagadoError != null) throw marcarPagadoError!;
  }
}

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

final _pagoPendiente = Pago(
  id: 1,
  tenantId: 5,
  periodo: DateTime.parse('2026-08-01T00:00:00.000Z'),
  monto: 500,
  fechaVencimiento: DateTime.parse('2026-08-31T00:00:00.000Z'),
  estadoPagoId: 1,
  registradoPor: 8,
  estadoCalculado: 'pendiente',
);

final _pagoPagado = Pago(
  id: 2,
  tenantId: 5,
  periodo: DateTime.parse('2026-07-01T00:00:00.000Z'),
  monto: 500,
  fechaVencimiento: DateTime.parse('2026-07-31T00:00:00.000Z'),
  fechaPago: DateTime.parse('2026-07-23T00:00:00.000Z'),
  estadoPagoId: 2,
  registradoPor: 8,
  estadoCalculado: 'pagado',
);

Widget _wrap(
  PagoRepository repository, {
  VoidCallback? onNuevoPago,
}) {
  return ProviderScope(
    overrides: [pagoRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PagoHistorialScreen(
        bodega: _bodega,
        onNuevoPago: onNuevoPago ?? () {},
      ),
    ),
  );
}

void main() {
  group('PagoHistorialScreen', () {
    testWidgets('muestra los pagos con su monto y estado', (tester) async {
      await tester.pumpWidget(_wrap(_FakePagoRepository([_pagoPendiente])));
      await tester.pumpAndSettle();

      expect(find.text('2026-08-01'), findsOneWidget);
      expect(find.text('Vence 2026-08-31'), findsOneWidget);
      expect(find.text('L. 500.00'), findsOneWidget);
      expect(find.text('pendiente'), findsOneWidget);
    });

    testWidgets(
      'pago pendiente: muestra "Marcar como pagado", pago pagado: no',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_FakePagoRepository([_pagoPendiente, _pagoPagado])),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(FilledButton, 'Marcar como pagado'),
          findsOneWidget,
        );
      },
    );

    testWidgets('"Marcar como pagado" invalida el historial', (tester) async {
      final repository = _FakePagoRepository([_pagoPendiente]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Marcar como pagado'));
      await tester.pumpAndSettle();

      expect(repository.marcarPagadoCallCount, 1);
    });

    testWidgets('un error al marcar como pagado se muestra en un SnackBar', (
      tester,
    ) async {
      final repository = _FakePagoRepository(
        [_pagoPendiente],
        marcarPagadoError: const ApiException(
          statusCode: 400,
          message: 'No se pudo marcar el pago',
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Marcar como pagado'));
      await tester.pumpAndSettle();

      expect(find.text('No se pudo marcar el pago'), findsOneWidget);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin pagos"', (tester) async {
      await tester.pumpWidget(_wrap(_FakePagoRepository([])));
      await tester.pumpAndSettle();

      expect(find.text('No hay pagos registrados'), findsOneWidget);
    });

    testWidgets('FAB de nuevo pago llama onNuevoPago', (tester) async {
      var nuevoPagoCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          _FakePagoRepository([_pagoPendiente]),
          onNuevoPago: () => nuevoPagoCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Nuevo pago'));
      await tester.pumpAndSettle();

      expect(nuevoPagoCallCount, 1);
    });
  });
}
