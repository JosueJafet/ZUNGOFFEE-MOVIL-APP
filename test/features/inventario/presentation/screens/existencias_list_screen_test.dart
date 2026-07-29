import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/unidad_medida.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
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
    final index =
        callCount < _responses.length ? callCount : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
      : super(
            CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [],
  variedadesCafe: [],
  nivelesAltura: [],
  estadosCafe: [],
  clientesTipo: [],
  unidadesMedida: [UnidadMedida(id: 2, nombre: 'Libras')],
);

// `cantidadInicial` distinto de `saldo` a propósito: el ítem ahora
// muestra ambos valores a la vez (antes solo el saldo), así que si
// fueran iguales un `find.text('10.00')` no podría distinguir cuál de
// los dos encontró.
const _loteDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 15,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

const _loteAgotado = Lote(
  id: '99',
  saldo: 0,
  cantidadInicial: 12,
  estadoCafeNombre: 'molido',
  unidadMedidaId: 2,
  variedadNombre: 'Bourbon',
  nivelAlturaNombre: 'Estricta',
);

Widget _wrap(
  LotesRepository lotesRepository, {
  Catalogos catalogos = _catalogosDeEjemplo,
}) {
  return ProviderScope(
    overrides: [
      lotesRepositoryProvider.overrideWithValue(lotesRepository),
      catalogosRepositoryProvider.overrideWithValue(
        _FakeCatalogosRepository(catalogos),
      ),
    ],
    child:
        MaterialApp(theme: AppTheme.light, home: const ExistenciasListScreen()),
  );
}

void main() {
  group('ExistenciasListScreen', () {
    testWidgets(
      'lista con datos: muestra número de lote, variedad, altura, estado, '
      'unidad, cantidad inicial y saldo',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_FakeLotesRepository([
            () async => [_loteDeEjemplo]
          ])),
        );
        await tester.pumpAndSettle();

        expect(find.text('Lote #78'), findsOneWidget);
        expect(find.text('Catuai · Estandar'), findsOneWidget);
        expect(find.text('Pergamino seco'), findsOneWidget);
        expect(find.text('Libras'), findsOneWidget);
        expect(find.text('15.00'), findsOneWidget);
        expect(find.text('10.00'), findsOneWidget);
      },
    );

    testWidgets(
      'un lote sin variedad ni nivel de altura muestra el texto de '
      'fallback en vez de reventar',
      (tester) async {
        const loteSinVariedadNiAltura = Lote(
          id: '13',
          saldo: 8,
          cantidadInicial: 8,
          estadoCafeNombre: 'pergamino_seco',
          unidadMedidaId: 2,
        );

        await tester.pumpWidget(
          _wrap(
            _FakeLotesRepository([
              () async => [loteSinVariedadNiAltura],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sin variedad · Sin nivel'), findsOneWidget);
      },
    );

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

    testWidgets(
      'filtro "Disponible" (por defecto) oculta los lotes con saldo 0',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeLotesRepository([
              () async => [_loteDeEjemplo, _loteAgotado],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Lote #78'), findsOneWidget);
        expect(find.text('Lote #99'), findsNothing);
      },
    );

    testWidgets(
      '"Todos los lotes" muestra también los que tienen saldo 0',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeLotesRepository([
              () async => [_loteDeEjemplo, _loteAgotado],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Todos los lotes'));
        await tester.pumpAndSettle();

        expect(find.text('Lote #78'), findsOneWidget);
        expect(find.text('Lote #99'), findsOneWidget);
      },
    );
  });
}
