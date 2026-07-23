import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/api/api_providers.dart';
import 'package:zungofee_mobile/core/services/auth_providers.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';

void main() {
  test(
    'apiClientProvider devuelve siempre la misma instancia dentro del mismo '
    'contenedor, construida sobre authSessionServiceProvider',
    () {
      final supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      addTearDown(() => supabaseClient.dispose());
      final authSessionService = AuthSessionService(supabaseClient);

      final container = ProviderContainer(
        overrides: [
          authSessionServiceProvider.overrideWithValue(authSessionService),
        ],
      );
      addTearDown(container.dispose);

      final first = container.read(apiClientProvider);
      final second = container.read(apiClientProvider);

      expect(first, same(second));
    },
  );
}
