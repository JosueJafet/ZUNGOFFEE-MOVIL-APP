import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/bigint_id.dart';
import '../models/notificacion.dart';

part 'notificacion_dto.freezed.dart';
part 'notificacion_dto.g.dart';

/// DTO fiel al JSON de `GET /notificaciones` (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.7) — snake_case, tal como llega de la API. `id` es BigInt
/// (`String`), igual que `Lote.id`/`Procesamiento.id`.
@freezed
class NotificacionDto with _$NotificacionDto {
  const NotificacionDto._();

  const factory NotificacionDto({
    required String id,
    required String titulo,
    required String mensaje,
    required bool leida,
  }) = _NotificacionDto;

  factory NotificacionDto.fromJson(Map<String, dynamic> json) =>
      _$NotificacionDtoFromJson(json);

  /// Mapea este DTO (fiel al JSON) al modelo de dominio `Notificacion`.
  Notificacion toDomain() {
    return Notificacion(
      id: BigIntId.fromJson(id),
      titulo: titulo,
      mensaje: mensaje,
      leida: leida,
    );
  }
}
