import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/notificaciones_remote_datasource.dart';
import '../../data/models/notificacion.dart';
import '../../data/repositories/notificaciones_repository.dart';

/// Instancia única de [NotificacionesRepository] para toda la app,
/// construida sobre el mismo `apiClientProvider` (`core/api`) que usa el
/// resto de la app.
final notificacionesRepositoryProvider = Provider<NotificacionesRepository>((
  ref,
) {
  final dataSource = NotificacionesRemoteDataSource(
    ref.watch(apiClientProvider),
  );
  return NotificacionesRepository(dataSource);
});

/// Bandeja de notificaciones (`GET /notificaciones`). Se invalida desde
/// `NotificacionMarcarLeidaController` tras un `marcarLeida` exitoso —
/// mismo patrón que `existenciasProvider`/`comprasHistorialProvider`.
final notificacionesProvider = FutureProvider<List<Notificacion>>((ref) {
  return ref.watch(notificacionesRepositoryProvider).listar();
});
