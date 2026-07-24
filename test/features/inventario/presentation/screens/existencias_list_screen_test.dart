import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/inventario/presentation/screens/existencias_list_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// Responde con la próxima función de [_responses] en cada llamada (se
/// queda en la última una vez agotadas) — mismo patrón de
/// `home_screen_test.dart` para simular error -> reintentar -> data.
class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._responses)
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<List<Lote>> Function()> _responses;
  int callCount = 0;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) {
    final index = callCount < _responses.length
        ? callCount
        : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }
}

const _loteDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 10,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

Widget _wrap(LotesRepository lotesRepository) {
  return ProviderScope(
    overrides: [lotesRepositoryProvider.overrideWithValue(lotesRepository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const ExistenciasListScreen(),
    ),
  );
}

void main() {
  group('ExistenciasListScreen', () {
    testWidgets('lista con datos: muestra variedad, altura, estado y saldo', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_FakeLotesRepository([() async => [_loteDeEjemplo]])),
      );
      await tester.pumpAndSettle();

      expect(find.text('Catuai · Estandar'), findsOneWidget);
      expect(find.text('pergamino_seco'), findsOneWidget);
      expect(find.text('10.00'), findsOneWidget);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin existencias"', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakeLotesRepository([() async => []])));
      await tester.pumpAndSettle();

      expect(find.text('No hay existencias registradas'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeLotesRepository([
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
          _FakeLotesRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir las existencias tras un error', (
      tester,
    ) async {
      final repository = _FakeLotesRepository([
        () async => throw const ApiException(
          statusCode: 500,
          message: 'Error del servidor',
        ),
        () async => [_loteDeEjemplo],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Catuai · Estandar'), findsOneWidget);
      expect(repository.callCount, 2);
    });
  });
}
