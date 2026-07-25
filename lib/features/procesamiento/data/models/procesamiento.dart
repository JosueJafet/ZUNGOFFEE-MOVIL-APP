import 'package:freezed_annotation/freezed_annotation.dart';

part 'procesamiento.freezed.dart';

/// Modelo de dominio de un evento de procesamiento (tostar/moler),
/// mapeado desde `ProcesamientoDto` (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.6). **Sin `anulada`**: a diferencia de `Compra`/`Venta`, el ejemplo
/// de respuesta de `POST /procesamiento` no la muestra. No representa
/// `lote_destino`: se consulta el lote resultante después vía
/// `existenciasProvider` (`features/inventario`), mismo criterio que
/// `Compra`/`Venta` con sus lotes generados/vendidos.
@freezed
class Procesamiento with _$Procesamiento {
  const factory Procesamiento({
    required String id,
    required int tenantId,
    required String loteOrigenId,
    required String loteDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) = _Procesamiento;
}
