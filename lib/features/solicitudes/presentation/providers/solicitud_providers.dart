import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/solicitud_remote_datasource.dart';
import '../../data/models/solicitud.dart';
import '../../data/repositories/solicitud_repository.dart';

/// Instancia única de [SolicitudRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final solicitudRepositoryProvider = Provider<SolicitudRepository>((ref) {
  final dataSource = SolicitudRemoteDataSource(ref.watch(apiClientProvider));
  return SolicitudRepository(dataSource);
});

/// Lista de solicitudes (`GET /solicitudes`, solo `super_admin`). Se
/// invalida manualmente desde [SolicitudRechazarController] y desde
/// `BodegaFormController.crear` (cuando se acepta una solicitud vía
/// `solicitudId`).
final solicitudesProvider = FutureProvider<List<Solicitud>>((ref) {
  return ref.watch(solicitudRepositoryProvider).getSolicitudes();
});
