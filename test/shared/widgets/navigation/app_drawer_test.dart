import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/models/notificacion.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';
import 'package:zungofee_mobile/shared/widgets/navigation/app_drawer.dart';

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
      : super(PerfilRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;
}

class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository(this._notificaciones)
      : super(NotificacionesRemoteDataSource(
            ApiClient(FakeSessionTokenProvider())));

  final List<Notificacion> _notificaciones;

  @override
  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) async =>
      _notificaciones;
}

Perfil _perfilConRol(String rol) => Perfil(
      id: 7,
      nombre: 'Juan Pérez',
      activo: true,
      fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
      rol: rol,
      tenantId: rol == 'super_admin' ? null : 3,
      tenantNombre: rol == 'super_admin' ? null : 'Bodega Central',
    );

/// Ruta placeholder que registra en [visitas] cada vez que se construye,
/// para poder verificar a qué ruta navegó el drawer sin necesitar las
/// pantallas reales de cada módulo.
Widget _placeholder(String nombre, List<String> visitas) {
  visitas.add(nombre);
  return Scaffold(body: Text('Placeholder de $nombre'));
}

Future<GoRouter> _pumpConDrawerAbierto(
  WidgetTester tester, {
  required PerfilRepository perfilRepository,
  required List<String> visitas,
  List<Notificacion> notificaciones = const [],
}) async {
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => Scaffold(
          endDrawer: const AppDrawer(),
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                child: const Text('Abrir menú'),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.proveedores,
        builder: (context, state) => _placeholder('Proveedores', visitas),
      ),
      GoRoute(
        path: RoutePaths.existencias,
        builder: (context, state) => _placeholder('Existencias', visitas),
      ),
      GoRoute(
        path: RoutePaths.compraFormulario,
        builder: (context, state) => _placeholder('Registrar compra', visitas),
      ),
      GoRoute(
        path: RoutePaths.clientes,
        builder: (context, state) => _placeholder('Clientes', visitas),
      ),
      GoRoute(
        path: RoutePaths.ventaFormulario,
        builder: (context, state) => _placeholder('Registrar venta', visitas),
      ),
      GoRoute(
        path: RoutePaths.historialCompras,
        builder: (context, state) =>
            _placeholder('Historial de compras', visitas),
      ),
      GoRoute(
        path: RoutePaths.historialVentas,
        builder: (context, state) =>
            _placeholder('Historial de ventas', visitas),
      ),
      GoRoute(
        path: RoutePaths.procesamientoFormulario,
        builder: (context, state) => _placeholder('Procesar café', visitas),
      ),
      GoRoute(
        path: RoutePaths.historialProcesamiento,
        builder: (context, state) =>
            _placeholder('Historial de procesamiento', visitas),
      ),
      GoRoute(
        path: RoutePaths.notificaciones,
        builder: (context, state) => _placeholder('Notificaciones', visitas),
      ),
      GoRoute(
        path: RoutePaths.perfilEditar,
        builder: (context, state) => _placeholder('Editar perfil', visitas),
      ),
      GoRoute(
        path: RoutePaths.bodegas,
        builder: (context, state) => _placeholder('Bodegas', visitas),
      ),
      GoRoute(
        path: RoutePaths.solicitudes,
        builder: (context, state) => _placeholder('Solicitudes', visitas),
      ),
      GoRoute(
        path: RoutePaths.pagos,
        builder: (context, state) => _placeholder('Pagos', visitas),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        perfilRepositoryProvider.overrideWithValue(perfilRepository),
        notificacionesRepositoryProvider.overrideWithValue(
          _FakeNotificacionesRepository(notificaciones),
        ),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.widgetWithText(FilledButton, 'Abrir menú'));
  await tester.pumpAndSettle();

  return router;
}

