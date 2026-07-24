import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
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
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/inventario/presentation/screens/existencias_list_screen.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` (Sprint 6,
/// Task 8) para `/compras/formulario` y `/inventario/existencias`, usando
/// un `GoRouter` construido directamente con `AppRoutes.routes` — mismo
/// enfoque que `app_routes_proveedores_test.dart` (Sprint 5, Task 6): el
/// guard de sesión no es responsabilidad de este Task, ya está cubierto
/// por `auth_redirect_test.dart`.
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

  @override
  Future<Compra> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
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

class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._lotes)
    : super(LotesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Lote> _lotes;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _lotes;
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
  estadosCafe: [EstadoCafeCatalogo(id: 1, nombre: 'uva', unidadMedidaId: 1)],
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

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _llenarFormularioCompra(WidgetTester tester) async {
  await _tapVisible(tester, find.byKey(const Key('dropdown_proveedor')));
  await _tapVisible(tester, find.text('Don Chepe Martinez').last);

  await _tapVisible(tester, find.byKey(const Key('linea_0_estado')));
  await _tapVisible(tester, find.text('uva').last);
  await _tapVisible(tester, find.byKey(const Key('linea_0_variedad')));
  await _tapVisible(tester, find.text('Catuai').last);
  await _tapVisible(tester, find.byKey(const Key('linea_0_altura')));
  await _tapVisible(tester, find.text('Estandar').last);

  await tester.ensureVisible(find.byKey(const Key('linea_0_humedad')));
  await tester.enterText(find.byKey(const Key('linea_0_humedad')), '11.5');
  await tester.enterText(find.byKey(const Key('linea_0_cantidad')), '10');
  await tester.enterText(
    find.byKey(const Key('linea_0_costoUnitario')),
    '120',
  );
}

void main() {
  group('AppRoutes — compras/inventario (Sprint 6, Task 8)', () {
    Future<void> pumpRouter(
      WidgetTester tester, {
      required ComprasRepository comprasRepository,
      required LotesRepository lotesRepository,
      String initialLocation = RoutePaths.compraFormulario,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            proveedorRepositoryProvider.overrideWithValue(
              _FakeProveedorRepository(const [_proveedorDeEjemplo]),
            ),
            catalogosRepositoryProvider.overrideWithValue(
              _FakeCatalogosRepository(_catalogosDeEjemplo),
            ),
            comprasRepositoryProvider.overrideWithValue(comprasRepository),
            lotesRepositoryProvider.overrideWithValue(lotesRepository),
          ],
          child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('/compras/formulario muestra CompraFormScreen', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        comprasRepository: _FakeComprasRepository(),
        lotesRepository: _FakeLotesRepository(const []),
      );

      expect(find.byType(CompraFormScreen), findsOneWidget);
    });

    testWidgets('/inventario/existencias muestra ExistenciasListScreen con datos', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        comprasRepository: _FakeComprasRepository(),
        lotesRepository: _FakeLotesRepository(const [_loteDeEjemplo]),
        initialLocation: RoutePaths.existencias,
      );

      expect(find.byType(ExistenciasListScreen), findsOneWidget);
      expect(find.text('Catuai · Estandar'), findsOneWidget);
    });

    testWidgets(
      'guardar exitoso en /compras/formulario: onGuardado hace pop de '
      'vuelta a la ruta anterior',
      (tester) async {
        final router = GoRouter(
          initialLocation: RoutePaths.existencias,
          routes: AppRoutes.routes,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              proveedorRepositoryProvider.overrideWithValue(
                _FakeProveedorRepository(const [_proveedorDeEjemplo]),
              ),
              catalogosRepositoryProvider.overrideWithValue(
                _FakeCatalogosRepository(_catalogosDeEjemplo),
              ),
              comprasRepositoryProvider.overrideWithValue(
                _FakeComprasRepository(),
              ),
              lotesRepositoryProvider.overrideWithValue(
                _FakeLotesRepository(const []),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.light,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Empuja el formulario sobre una ruta real ya en el stack (mismo
        // patrón exacto que Task 6 haría desde `HomeScreen`), para que
        // el `pop()` de `onGuardado` tenga a dónde volver.
        router.push(RoutePaths.compraFormulario);
        await tester.pumpAndSettle();
        expect(find.byType(CompraFormScreen), findsOneWidget);

        await _llenarFormularioCompra(tester);
        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(CompraFormScreen), findsNothing);
        expect(find.byType(ExistenciasListScreen), findsOneWidget);
      },
    );

    testWidgets(
      'guardar con error en /compras/formulario: NO hace pop, el '
      'formulario sigue mostrando el error',
      (tester) async {
        await pumpRouter(
          tester,
          comprasRepository: _FakeComprasRepository(
            crearError: const ApiException(
              statusCode: 400,
              message: 'El proveedor no existe',
            ),
          ),
          lotesRepository: _FakeLotesRepository(const []),
        );

        await _llenarFormularioCompra(tester);
        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(CompraFormScreen), findsOneWidget);
        expect(find.text('El proveedor no existe'), findsOneWidget);
      },
    );
  });
}
