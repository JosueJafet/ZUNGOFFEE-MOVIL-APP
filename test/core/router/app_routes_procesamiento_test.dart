import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/router/app_routes.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/catalogos/data/datasources/catalogos_remote_datasource.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/catalogos.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/estado_cafe_catalogo.dart';
import 'package:zungofee_mobile/features/catalogos/data/models/unidad_medida.dart';
import 'package:zungofee_mobile/features/catalogos/data/repositories/catalogos_repository.dart';
import 'package:zungofee_mobile/features/catalogos/presentation/providers/catalogos_providers.dart';
import 'package:zungofee_mobile/features/inventario/data/datasources/lotes_remote_datasource.dart';
import 'package:zungofee_mobile/features/inventario/data/models/lote.dart';
import 'package:zungofee_mobile/features/inventario/data/repositories/lotes_repository.dart';
import 'package:zungofee_mobile/features/inventario/presentation/providers/lotes_providers.dart';
import 'package:zungofee_mobile/features/inventario/presentation/screens/existencias_list_screen.dart';
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/models/procesamiento.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/screens/procesamiento_form_screen.dart';

/// Estos tests ejercitan la navegación real de `AppRoutes` (Sprint 8,
/// Task 5) para `/procesamiento/formulario`, usando un `GoRouter`
/// construido directamente con `AppRoutes.routes` — mismo enfoque que
/// `app_routes_compras_inventario_test.dart` (Sprint 6) y
/// `app_routes_clientes_ventas_test.dart` (Sprint 7).
class _FakeLotesRepository extends LotesRepository {
  _FakeLotesRepository(this._lotes)
      : super(LotesRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final List<Lote> _lotes;

  @override
  Future<List<Lote>> getExistencias({int page = 1, int pageSize = 20}) async =>
      _lotes;
}

class _FakeCatalogosRepository extends CatalogosRepository {
  _FakeCatalogosRepository(this._catalogos)
      : super(CatalogosRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Catalogos _catalogos;

  @override
  Future<Catalogos> getCatalogos() async => _catalogos;
}

class _FakeProcesamientoRepository extends ProcesamientoRepository {
  _FakeProcesamientoRepository({this.crearError})
      : super(
          ProcesamientoRemoteDataSource(ApiClient(FakeSessionTokenProvider())),
        );

  final Object? crearError;

  @override
  Future<Procesamiento> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
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

const _loteDeEjemplo = Lote(
  id: '78',
  saldo: 10,
  cantidadInicial: 10,
  estadoCafeNombre: 'pergamino_seco',
  unidadMedidaId: 2,
  variedadNombre: 'Catuai',
  nivelAlturaNombre: 'Estandar',
);

const _catalogosDeEjemplo = Catalogos(
  metodosPago: [],
  variedadesCafe: [],
  nivelesAltura: [],
  clientesTipo: [],
  estadosCafe: [
    EstadoCafeCatalogo(id: 1, nombre: 'uva', unidadMedidaId: 1),
    EstadoCafeCatalogo(id: 2, nombre: 'humedo', unidadMedidaId: 2),
    EstadoCafeCatalogo(id: 3, nombre: 'pergamino_seco', unidadMedidaId: 2),
    EstadoCafeCatalogo(id: 4, nombre: 'tostado_alto', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 5, nombre: 'tostado_medio', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 6, nombre: 'tostado_bajo', unidadMedidaId: 3),
    EstadoCafeCatalogo(id: 7, nombre: 'molido', unidadMedidaId: 3),
  ],
  unidadesMedida: [
    UnidadMedida(id: 1, nombre: 'Galones'),
    UnidadMedida(id: 2, nombre: 'Quintales'),
    UnidadMedida(id: 3, nombre: 'Libras'),
  ],
);

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _llenarFormularioProcesamiento(WidgetTester tester) async {
  await _tapVisible(tester, find.byKey(const Key('dropdown_lote_origen')));
  await _tapVisible(
    tester,
    find.text('Catuai · Estandar (saldo: 10.00)').last,
  );
  await _tapVisible(tester, find.byKey(const Key('dropdown_estado_destino')));
  await _tapVisible(tester, find.text('Tostado alto').last);

  await tester.ensureVisible(find.byKey(const Key('cantidad_entrada')));
  await tester.enterText(find.byKey(const Key('cantidad_entrada')), '5');
  await tester.enterText(find.byKey(const Key('cantidad_salida')), '4');
}

void main() {
  group('AppRoutes — procesamiento (Sprint 8, Task 5)', () {
    Future<void> pumpRouter(
      WidgetTester tester, {
      required ProcesamientoRepository procesamientoRepository,
      required LotesRepository lotesRepository,
      String initialLocation = RoutePaths.procesamientoFormulario,
    }) async {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: AppRoutes.routes,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogosRepositoryProvider.overrideWithValue(
              _FakeCatalogosRepository(_catalogosDeEjemplo),
            ),
            lotesRepositoryProvider.overrideWithValue(lotesRepository),
            procesamientoRepositoryProvider.overrideWithValue(
              procesamientoRepository,
            ),
          ],
          child:
              MaterialApp.router(theme: AppTheme.light, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('/procesamiento/formulario muestra ProcesamientoFormScreen', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        procesamientoRepository: _FakeProcesamientoRepository(),
        lotesRepository: _FakeLotesRepository(const [_loteDeEjemplo]),
      );

      expect(find.byType(ProcesamientoFormScreen), findsOneWidget);
    });

    testWidgets(
      'guardar exitoso en /procesamiento/formulario: onGuardado hace pop '
      'de vuelta a la ruta anterior',
      (tester) async {
        final router = GoRouter(
          initialLocation: RoutePaths.existencias,
          routes: AppRoutes.routes,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              catalogosRepositoryProvider.overrideWithValue(
                _FakeCatalogosRepository(_catalogosDeEjemplo),
              ),
              lotesRepositoryProvider.overrideWithValue(
                _FakeLotesRepository(const [_loteDeEjemplo]),
              ),
              procesamientoRepositoryProvider.overrideWithValue(
                _FakeProcesamientoRepository(),
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.light,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Empuja el formulario sobre una ruta real ya en el stack
        // (`/inventario/existencias`, mismo patrón exacto que
        // `app_routes_compras_inventario_test.dart`, Sprint 6).
        router.push(RoutePaths.procesamientoFormulario);
        await tester.pumpAndSettle();
        expect(find.byType(ProcesamientoFormScreen), findsOneWidget);

        await _llenarFormularioProcesamiento(tester);
        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(ProcesamientoFormScreen), findsNothing);
        expect(find.byType(ExistenciasListScreen), findsOneWidget);
      },
    );

    testWidgets(
      'guardar con error en /procesamiento/formulario: NO hace pop, el '
      'formulario sigue mostrando el error',
      (tester) async {
        await pumpRouter(
          tester,
          procesamientoRepository: _FakeProcesamientoRepository(
            crearError: const ApiException(
              statusCode: 400,
              message: 'Transición de estado no permitida para este lote',
            ),
          ),
          lotesRepository: _FakeLotesRepository(const [_loteDeEjemplo]),
        );

        await _llenarFormularioProcesamiento(tester);
        await _tapVisible(
          tester,
          find.widgetWithText(FilledButton, 'Guardar'),
        );

        expect(find.byType(ProcesamientoFormScreen), findsOneWidget);
        expect(
          find.text('Transición de estado no permitida para este lote'),
          findsOneWidget,
        );
      },
    );
  });
}
