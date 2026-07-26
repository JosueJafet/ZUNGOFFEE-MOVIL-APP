import '../../core/errors/api_exception.dart';
import '../../core/errors/network_exception.dart';

/// Mapea un error de red/API a un mensaje legible para el usuario.
///
/// Mismo criterio en toda la app desde Sprint 5: `ApiException` expone su
/// propio `message` cuando la API lo trae (o [fallback] si no), y
/// `NetworkException` siempre trae uno (sin conexión, timeout, etc.) — el
/// resto de errores usa [fallback].
extension ErrorMessageX on Object {
  String errorMessage({required String fallback}) {
    final error = this;
    if (error is ApiException) return error.message ?? fallback;
    if (error is NetworkException) return error.message;
    return fallback;
  }
}
