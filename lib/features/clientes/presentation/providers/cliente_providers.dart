import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/cliente_remote_datasource.dart';
import '../../data/models/cliente.dart';
import '../../data/repositories/cliente_repository.dart';

/// Instancia única de [ClienteRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  final dataSource = ClienteRemoteDataSource(ref.watch(apiClientProvider));
  return ClienteRepository(dataSource);
});

/// Lista de clientes (`GET /clientes`). Se invalida manualmente desde
/// [ClienteFormController] tras un `crear`/`actualizar` exitoso — mismo
/// patrón que `proveedoresProvider` (Sprint 5).
final clientesProvider = FutureProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).getClientes();
});