void main() {
  group('AppDrawer', () {
    testWidgets(
      'admin_bodega/empleado: muestra los 11 módulos operativos + Cuenta',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
          visitas: [],
        );

        for (final modulo in [
          'Inicio',
          'Proveedores',
          'Ver existencias',
          'Registrar compra',
          'Clientes',
          'Registrar venta',
          'Historial de compras',
          'Historial de ventas',
          'Procesar café',
          'Historial de procesamiento',
          'Notificaciones',
          'Editar perfil',
        ]) {
          await tester.scrollUntilVisible(find.text(modulo), 100);
          expect(find.text(modulo), findsOneWidget, reason: modulo);
        }
        expect(find.text('Bodegas'), findsNothing);
        expect(find.text('Solicitudes'), findsNothing);
        expect(find.text('Pagos'), findsNothing);
      },
    );

    testWidgets(
      'super_admin: muestra Bodegas/Solicitudes/Pagos + Cuenta, sin los '
      'módulos operativos',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('super_admin')),
          visitas: [],
        );

        for (final modulo in [
          'Inicio',
          'Bodegas',
          'Solicitudes',
          'Pagos',
          'Notificaciones',
          'Editar perfil',
        ]) {
          await tester.scrollUntilVisible(find.text(modulo), 100);
          expect(find.text(modulo), findsOneWidget, reason: modulo);
        }
        expect(find.text('Proveedores'), findsNothing);
        expect(find.text('Registrar compra'), findsNothing);
        expect(find.text('Clientes'), findsNothing);
        expect(find.text('Procesar café'), findsNothing);
      },
    );

    testWidgets('tocar un módulo cierra el drawer y navega a esa ruta', (
      tester,
    ) async {
      final visitas = <String>[];
      await _pumpConDrawerAbierto(
        tester,
        perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
        visitas: visitas,
      );

      await tester.scrollUntilVisible(find.text('Clientes'), 100);
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();

      expect(find.text('Placeholder de Clientes'), findsOneWidget);
      expect(visitas, ['Clientes']);
      // El drawer se cierra: ya no se puede tocar "Proveedores" (era del
      // drawer, no de la pantalla de Clientes).
      expect(find.text('Proveedores'), findsNothing);
    });

    testWidgets(
      'super_admin: tocar "Bodegas" cierra el drawer y navega',
      (tester) async {
        final visitas = <String>[];
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('super_admin')),
          visitas: visitas,
        );

        await tester.tap(find.text('Bodegas'));
        await tester.pumpAndSettle();

        expect(find.text('Placeholder de Bodegas'), findsOneWidget);
        expect(visitas, ['Bodegas']);
      },
    );

    testWidgets('muestra el nombre del perfil en el header una vez cargado', (
      tester,
    ) async {
      await _pumpConDrawerAbierto(
        tester,
        perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
        visitas: [],
      );

      expect(find.text('Juan Pérez'), findsOneWidget);
    });

    testWidgets(
      'muestra el rol de la sesión activa en el header, con la etiqueta '
      'legible de cada rol',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
          visitas: [],
        );
        expect(find.text('Empleado'), findsOneWidget);
      },
    );

    testWidgets(
      'admin_bodega: el header muestra "Administrador"',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol('admin_bodega'),
          ),
          visitas: [],
        );
        expect(find.text('Administrador'), findsOneWidget);
      },
    );

    testWidgets(
      'super_admin: el header muestra "Super admin"',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(
            _perfilConRol('super_admin'),
          ),
          visitas: [],
        );
        expect(find.text('Super admin'), findsOneWidget);
      },
    );

    testWidgets(
      'sin notificaciones sin leer: el badge de "Notificaciones" está oculto',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
          visitas: [],
          notificaciones: const [
            Notificacion(
              id: '1',
              titulo: 'Título',
              mensaje: 'Mensaje',
              leida: true,
            ),
          ],
        );

        await tester.scrollUntilVisible(find.text('Notificaciones'), 100);
        final badge = tester.widget<Badge>(find.byType(Badge));
        expect(badge.isLabelVisible, isFalse);
      },
    );

    testWidgets(
      'con notificaciones sin leer: el badge de "Notificaciones" se muestra',
      (tester) async {
        await _pumpConDrawerAbierto(
          tester,
          perfilRepository: _FakePerfilRepository(_perfilConRol('empleado')),
          visitas: [],
          notificaciones: const [
            Notificacion(
              id: '1',
              titulo: 'Título',
              mensaje: 'Mensaje',
              leida: false,
            ),
          ],
        );

        await tester.scrollUntilVisible(find.text('Notificaciones'), 100);
        final badge = tester.widget<Badge>(find.byType(Badge));
        expect(badge.isLabelVisible, isTrue);
      },
    );
  });
}
