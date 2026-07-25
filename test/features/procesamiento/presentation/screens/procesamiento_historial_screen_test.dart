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
import 'package:zungofee_mobile/features/procesamiento/data/datasources/procesamiento_remote_datasource.dart';
import 'package:zungofee_mobile/features/procesamiento/data/models/procesamiento.dart';
import 'package:zungofee_mobile/features/procesamiento/data/repositories/procesamiento_repository.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/providers/procesamiento_providers.dart';
import 'package:zungofee_mobile/features/procesamiento/presentation/screens/procesamiento_historial_screen.dart';

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

class _FakeProcesamientoRepository extends ProcesamientoRepository {
  _FakeProcesamientoRepository(this._responses)
    : super(
        ProcesamientoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final List<Future<List<Procesamiento>> Function()> _responses;
  int listarCallCount = 0;
  int anularCallCount = 0;
  Object? anularError;

  @override
  Future<List<Procesamiento>> listar({int page = 1, int pageSize = 20}) {
    final index = listarCallCount < _responses.length
        ? listarCallCount
        : _responses.length - 1;
    listarCallCount++;
    return _responses[index]();
  }

  @override
  Future<void> anular(String id) async {
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

const _procesamientoDeEjemplo = Procesamiento(
  id: '9',
  tenantId: 5,
  loteOrigenId: '78',
  loteDestinoId: '80',
  cantidadEntrada: 5,
  cantidadSalida: 350,
);

Widget _wrap({
  required PerfilRepository perfilRepository,
  required ProcesamientoRepository procesamientoRepository,
  required AuthRepository authRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
      procesamientoRepositoryProvider.overrideWithValue(
        procesamientoRepository,
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const ProcesamientoHistorialScreen(),
    ),
  );
}

void main() {
  group('ProcesamientoHistorialScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets(
      'admin_bodega: muestra el ítem y el botón "Anular" (siempre visible, '
      'sin campo anulada — Decisión 4)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            procesamientoRepository: _FakeProcesamientoRepository([
              () async => [_procesamientoDeEjemplo],
            ]),
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Procesamiento #9'), findsOneWidget);
        expect(find.text('Lote 78 → 80 · 5.00 → 350.00'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Anular'), findsOneWidget);
      },
    );

    testWidgets('empleado: no muestra ningún botón "Anular"', (tester) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          procesamientoRepository: _FakeProcesamientoRepository([
            () async => [_procesamientoDeEjemplo],
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'Anular'), findsNothing);
    });

    testWidgets('lista vacía: muestra el mensaje de "sin procesamientos"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.empleado),
          ),
          procesamientoRepository: _FakeProcesamientoRepository([
            () async => [],
          ]),
          authRepository: authRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay procesamientos registrados'), findsOneWidget);
    });

    testWidgets(
      'confirmar el diálogo llama anular y refresca la lista',
      (tester) async {
        final repository = _FakeProcesamientoRepository([
          () async => [_procesamientoDeEjemplo],
          () async => [_procesamientoDeEjemplo],
        ]);

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            procesamientoRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(find.text('Anular procesamiento'), findsOneWidget);

        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(repository.anularCallCount, 1);
        expect(repository.listarCallCount, 2);
      },
    );

    testWidgets('cancelar el diálogo no llama anular', (tester) async {
      final repository = _FakeProcesamientoRepository([
        () async => [_procesamientoDeEjemplo],
      ]);

      await tester.pumpWidget(
        _wrap(
          perfilRepository: _FakePerfilRepository(
            _perfilConRol(AppRole.adminBodega),
          ),
          procesamientoRepository: repository,
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
      'un error al anular (ya estaba anulado / lote movido) se muestra en '
      'un SnackBar',
      (tester) async {
        final repository = _FakeProcesamientoRepository([
          () async => [_procesamientoDeEjemplo],
        ])..anularError = const ApiException(
          statusCode: 400,
          message: 'El lote derivado ya se movió',
        );

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            procesamientoRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(find.text('El lote derivado ya se movió'), findsOneWidget);
      },
    );

    testWidgets(
      'un error al anular sin mensaje muestra un fallback específico de '
      'anular, no el de "no se pudo cargar"',
      (tester) async {
        final repository = _FakeProcesamientoRepository([
          () async => [_procesamientoDeEjemplo],
        ])..anularError = const ApiException(statusCode: 400);

        await tester.pumpWidget(
          _wrap(
            perfilRepository: _FakePerfilRepository(
              _perfilConRol(AppRole.adminBodega),
            ),
            procesamientoRepository: repository,
            authRepository: authRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Anular'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Anular'));
        await tester.pumpAndSettle();

        expect(
          find.text('No se pudo anular el procesamiento. Intenta de nuevo.'),
          findsOneWidget,
        );
        expect(
          find.text(
            'No se pudo cargar el historial de procesamiento. Intenta de nuevo.',
          ),
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
          procesamientoRepository: _FakeProcesamientoRepository([
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
