import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/metodo_pago.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/clientes/data/datasources/cliente_remote_datasource.dart';
import 'package:zungofee_mobile/features/clientes/data/models/cliente.dart';
import 'package:zungofee_mobile/features/clientes/data/repositories/cliente_repository.dart';
import 'package:zungofee_mobile/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/ventas/data/datasources/ventas_remote_datasource.dart';
import 'package:zungofee_mobile/features/ventas/data/models/venta.dart';
import 'package:zungofee_mobile/features/ventas/data/repositories/ventas_repository.dart';
import 'package:zungofee_mobile/features/ventas/presentation/providers/ventas_providers.dart';
import 'package:zungofee_mobile/features/ventas/presentation/screens/venta_form_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeClienteRepository extends ClienteRepository {
  _FakeClienteRepository(this._clientes)
    : super(ClienteRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Cliente> _clientes;

  @override
  Future<List<Cliente>> getClientes() async => _clientes;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
    : super(CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._existencias)
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Lote> _existencias;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _existencias;
}

class _FakeVentasRepository extends VentasRepository {
  _FakeVentasRepository({this.crearError})
    : super(VentasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  int crearCallCount = 0;
  int? ultimoClienteId;
  int? ultimoMetodoPagoId;
  List<LineaVentaInput>? ultimasLineas;

  @override
  Future<Venta> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    crearCallCount++;
    ultimoClienteId = clienteId;
    ultimoMetodoPagoId = metodoPagoId;
    ultimasLineas = lineas;
    if (crearError != null) throw crearError!;
    return Venta(
      id: 30,
      tenantId: 5,
      clienteId: clienteId,
      usuarioId: 3,
      total: 750,
      anulada: false,
    );
  }
}

const _clienteDeEjemplo = Cliente(
  id: 7,
  tenantId: 5,
  nombre: 'Cafeteria El Buen Cafe',
  estado: true,
);

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [MetodoPago(id: 1, nombre: 'Efectivo')],
  variedadesCafe: [],
  nivelesAltura: [],
  estadosCafe: [],
  clientesTipo: [],
);

const _loteDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 10,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

Widget _wrap({
  required List<Cliente> clientes,
  required Catalogos catalogos,
  required List<Lote> existencias,
  required VentasRepository ventasRepository,
  VoidCallback? onGuardado,
}) {
  return ProviderScope(
    overrides: [
      clienteRepositoryProvider.overrideWithValue(
        _FakeClienteRepository(clientes),
      ),
      catalogosRepositoryProvider.overrideWithValue(
        _FakeCatalogosRepository(catalogos),
      ),
      lotesRepositoryProvider.overrideWithValue(
        _FakeLotesRepository(existencias),
      ),
      ventasRepositoryProvider.overrideWithValue(ventasRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: VentaFormScreen(onGuardado: onGuardado ?? () {}),
    ),
  );
}

/// El formulario es más alto que el viewport de test (vive en un
/// `SingleChildScrollView`), así que hay que desplazarlo antes de tocar
/// cualquier campo/botón que pueda estar fuera de pantalla — mismo helper
/// que `compra_form_screen_test.dart` (Sprint 6).
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

Future<void> _llenarPrimeraLinea(WidgetTester tester) async {
  await _seleccionarDropdown(
    tester,
    const Key('linea_0_lote'),
    'pergamino_seco · Catuai · Estandar (saldo: 10.00)',
  );
  await tester.ensureVisible(find.byKey(const Key('linea_0_cantidad')));
  await tester.enterText(find.byKey(const Key('linea_0_cantidad')), '5');
  await tester.ensureVisible(find.byKey(const Key('linea_0_precioUnitario')));
  await tester.enterText(
    find.byKey(const Key('linea_0_precioUnitario')),
    '150',
  );
}

void main() {
  group('VentaFormScreen', () {
    testWidgets(
      'éxito: llama crear() con los valores correctos y llama onGuardado',
      (tester) async {
        final repository = _FakeVentasRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            clientes: const [_clienteDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            existencias: const [_loteDeEjemplo],
            ventasRepository: repository,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_cliente'),
          'Cafeteria El Buen Cafe',
        );
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_metodo_pago'),
          'Efectivo',
        );
        await _llenarPrimeraLinea(tester);

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(repository.crearCallCount, 1);
        expect(repository.ultimoClienteId, 7);
        expect(repository.ultimoMetodoPagoId, 1);
        expect(repository.ultimasLineas, hasLength(1));
        expect(repository.ultimasLineas!.first.loteId, '78');
        expect(repository.ultimasLineas!.first.cantidad, 5);
        expect(repository.ultimasLineas!.first.precioUnitario, 150);
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('agregar línea añade una segunda línea al formulario', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          clientes: const [_clienteDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          existencias: const [_loteDeEjemplo],
          ventasRepository: _FakeVentasRepository(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('linea_1_lote')), findsNothing);

      await _tapVisible(tester, find.byKey(const Key('boton_agregar_linea')));

      expect(find.byKey(const Key('linea_1_lote')), findsOneWidget);
    });

    testWidgets('quitar línea la elimina del formulario', (tester) async {
      await tester.pumpWidget(
        _wrap(
          clientes: const [_clienteDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          existencias: const [_loteDeEjemplo],
          ventasRepository: _FakeVentasRepository(),
        ),
      );
      await tester.pumpAndSettle();

      await _tapVisible(tester, find.byKey(const Key('boton_agregar_linea')));
      expect(find.byKey(const Key('linea_1_lote')), findsOneWidget);

      await _tapVisible(tester, find.byKey(const Key('linea_1_quitar')));

      expect(find.byKey(const Key('linea_1_lote')), findsNothing);
    });

    testWidgets(
      'quitar la única línea muestra el mensaje de "agrega al menos una"',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            clientes: const [_clienteDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            existencias: const [_loteDeEjemplo],
            ventasRepository: _FakeVentasRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _tapVisible(tester, find.byKey(const Key('linea_0_quitar')));

        expect(find.text('Agrega al menos una línea'), findsOneWidget);
      },
    );

    testWidgets('validación: no envía el submit si no se selecciona cliente', (
      tester,
    ) async {
      final repository = _FakeVentasRepository();

      await tester.pumpWidget(
        _wrap(
          clientes: const [_clienteDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          existencias: const [_loteDeEjemplo],
          ventasRepository: repository,
        ),
      );
      await tester.pumpAndSettle();

      await _llenarPrimeraLinea(tester);

      await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

      expect(repository.crearCallCount, 0);
      expect(find.text('Selecciona un cliente'), findsOneWidget);
    });

    testWidgets(
      'un error de la API (saldo insuficiente) se muestra inline y no '
      'llama onGuardado',
      (tester) async {
        final repository = _FakeVentasRepository(
          crearError: const ApiException(
            statusCode: 400,
            message: 'Saldo insuficiente en lote 78',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            clientes: const [_clienteDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            existencias: const [_loteDeEjemplo],
            ventasRepository: repository,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_cliente'),
          'Cafeteria El Buen Cafe',
        );
        await _llenarPrimeraLinea(tester);

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(find.text('Saldo insuficiente en lote 78'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );
  });
}