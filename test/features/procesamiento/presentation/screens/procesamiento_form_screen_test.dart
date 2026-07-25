import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/estado_cafe_catalogo.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/models/procesamiento.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/screens/procesamiento_form_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._existencias)
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Lote> _existencias;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _existencias;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
    : super(CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

class _FakeProcesamientoRepository extends ProcesamientoRepository {
  _FakeProcesamientoRepository({this.crearError})
    : super(
        ProcesamientoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final Object? crearError;
  int crearCallCount = 0;
  String? ultimoLoteOrigenId;
  int? ultimoEstadoDestinoId;
  double? ultimaCantidadEntrada;
  double? ultimaCantidadSalida;

  @override
  Future<Procesamiento> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    crearCallCount++;
    ultimoLoteOrigenId = loteOrigenId;
    ultimoEstadoDestinoId = estadoDestinoId;
    ultimaCantidadEntrada = cantidadEntrada;
    ultimaCantidadSalida = cantidadSalida;
    if (crearError != null) throw crearError!;
    return Procesamiento(
      id: '9',
      tenantId: 5,
      loteOrigenId: loteOrigenId,
      loteDestinoId: '80',
      cantidadEntrada: cantidadEntrada,
      cantidadSalida: cantidadSalida,
    );
  }
}

const _loteUvaDeEjemplo = Lote(
  id: '50',
  saldo: 20,
  cantidadInicial: 20,
  estadoCafeNombre: 'uva',
  unidadMedidaId: 1,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

const _lotePergaminoDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 10,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

const _loteTostadoDeEjemplo = Lote(
  id: '79',
  saldo: 3,
  cantidadInicial: 5,
  estadoCafeNombre: 'tostado_alto',
  unidadMedidaId: 3,
  variedadNombre: 'Bourbon',
  nivelAlturaNombre: 'Estricta',
);

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [],
  variedadesCafe: [],
  nivelesAltura: [],
  clientesTipo: [],
  estadosCafe: [
    EstadoCafeCatalogo(id: 1, nombre: 'uva', unidadMedidaId: 1),
    EstadoCafeCatalogo(id: 3, nombre: 'pergamino_seco', unidadMedidaId: 2),
    EstadoCafeCatalogo(id: 4, nombre: 'tostado_alto', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 5, nombre: 'tostado_medio', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 6, nombre: 'tostado_bajo', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 7, nombre: 'molido', unidadMedidaId: 3),
  ],
);

Widget _wrap({
  required List<Lote> existencias,
  required ProcesamientoRepository procesamientoRepository,
  Catalogos catalogos = _catalogosDeEjemplo,
  VoidCallback? onGuardado,
}) {
  return ProviderScope(
    overrides: [
      lotesRepositoryProvider.overrideWithValue(
        _FakeLotesRepository(existencias),
      ),
      catalogosRepositoryProvider.overrideWithValue(
        _FakeCatalogosRepository(catalogos),
      ),
      procesamientoRepositoryProvider.overrideWithValue(
        procesamientoRepository,
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: ProcesamientoFormScreen(onGuardado: onGuardado ?? () {}),
    ),
  );
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _seleccionarDropdown(
  WidgetTester tester,
  Key dropdownKey,
  String opcion,
) async {
  await _tapVisible(tester, find.byKey(dropdownKey));
  await _tapVisible(tester, find.text(opcion).last);
}

void main() {
  group('ProcesamientoFormScreen', () {
    testWidgets(
      'el selector de lote origen no incluye lotes no procesables (uva)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            existencias: const [_loteUvaDeEjemplo, _lotePergaminoDeEjemplo],
            procesamientoRepository: _FakeProcesamientoRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _tapVisible(tester, find.byKey(const Key('dropdown_lote_origen')));

        expect(
          find.text('pergamino_seco · Catuai · Estandar (saldo: 10.00)'),
          findsOneWidget,
        );
        expect(
          find.text('uva · Catuai · Estandar (saldo: 20.00)'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'el selector de destino solo lista transiciones válidas para el origen',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            existencias: const [_lotePergaminoDeEjemplo],
            procesamientoRepository: _FakeProcesamientoRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'pergamino_seco · Catuai · Estandar (saldo: 10.00)',
        );

        await _tapVisible(
          tester,
          find.byKey(const Key('dropdown_estado_destino')),
        );

        // pergamino_seco solo puede ir a tostado (alto/medio/bajo), nunca
        // directo a molido.
        expect(find.text('tostado_alto'), findsOneWidget);
        expect(find.text('tostado_medio'), findsOneWidget);
        expect(find.text('tostado_bajo'), findsOneWidget);
        expect(find.text('molido'), findsNothing);
      },
    );

    testWidgets(
      'cambiar el lote origen tras elegir un destino resetea el destino '
      'seleccionado (no solo la lista de opciones)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            existencias: const [
              _lotePergaminoDeEjemplo,
              _loteTostadoDeEjemplo,
            ],
            procesamientoRepository: _FakeProcesamientoRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'pergamino_seco · Catuai · Estandar (saldo: 10.00)',
        );
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_estado_destino'),
          'tostado_medio',
        );

        // Cambia el origen a uno cuyos destinos válidos ya NO incluyen
        // "tostado_medio" (tostado_alto -> solo molido).
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'tostado_alto · Bourbon · Estricta (saldo: 3.00)',
        );

        // Con el dropdown CERRADO: si el valor interno no se hubiera
        // reseteado, seguiría mostrando "tostado_medio" como selección
        // actual aunque ya no esté en items.
        expect(find.text('tostado_medio'), findsNothing);

        // Si el submit pasa sin volver a elegir destino, el valor interno
        // no se reseteó de verdad (solo cambió visualmente la lista).
        await tester.enterText(find.byKey(const Key('cantidad_entrada')), '5');
        await tester.enterText(find.byKey(const Key('cantidad_salida')), '4');
        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));
        expect(find.text('Selecciona un destino'), findsOneWidget);
      },
    );

    testWidgets(
      'cambiar el lote origen (tostado) solo ofrece molido como destino',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            existencias: const [_loteTostadoDeEjemplo],
            procesamientoRepository: _FakeProcesamientoRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'tostado_alto · Bourbon · Estricta (saldo: 3.00)',
        );

        await _tapVisible(
          tester,
          find.byKey(const Key('dropdown_estado_destino')),
        );

        expect(find.text('molido'), findsOneWidget);
        expect(find.text('tostado_medio'), findsNothing);
      },
    );

    testWidgets('muestra el rendimiento estimado en vivo', (tester) async {
      await tester.pumpWidget(
        _wrap(
          existencias: const [_lotePergaminoDeEjemplo],
          procesamientoRepository: _FakeProcesamientoRepository(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Rendimiento estimado'), findsNothing);

      await tester.enterText(find.byKey(const Key('cantidad_entrada')), '10');
      await tester.pump();
      expect(find.textContaining('Rendimiento estimado'), findsNothing);

      await tester.enterText(find.byKey(const Key('cantidad_salida')), '5');
      await tester.pump();

      expect(find.text('Rendimiento estimado: 50.0%'), findsOneWidget);
    });

    testWidgets(
      'éxito: llama crear() con los valores correctos y llama onGuardado',
      (tester) async {
        final repository = _FakeProcesamientoRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            existencias: const [_lotePergaminoDeEjemplo],
            procesamientoRepository: repository,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'pergamino_seco · Catuai · Estandar (saldo: 10.00)',
        );
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_estado_destino'),
          'tostado_alto',
        );
        await tester.enterText(find.byKey(const Key('cantidad_entrada')), '5');
        await tester.enterText(find.byKey(const Key('cantidad_salida')), '4');

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(repository.crearCallCount, 1);
        expect(repository.ultimoLoteOrigenId, '78');
        expect(repository.ultimoEstadoDestinoId, 4);
        expect(repository.ultimaCantidadEntrada, 5);
        expect(repository.ultimaCantidadSalida, 4);
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets(
      'validación: no envía el submit si no se selecciona lote origen',
      (tester) async {
        final repository = _FakeProcesamientoRepository();

        await tester.pumpWidget(
          _wrap(
            existencias: const [_lotePergaminoDeEjemplo],
            procesamientoRepository: repository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('cantidad_entrada')), '5');
        await tester.enterText(find.byKey(const Key('cantidad_salida')), '4');

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(repository.crearCallCount, 0);
        expect(find.text('Selecciona un lote'), findsOneWidget);
      },
    );

    testWidgets(
      'un error de la API (transición inválida) se muestra inline y no '
      'llama onGuardado',
      (tester) async {
        final repository = _FakeProcesamientoRepository(
          crearError: const ApiException(
            statusCode: 400,
            message: 'Transición de estado no permitida para este lote',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            existencias: const [_lotePergaminoDeEjemplo],
            procesamientoRepository: repository,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_lote_origen'),
          'pergamino_seco · Catuai · Estandar (saldo: 10.00)',
        );
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_estado_destino'),
          'tostado_alto',
        );
        await tester.enterText(find.byKey(const Key('cantidad_entrada')), '5');
        await tester.enterText(find.byKey(const Key('cantidad_salida')), '4');

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(
          find.text('Transición de estado no permitida para este lote'),
          findsOneWidget,
        );
        expect(guardadoCallCount, 0);
      },
    );
  });
}
