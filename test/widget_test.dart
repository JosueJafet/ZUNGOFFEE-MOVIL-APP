import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zungofee_mobile/core/router/app_router.dart';
import 'package:zungofee_mobile/core/services/auth_session_service.dart';
import 'package:zungofee_mobile/main.dart';

void main() {
  // `SupabaseClient` inicia un timer periódico de auto-refresh al
  // construirse; se crea en `setUp` (fuera de la zona de FakeAsync que
  // envuelve el cuerpo de `testWidgets`) y se cierra en `tearDown` para
  // no dejarlo pendiente.
  late SupabaseClient supabaseClient;

  setUp(() {
    supabaseClient = SupabaseClient('https://example.test', 'test-anon-key');
  });

  tearDown(() => supabaseClient.dispose());

  testWidgets('ZungofeeApp builds without crashing', (WidgetTester tester) async {
    final authSessionService = AuthSessionService(supabaseClient);
    final router = AppRouter.build(authSessionService);

    await tester.pumpWidget(ProviderScope(child: ZungofeeApp(router: router)));

    expect(find.byType(ZungofeeApp), findsOneWidget);
  });
}
