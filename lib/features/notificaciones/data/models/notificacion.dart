import 'package:freezed_annotation/freezed_annotation.dart';

part 'notificacion.freezed.dart';

/// Modelo de dominio de una notificación, mapeado desde
/// `NotificacionDto` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.7). El
/// ejemplo de `GET /notificaciones` corta con "..." tras `leida` — solo
/// se modelan los campos que el ejemplo confirma (`id`, `titulo`,
/// `mensaje`, `leida`), mismo criterio que `Venta` sin `fecha` (Sprint 7)
/// y `Procesamiento` sin `anulada` (Sprint 8).
@freezed
class Notificacion with _$Notificacion {
  const factory Notificacion({
    required String id,
    required String titulo,
    required String mensaje,
    required bool leida,
  }) = _Notificacion;
}
