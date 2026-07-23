import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_providers.dart';
import 'api_client.dart';

/// Instancia única de [ApiClient] para toda la app, construida sobre el
/// mismo [authSessionServiceProvider] que usa el resto de la app — así
/// nunca hay dos sesiones/clientes de red viviendo por separado.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(authSessionServiceProvider));
});
