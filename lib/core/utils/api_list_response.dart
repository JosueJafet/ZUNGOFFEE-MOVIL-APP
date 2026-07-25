/// Extrae el arreglo de items de la respuesta de un endpoint de listado
/// (`GET /compras`, `GET /ventas`, `GET /procesamiento`, ...) sin asumir
/// un shape específico — el contrato (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 7) documenta estos endpoints con `?page&pageSize` pero no da
/// ningún ejemplo de JSON de respuesta.
abstract final class ApiListResponse {
  const ApiListResponse._();

  /// Si [responseData] ya es una `List`, se usa tal cual (único shape que
  /// el contrato sí demuestra hoy para un listado paginado, vía
  /// `GET /lotes/existencias`). Si es un `Map`, busca la primera entrada
  /// cuyo valor sea una `List` y la usa, sin asumir el nombre de la
  /// clave. Si no encuentra ninguna `List`, lanza un error explícito en
  /// vez de fallar de forma confusa más adelante en el parseo.
  static List<dynamic> extractItems(Object? responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      for (final value in responseData.values) {
        if (value is List) return value;
      }
    }
    throw FormatException(
      'No se encontró un arreglo de items en la respuesta: $responseData',
    );
  }
}
