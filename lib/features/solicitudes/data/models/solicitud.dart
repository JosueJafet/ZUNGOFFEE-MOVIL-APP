import 'package:freezed_annotation/freezed_annotation.dart';

part 'solicitud.freezed.dart';

/// Modelo de dominio de una solicitud de acceso (formulario público de la
/// landing), mapeado desde `SolicitudDto`. Solo la ve `super_admin`
/// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.13).
@freezed
class Solicitud with _$Solicitud {
  const Solicitud._();

  const factory Solicitud({
    required int id,
    required String nombreBodega,
    required String nombreContacto,
    required String email,
    // `null` cuando la solicitud llegó sin teléfono (dato real de
    // producción, no todos los rows lo traen).
    String? telefono,
    String? mensaje,
    required int estadoId,
    int? tenantCreadoId,
    required DateTime fechaCreacion,
  }) = _Solicitud;

  /// `estado_id`: `1`=pendiente, `2`=procesada, `3`=rechazada (mapeo
  /// confirmado por Rubio, backend — la API no resuelve este valor).
  bool get pendiente => estadoId == 1;

  String get estadoLabel => switch (estadoId) {
    1 => 'Pendiente',
    2 => 'Procesada',
    3 => 'Rechazada',
    _ => 'Desconocido',
  };
}
