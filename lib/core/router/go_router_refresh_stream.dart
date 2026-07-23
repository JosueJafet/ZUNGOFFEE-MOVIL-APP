import 'dart:async';

import 'package:flutter/foundation.dart';

/// Convierte un `Stream` en un `Listenable`, para que
/// `GoRouter.refreshListenable` reevalúe sus redirects cada vez que el
/// stream emite — en este proyecto, cada vez que cambia el estado de
/// autenticación de Supabase (`AuthSessionService.onAuthStateChange`).
///
/// `go_router` no incluye esto de fábrica; es el patrón documentado
/// oficialmente por el paquete para integrarse con streams de estado
/// externos (Supabase, Firebase Auth, etc.).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // Notifica una vez al construirse, para que el primer `redirect` de
    // GoRouter ya se evalúe con el estado real (no solo tras el primer
    // evento del stream).
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
