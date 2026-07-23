/// Parseo de los campos decimales de la API (`saldo`, `total`,
/// `costoUnitario`, `precioUnitario`, ...), serializados desde
/// `Prisma.Decimal` como `String` (p. ej. `"123.45"`) — nunca como
/// `number` JSON — según `CONTEXTO-MOVIL-FLUTTER.md`, sección 9.3.
abstract final class ApiDecimal {
  const ApiDecimal._();

  /// Lee un campo decimal de un valor JSON como `double`. Acepta también
  /// que llegue como `num` por robustez, sin lanzar, aunque la API
  /// siempre lo documenta como `String`.
  static double fromJson(Object? value) {
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    throw FormatException('Valor decimal inesperado: $value');
  }
}
