import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pago_form_screen.dart';

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository({this.registrarError})
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? registrarError;
  int registrarCallCount = 0;
  int? tenantIdRecibido;
  double? montoRecibido;

  @override
  Future<void> registrar({
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
  }) async {
    registrarCallCount++;
    tenantIdRecibido = tenantId;
    montoRecibido = monto;
    if (registrarError != null) throw registrarError!;
  }
}

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

Widget _wrap(PagoRepository repository, {VoidCallback? onGuardado}) {
  return ProviderScope(
    overrides: [pagoRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PagoFormScreen(bodega: _bodega, onGuardado: onGuardado ?? () {}),
    ),
  );
}

/// Confirma el `showDatePicker` con la fecha inicial (hoy), tocando el
/// botón "OK" del diálogo — no navega el calendario, solo confirma la
/// selección por defecto.
Future<void> _confirmarDatePicker(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  group('PagoFormScreen', () {
    testWidgets('muestra los 3 campos: periodo, vencimiento y monto', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakePagoRepository()));

      expect(
        find.widgetWithText(AppBar, 'Nuevo pago — Bodega de Prueba'),
        findsOneWidget,
      );
      expect(find.text('Periodo'), findsOneWidget);
      expect(find.text('Fecha de vencimiento'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Monto'), findsOneWidget);
    });

    testWidgets(
      'al abrir la pantalla no muestra los mensajes de "selecciona una '
      'fecha" antes de intentar guardar',
      (tester) async {
        await tester.pumpWidget(_wrap(_FakePagoRepository()));

        expect(find.text('Selecciona el periodo'), findsNothing);
        expect(find.text('Selecciona la fecha de vencimiento'), findsNothing);
      },
    );

    testWidgets(
      'no envía el submit si falta seleccionar fechas o el monto está '
      'vacío',
      (tester) async {
        final repository = _FakePagoRepository();

        await tester.pumpWidget(_wrap(repository));

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.registrarCallCount, 0);
        expect(find.text('Selecciona el periodo'), findsOneWidget);
        expect(find.text('Selecciona la fecha de vencimiento'), findsOneWidget);
        expect(find.text('Ingresa el monto'), findsOneWidget);
      },
    );

    testWidgets('monto no numérico o negativo no pasa la validación', (
      tester,
    ) async {
      final repository = _FakePagoRepository();

      await tester.pumpWidget(_wrap(repository));

      await tester.tap(find.text('Periodo'));
      await _confirmarDatePicker(tester);
      await tester.tap(find.text('Fecha de vencimiento'));
      await _confirmarDatePicker(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Monto'),
        '-5',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.registrarCallCount, 0);
      expect(find.text('Ingresa un monto válido'), findsOneWidget);
    });

    testWidgets(
      'éxito: llama registrar() con tenantId y monto correctos, y llama '
      'onGuardado',
      (tester) async {
        final repository = _FakePagoRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
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

        expect(repository.registrarCallCount, 1);
        expect(repository.tenantIdRecibido, 5);
        expect(repository.montoRecibido, 123.45);
        expect(guardadoCallCount, 1);
        expect(find.text('Pago registrado con éxito.'), findsOneWidget);
      },
    );

    testWidgets('un error de la API se muestra inline y no llama onGuardado', (
      tester,
    ) async {
      final repository = _FakePagoRepository(
        registrarError: const ApiException(
          statusCode: 400,
          message: 'El monto es inválido',
        ),
      );
      var guardadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(repository, onGuardado: () => guardadoCallCount++),
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

      expect(find.text('El monto es inválido'), findsOneWidget);
      expect(guardadoCallCount, 0);
    });
  });
}
