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
import 'package:zungofee_mobile/features/catalogos/data/models/metodo_pago.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/nivel_altura.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/variedad_cafe.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/models/compra.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/compras/presentation/screens/compra_form_screen.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository(this._proveedores)
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Proveedor> _proveedores;

  @override
  Future<List<Proveedor>> getProveedores() async => _proveedores;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
    : super(CatalogosRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository({this.crearError})
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  int crearCallCount = 0;
  int? ultimoProveedorId;
  int? ultimoMetodoPagoId;
  List<LineaCompraInput>? ultimasLineas;

  @override
  Future<Compra> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    crearCallCount++;
    ultimoProveedorId = proveedorId;
    ultimoMetodoPagoId = metodoPagoId;
    ultimasLineas = lineas;
    if (crearError != null) throw crearError!;
    return Compra(
      id: 45,
      tenantId: 5,
      proveedorId: proveedorId,
      usuarioId: 3,
      fecha: DateTime.parse('2026-08-01T00:00:00.000Z'),
      total: 1200,
      anulada: false,
    );
  }
}

const _proveedorDeEjemplo = Proveedor(
  id: 12,
  tenantId: 5,
  nombre: 'Don Chepe Martinez',
  estado: true,
);

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [MetodoPago(id: 1, nombre: 'Efectivo')],
  variedadesCafe: [VariedadCafe(id: 1, nombre: 'Catuai')],
  nivelesAltura: [NivelAltura(id: 1, nombre: 'Estandar')],
  estadosCafe: [
    EstadoCafeCatalogo(id: 1, nombre: 'uva', unidadMedidaId: 1),
    // No comprable (no está en EstadoCafeId.compraValidos) — debe quedar
    // filtrado del selector.
    EstadoCafeCatalogo(id: 4, nombre: 'tostado_alto', unidadMedidaId: 1),
  ],
);

Widget _wrap({
  required List<Proveedor> proveedores,
  required Catalogos catalogos,
  required ComprasRepository comprasRepository,
  VoidCallback? onGuardado,
}) {
  return ProviderScope(
    overrides: [
      proveedorRepositoryProvider.overrideWithValue(
        _FakeProveedorRepository(proveedores),
      ),
      catalogosRepositoryProvider.overrideWithValue(
        _FakeCatalogosRepository(catalogos),
      ),
      comprasRepositoryProvider.overrideWithValue(comprasRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: CompraFormScreen(onGuardado: onGuardado ?? () {}),
    ),
  );
}

/// El formulario es más alto que el viewport de test (vive en un
/// `SingleChildScrollView`), así que hay que desplazarlo antes de tocar
/// cualquier campo/botón que pueda estar fuera de pantalla.
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
  await _seleccionarDropdown(tester, const Key('linea_0_estado'), 'uva');
  await _seleccionarDropdown(tester, const Key('linea_0_variedad'), 'Catuai');
  await _seleccionarDropdown(tester, const Key('linea_0_altura'), 'Estandar');
  await tester.ensureVisible(find.byKey(const Key('linea_0_humedad')));
  await tester.enterText(find.byKey(const Key('linea_0_humedad')), '11.5');
  await tester.ensureVisible(find.byKey(const Key('linea_0_cantidad')));
  await tester.enterText(find.byKey(const Key('linea_0_cantidad')), '10');
  await tester.ensureVisible(find.byKey(const Key('linea_0_costoUnitario')));
  await tester.enterText(
    find.byKey(const Key('linea_0_costoUnitario')),
    '120',
  );
}

