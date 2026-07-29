import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../shared/data/models/resumen_diario.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import '../../data/models/compra_historial.dart';
import '../../data/repositories/compras_repository.dart';

/// Instancia única de [ComprasRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final comprasRepositoryProvider = Provider<ComprasRepository>((ref) {
  final dataSource = ComprasRemoteDataSource(ref.watch(apiClientProvider));
  return ComprasRepository(dataSource);
});

/// Historial de compras (`GET /compras`). Se invalida desde
/// `ComprasAnularController` tras un `anular` exitoso — mismo patrón que
/// `existenciasProvider`.
final comprasHistorialProvider = FutureProvider<List<CompraHistorial>>((ref) {
  return ref.watch(comprasRepositoryProvider).listar();
});

/// KPI "Compras (30 días)" del Home de `admin_bodega` (`GET
/// /compras/resumen`) — un total por fecha con actividad, no un total ya
/// agregado (ver `ResumenDiarioDto`).
final comprasResumenProvider = FutureProvider<List<ResumenDiario>>((ref) {
  return ref.watch(comprasRepositoryProvider).getResumen();
});
