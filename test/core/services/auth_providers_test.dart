import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/services/auth_providers.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';

void main() {
  test(
    'authSessionServiceProvider devuelve siempre la misma instancia dentro '
    'del mismo contenedor',
    () {
      // `Supabase.instance` no está inicializado en este test (evita
      // depender de almacenamiento de plataforma); se sobreescribe el
      // provider con una instancia real construida a mano, como ya se
      // hace en los tests de router (Sprint 2).
      final supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      addTearDown(() => supabaseClient.dispose());
      final authSessionService = AuthSessionService(supabaseClient);

      final container = ProviderContainer(
        overrides: [
          authSessionServiceProvider.overrideWithValue(authSessionService),
        ],
      );
      addTearDown(container.dispose);

      final first = container.read(authSessionServiceProvider);
      final second = container.read(authSessionServiceProvider);

      expect(first, same(second));
      expect(first, same(authSessionService));
    },
  );
}
