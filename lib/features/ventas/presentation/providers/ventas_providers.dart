import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/ventas_remote_datasource.dart';
import '../../data/models/venta.dart';
import '../../data/repositories/ventas_repository.dart';

/// Instancia única de [VentasRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final ventasRepositoryProvider = Provider<VentasRepository>((ref) {
  final dataSource = VentasRemoteDataSource(ref.watch(apiClientProvider));
  return VentasRepository(dataSource);
});

/// Historial de ventas (`GET /ventas`). Se invalida desde
/// `VentasAnularController` tras un `anular` exitoso — mismo patrón que
/// `existenciasProvider`.
final ventasHistorialProvider = FutureProvider<List<Venta>>((ref) {
  return ref.watch(ventasRepositoryProvider).listar();
});