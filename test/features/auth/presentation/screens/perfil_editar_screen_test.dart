import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/screens/perfil_editar_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _perfil = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository({this.actualizarError})
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? actualizarError;
  int actualizarCallCount = 0;
  String? ultimoNombre;

  @override
  Future<Perfil> getPerfil() async => _perfil;

  @override
  Future<void> actualizar(String nombre) async {
    actualizarCallCount++;
    ultimoNombre = nombre;
    if (actualizarError != null) throw actualizarError!;
  }
}

Widget _wrap(PerfilRepository repository, {VoidCallback? onGuardado}) {
  return ProviderScope(
    overrides: [perfilRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PerfilEditarScreen(onGuardado: onGuardado ?? () {}),
    ),
  );
}

void main() {
  group('PerfilEditarScreen', () {
    testWidgets('precarga el campo con el nombre actual del perfil', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakePerfilRepository()));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Juan Pérez'), findsOneWidget);
    });

    testWidgets(
      'éxito: llama actualizar() con el nombre editado y llama onGuardado',
      (tester) async {
        final repository = _FakePerfilRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Juan Pérez'),
          'Nuevo Nombre',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.actualizarCallCount, 1);
        expect(repository.ultimoNombre, 'Nuevo Nombre');
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('validación: no envía el submit si el nombre queda vacío', (
      tester,
    ) async {
      final repository = _FakePerfilRepository();

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Juan Pérez'),
        '   ',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Ingresa el nombre'), findsOneWidget);
      expect(repository.actualizarCallCount, 0);
    });

    testWidgets(
      'un error de la API se muestra inline y no llama onGuardado',
      (tester) async {
        final repository = _FakePerfilRepository(
          actualizarError: const ApiException(
            statusCode: 400,
            message: 'Nombre inválido',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('Nombre inválido'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );
  });
}
