import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/pago_remote_datasource.dart';
import '../../data/models/pago.dart';
import '../../data/models/pagos_resumen.dart';
import '../../data/repositories/pago_repository.dart';

/// Instancia única de [PagoRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final pagoRepositoryProvider = Provider<PagoRepository>((ref) {
  final dataSource = PagoRemoteDataSource(ref.watch(apiClientProvider));
  return PagoRepository(dataSource);
});

/// KPIs de pagos (`GET /pagos/resumen`, solo `super_admin`).
final pagosResumenProvider = FutureProvider<PagosResumen>((ref) {
  return ref.watch(pagoRepositoryProvider).getResumen();
});

/// Historial de pagos de una bodega (`GET /pagos/tenant/:tenantId`),
/// parametrizado por `tenantId` — se invalida manualmente desde
/// [PagoFormController]/[PagoMarcarPagadoController] (importados por
/// esos providers, no acá) tras un `registrar`/`marcarPagado` exitoso.
final pagosHistorialProvider = FutureProvider.family<List<Pago>, int>((
  ref,
  tenantId,
) {
  return ref.watch(pagoRepositoryProvider).getHistorialPorBodega(tenantId);
});