void main() {
  group('CompraFormScreen', () {
    testWidgets(
      'éxito: llama crear() con los valores correctos y llama onGuardado',
      (tester) async {
        final repository = _FakeComprasRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            proveedores: const [_proveedorDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            comprasRepository: repository,
            onGuardado: () => guardadoCallCount++,
          ),
        );
        await tester.pumpAndSettle();

        await _seleccionarDropdown(
          tester,
          const Key('dropdown_proveedor'),
          'Don Chepe Martinez',
        );
        await _seleccionarDropdown(
          tester,
          const Key('dropdown_metodo_pago'),
          'Efectivo',
        );
        await _llenarPrimeraLinea(tester);

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(repository.crearCallCount, 1);
        expect(repository.ultimoProveedorId, 12);
        expect(repository.ultimoMetodoPagoId, 1);
        expect(repository.ultimasLineas, hasLength(1));
        expect(repository.ultimasLineas!.first.estadoCafeId, 1);
        expect(repository.ultimasLineas!.first.variedadId, 1);
        expect(repository.ultimasLineas!.first.alturaId, 1);
        expect(repository.ultimasLineas!.first.humedad, 11.5);
        expect(repository.ultimasLineas!.first.cantidad, 10);
        expect(repository.ultimasLineas!.first.costoUnitario, 120);
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets(
      'el selector de estado del café solo muestra los estados comprables',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            proveedores: const [_proveedorDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            comprasRepository: _FakeComprasRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _tapVisible(tester, find.byKey(const Key('linea_0_estado')));

        expect(find.text('uva'), findsOneWidget);
        expect(find.text('tostado_alto'), findsNothing);
      },
    );

    testWidgets('agregar línea añade una segunda línea al formulario', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          proveedores: const [_proveedorDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          comprasRepository: _FakeComprasRepository(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('linea_1_estado')), findsNothing);

      await _tapVisible(tester, find.byKey(const Key('boton_agregar_linea')));

      expect(find.byKey(const Key('linea_1_estado')), findsOneWidget);
    });

    testWidgets('quitar línea la elimina del formulario', (tester) async {
      await tester.pumpWidget(
        _wrap(
          proveedores: const [_proveedorDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          comprasRepository: _FakeComprasRepository(),
        ),
      );
      await tester.pumpAndSettle();

      await _tapVisible(tester, find.byKey(const Key('boton_agregar_linea')));
      expect(find.byKey(const Key('linea_1_estado')), findsOneWidget);

      await _tapVisible(tester, find.byKey(const Key('linea_1_quitar')));

      expect(find.byKey(const Key('linea_1_estado')), findsNothing);
    });

    testWidgets(
      'quitar la única línea muestra el mensaje de "agrega al menos una"',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            proveedores: const [_proveedorDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            comprasRepository: _FakeComprasRepository(),
          ),
        );
        await tester.pumpAndSettle();

        await _tapVisible(tester, find.byKey(const Key('linea_0_quitar')));

        expect(find.text('Agrega al menos una línea'), findsOneWidget);
      },
    );

    testWidgets(
      'validación: no envía el submit si no se selecciona proveedor',
      (tester) async {
        final repository = _FakeComprasRepository();

        await tester.pumpWidget(
          _wrap(
            proveedores: const [_proveedorDeEjemplo],
            catalogos: _catalogosDeEjemplo,
            comprasRepository: repository,
          ),
        );
        await tester.pumpAndSettle();

        await _llenarPrimeraLinea(tester);

        await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

        expect(repository.crearCallCount, 0);
        expect(find.text('Selecciona un proveedor'), findsOneWidget);
      },
    );

    testWidgets('un error de la API se muestra inline y no llama onGuardado', (
      tester,
    ) async {
      final repository = _FakeComprasRepository(
        crearError: const ApiException(
          statusCode: 400,
          message: 'El proveedor no existe',
        ),
      );
      var guardadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(
          proveedores: const [_proveedorDeEjemplo],
          catalogos: _catalogosDeEjemplo,
          comprasRepository: repository,
          onGuardado: () => guardadoCallCount++,
        ),
      );
      await tester.pumpAndSettle();

      await _seleccionarDropdown(
        tester,
        const Key('dropdown_proveedor'),
        'Don Chepe Martinez',
      );
      await _llenarPrimeraLinea(tester);

      await _tapVisible(tester, find.widgetWithText(FilledButton, 'Guardar'));

      expect(find.text('El proveedor no existe'), findsOneWidget);
      expect(guardadoCallCount, 0);
    });
  });
}
