import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/constants/app_role.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/compras/data/datasources/compras_remote_datasource.dart';
import 'package:zungofee_mobile/features/compras/data/models/compra.dart';
import 'package:zungofee_mobile/features/compras/data/repositories/compras_repository.dart';
import 'package:zungofee_mobile/features/compras/presentation/providers/compras_providers.dart';
import 'package:zungofee_mobile/features/compras/presentation/screens/compras_historial_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;
}

class _FakeComprasRepository extends ComprasRepository {
  _FakeComprasRepository(this._responses)
    : super(ComprasRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<List<Compra>> Function()> _responses;
  int listarCallCount = 0;
  int anularCallCount = 0;
  Object? anularError;

  @override
  Future<List<Compra>> listar({int page = 1, int pageSize = 20}) {
    final index = listarCallCount < _responses.length
        ? listarCallCount
        : _responses.length - 1;
    listarCallCount++;
    return _responses[index]();
  }

  @override
  Future<void> anular(int id) async {
    anularCallCount++;
    if (anularError != null) throw anularError!;
  }
}

Perfil _perfilConRol(String rol) => Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: rol,
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

final _compraActiva = Compra(
  id: 45,
  tenantId: 5,
  proveedorId: 12,
  usuarioId: 3,
  fecha: DateTime.parse('2026-08-01T00:00:00.000Z'),
  total: 1200,
  anulada: false,
);

final _compraAnulada = Compra(
  id: 46,
  tenantId: 5,
  proveedorId: 12,
  usuarioId: 3,
  fecha: DateTime.parse('2026-08-02T00:00:00.000Z'),
  total: 500,
  anulada: true,
);

Widget _wrap({
  required PerfilRepository perfilRepository,
  required ComprasRepository comprasRepository,
  required AuthRepository authRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      comprasRepositoryProvider.overrideWithValue(comprasRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const ComprasHistorialScreen(),
    ),
  );
}

void main() {
  group('ComprasHistorialScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets(
      'admin_bodega: una compra activa muestra el botón "Anular", una '
      'anulada no',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            comprasRepository: _FakeComprasRepository([
              () async => [_compraActiva, _compraAnulada],
            ]),
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Compra #45'), findsOneWidget);
        expect(find.text('Compra #46'), findsOneWidget);
        expect(find.text('2026-08-02 · Anulada'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Anular'), findsOneWidget);
      },
    );

    testWidgets('empleado: no muestra ningún botón "Anular"', (tester) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          comprasRepository: _FakeComprasRepository([
            () async => [_compraActiva],
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'Anular'), findsNothing);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin compras"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          comprasRepository: _FakeComprasRepository([() async => []]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay compras registradas'), findsOneWidget);
    });

    testWidgets(
      'confirmar el diálogo llama anular y refresca la lista',
      (tester) async {
        final repository = _FakeComprasRepository([
          () async => [_compraActiva],
          () async => [_compraAnulada],
        ]);

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            comprasRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(find.text('Anular compra'), findsOneWidget);

        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(repository.anularCallCount, 1);
        expect(repository.listarCallCount, 2);
      },
    );

    testWidgets('cancelar el diálogo no llama anular', (tester) async {
      final repository = _FakeComprasRepository([
        () async => [_compraActiva],
      ]);

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.adminBodega),
          ),
          comprasRepository: repository,
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Anular'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
      await tester.pumpAndSettle();

      expect(repository.anularCallCount, 0);
    });

    testWidgets(
      'un error al anular se muestra en un SnackBar',
      (tester) async {
        final repository = _FakeComprasRepository([
          () async => [_compraActiva],
        ])..anularError = const ApiException(
          statusCode: 400,
          message: 'Algún lote ya se movió',
        );

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            comprasRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(find.text('Algún lote ya se movió'), findsOneWidget);
      },
    );

    testWidgets(
      'un error al anular sin mensaje muestra un fallback específico de '
      'anular, no el de "no se pudo cargar"',
      (tester) async {
        final repository = _FakeComprasRepository([
          () async => [_compraActiva],
        ])..anularError = const ApiException(statusCode: 400);

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            comprasRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(
          find.text('No se pudo anular la compra. Intenta de nuevo.'),
          findsOneWidget,
        );
        expect(
          find.text('No se pudo cargar el historial de compras. Intenta de nuevo.'),
          findsNothing,
        );
      },
    );

    testWidgets('un ApiException al cargar muestra su mensaje', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          comprasRepository: _FakeComprasRepository([
            () async => throw const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });
  });
}
