import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    // Mismo patrón de `app_router_test.dart`: un `SupabaseClient` real
    // construido a mano (sin `Supabase.initialize`), sin sesión
    // persistida. `signIn` no se ejercita aquí porque requeriría una
    // llamada HTTP real a Supabase Auth — `signOut` sí se puede probar
    // sin red porque, sin sesión activa, `GoTrueClient.signOut()` solo
    // limpia estado local y notifica a los subscribers.
    late SupabaseClient supabaseClient;
    late AuthSessionService authSessionService;
    late AuthRepository authRepository;

    setUp(() {
      supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
      authSessionService = AuthSessionService(supabaseClient);
      authRepository = AuthRepository(authSessionService);
    });

    tearDown(() => supabaseClient.dispose());

    test('isAuthenticated delega en AuthSessionService', () {
      expect(authRepository.isAuthenticated, authSessionService.isAuthenticated);
      expect(authRepository.isAuthenticated, isFalse);
    });

    test(
      'onAuthStateChange delega en el stream de AuthSessionService, y '
      'signOut delega en AuthSessionService.signOut',
      () async {
        // `GoTrueClient.onAuthStateChange` devuelve un wrapper nuevo en
        // cada lectura (respaldado por el mismo `BehaviorSubject`
        // interno), así que no se puede comparar por identidad — se
        // verifica en cambio que ambos streams reciben el mismo evento
        // real disparado por `signOut()`.
        final signedOut = isA<AuthState>().having(
          (s) => s.event,
          'event',
          AuthChangeEvent.signedOut,
        );

        final onRepository = expectLater(
          authRepository.onAuthStateChange,
          emits(signedOut),
        );
        final onService = expectLater(
          authSessionService.onAuthStateChange,
          emits(signedOut),
        );

        await authRepository.signOut();

        await onRepository;
        await onService;
      },
    );
  });
}
