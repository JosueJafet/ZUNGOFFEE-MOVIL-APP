/// Utilidades para los IDs BigInt de la API (`lotes`, `bitacora`,
/// `procesamiento_cafe`, `notificaciones`, y cualquier campo que los
/// referencie, p. ej. `loteId`), que llegan como `String` en el JSON —
/// nunca como número — según `CONTEXTO-MOVIL-FLUTTER.md`, sección 5.
///
/// El resto de los IDs (`proveedor_id`, `cliente_id`, `tenant_id`,
/// `usuario_id`, etc.) son `int` normales y no necesitan pasar por aquí.
abstract final class BigIntId {
  const BigIntId._();

  /// Lee un ID BigInt de un valor JSON como `String`. Acepta también que
  /// llegue como `num` por robustez, sin lanzar, aunque la API siempre
  /// lo documenta como `String`.
  static String fromJson(Object? value) {
    if (value is String) return value;
    if (value is num) return value.toInt().toString();
    throw FormatException('Valor de ID BigInt inesperado: $value');
  }

  /// Convierte a [BigInt] solo cuando se necesita aritmética local.
  /// Nunca reenviar este resultado a la API — mandar siempre el `String`
  /// original (o el `int`/`String` que se recibió), tal como advierte la
  /// documentación.
  static BigInt toBigInt(String id) => BigInt.parse(id);
}
