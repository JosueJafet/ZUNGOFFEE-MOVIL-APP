import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pagos_resumen.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';
import 'package:zungofee_mobile/features/pagos/presentation/screens/pagos_resumen_screen.dart';

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository({this.resumenError})
    : super(PagoRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? resumenError;

  static const _resumen = PagosResumen(
    tenantsActivos: 16,
    tenantsSuspendidos: 2,
    ingresosMesActual: 1000,
    ingresosTotales: 2500.5,
  );

  @override
  Future<PagosResumen> getResumen() async {
    if (resumenError != null) throw resumenError!;
    return _resumen;
  }
}

class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository(this._bodegas)
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Bodega> _bodegas;

  @override
  Future<List<Bodega>> getBodegas() async => _bodegas;
}

final _bodega = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

Widget _wrap({
  PagoRepository? pagoRepository,
  BodegaRepository? bodegaRepository,
  void Function(Bodega)? onVerHistorial,
}) {
  return ProviderScope(
    overrides: [
      pagoRepositoryProvider.overrideWithValue(
        pagoRepository ?? _FakePagoRepository(),
      ),
      bodegaRepositoryProvider.overrideWithValue(
        bodegaRepository ?? _FakeBodegaRepository([_bodega]),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PagosResumenScreen(onVerHistorial: onVerHistorial ?? (_) {}),
    ),
  );
}

void main() {
  group('PagosResumenScreen', () {
    testWidgets('muestra los KPIs y la lista de bodegas', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('16'), findsOneWidget);
      expect(find.text('Bodegas activas'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Bodegas suspendidas'), findsOneWidget);
      expect(find.text('L. 1000.00'), findsOneWidget);
      expect(find.text('L. 2500.50'), findsOneWidget);
      expect(find.text('Bodega de Prueba'), findsOneWidget);
    });

    testWidgets('"Ver historial de pagos" llama onVerHistorial con la bodega', (
      tester,
    ) async {
      Bodega? recibida;

      await tester.pumpWidget(
        _wrap(onVerHistorial: (bodega) => recibida = bodega),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.widgetWithText(TextButton, 'Ver historial de pagos'),
      );
      await tester.tap(find.widgetWithText(TextButton, 'Ver historial de pagos'));
      await tester.pumpAndSettle();

      expect(recibida, _bodega);
    });

    testWidgets('un error al cargar el resumen muestra su mensaje', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          pagoRepository: _FakePagoRepository(
            resumenError: const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.text('Bodega de Prueba'), findsOneWidget);
    });

    testWidgets('lista de bodegas vacía: muestra el mensaje correspondiente', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(bodegaRepository: _FakeBodegaRepository([])));
      await tester.pumpAndSettle();

      expect(find.text('No hay bodegas registradas'), findsOneWidget);
    });
  });
}
