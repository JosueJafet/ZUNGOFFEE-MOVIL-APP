import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// El datasource nunca se ejercita realmente: `getPerfil()` se
/// sobreescribe directamente, así que el `ApiClient` de abajo solo existe
/// para satisfacer el constructor de [PerfilRepository].
class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository(this._perfil)
    : super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Perfil _perfil;

  @override
  Future<Perfil> getPerfil() async => _perfil;
}

void main() {
  group('perfilProvider', () {
    late SupabaseClient supabaseClient;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
    });

    tearDown(() => supabaseClient.dispose());

    test('resuelve al Perfil esperado cuando hay sesión', () async {
      final expected = Perfil(
        id: 7,
        nombre: 'Juan Pérez',
        activo: true,
        fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
        rol: 'empleado',
        tenantId: 3,
        tenantNombre: 'Bodega Central',
      );

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(AuthSessionService(supabaseClient)),
          ),
          perfilRepositoryProvider.overrideWithValue(
            _FakePerfilRepository(expected),
          ),
        ],
      );
      addTearDown(container.dispose);

      final perfil = await container.read(perfilProvider.future);

      expect(perfil, expected);
    });
  });
}
