import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/proveedor_remote_datasource.dart';
import '../../data/models/proveedor.dart';
import '../../data/repositories/proveedor_repository.dart';

/// Instancia única de [ProveedorRepository] para toda la app, construida
/// sobre el mismo `apiClientProvider` (`core/api`) que usa el resto de la
/// app.
final proveedorRepositoryProvider = Provider<ProveedorRepository>((ref) {
  final dataSource = ProveedorRemoteDataSource(ref.watch(apiClientProvider));
  return ProveedorRepository(dataSource);
});

/// Lista de proveedores (`GET /proveedores`). Se invalida manualmente
/// desde [ProveedorFormController] tras un `crear`/`actualizar` exitoso —
/// no hay ningún evento de sesión del que depender aquí, a diferencia de
/// `perfilProvider`.
final proveedoresProvider = FutureProvider<List<Proveedor>>((ref) {
  return ref.watch(proveedorRepositoryProvider).getProveedores();
});
