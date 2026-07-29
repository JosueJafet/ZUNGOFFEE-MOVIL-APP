import 'package:freezed_annotation/freezed_annotation.dart';

part 'resumen_diario.freezed.dart';

/// Fila de `GET /compras/resumen` / `GET /ventas/resumen` — un total por
/// fecha con actividad (no un total ya agregado, ver `ResumenDiarioDto`).
/// Compartido entre `features/compras` y `features/ventas`: mismo shape
/// exacto verificado en producción, ambos endpoints devuelven lo mismo.
@freezed
class ResumenDiario with _$ResumenDiario {
  const factory ResumenDiario({
    required DateTime fecha,
    required double total,
  }) = _ResumenDiario;
}
