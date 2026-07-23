import 'package:freezed_annotation/freezed_annotation.dart';

part 'perfil.freezed.dart';

/// Modelo de dominio del perfil del usuario autenticado, mapeado desde
/// `PerfilDto` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.8).
///
/// `rol` es el nombre de rol tal como lo devuelve la API — comparable
/// directamente con las constantes de `AppRole`.
@freezed
class Perfil with _$Perfil {
  const factory Perfil({
    required int id,
    required String nombre,
    required bool activo,
    required DateTime fechaCreacion,
    required String rol,
    required int tenantId,
    required String tenantNombre,
  }) = _Perfil;
}
