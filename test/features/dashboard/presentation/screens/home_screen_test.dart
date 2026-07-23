import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/dashboard/presentation/screens/home_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// Responde con la próxima función de [_responses] en cada llamada
/// (se queda en la última una vez agotadas) — permite simular
/// error -> reintentar -> data, además de los casos simples de éxito.
class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._responses)
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Future<Perfil> Function()> _responses;
  int callCount = 0;

  @override
  Future<Perfil> getPerfil() {
    final index = callCount < _responses.length
        ? callCount
        : _responses.length - 1;
    callCount++;
    return _responses[index]();
  }
}

final _perfilDeEjemplo = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

Widget _wrap(PerfilRepository perfilRepository, AuthRepository authRepository) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      perfilRepositoryProvider.overrideWithValue(perfilRepository),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
  );
}

void main() {
  group('HomeScreen', () {
    late SupabaseClient supabaseClient;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authRepository = AuthRepository(AuthSessionService(supabaseClient));
    });

    tearDown(() => supabaseClient.dispose());

    testWidgets('muestra un indicador de carga mientras resuelve el perfil', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () => Future.delayed(
          const Duration(milliseconds: 100),
          () => _perfilDeEjemplo,
        ),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('muestra el mensaje de bienvenida y la bodega del perfil', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([() async => _perfilDeEjemplo]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido, Juan Pérez'), findsOneWidget);
      expect(find.text('Bodega Central'), findsOneWidget);
    });

    testWidgets('un ApiException muestra su mensaje y un botón de reintentar', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () async =>
            throw const ApiException(statusCode: 500, message: 'Error del servidor'),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('un NetworkException muestra su mensaje', (tester) async {
      final repository = _FakePerfilRepository([
        () async => throw const NetworkException('Sin conexión'),
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('reintentar vuelve a pedir el perfil tras un error', (
      tester,
    ) async {
      final repository = _FakePerfilRepository([
        () async =>
            throw const ApiException(statusCode: 500, message: 'Error del servidor'),
        () async => _perfilDeEjemplo,
      ]);

      await tester.pumpWidget(_wrap(repository, authRepository));
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido, Juan Pérez'), findsOneWidget);
      expect(repository.callCount, 2);
    });
  });
}
