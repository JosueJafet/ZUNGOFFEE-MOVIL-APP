import 'package:freezed_annotation/freezed_annotation.dart';

part 'lote.freezed.dart';

/// Modelo de dominio de un lote de café (existencia), mapeado desde
/// `LoteDto` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.4 — `GET
/// /lotes/existencias`). Aplanado desde los objetos anidados del JSON
/// (`estados_cafe`, `variedades_cafe`, `niveles_altura`), mismo criterio
/// que `Perfil` aplanó `PerfilRolDto`/`PerfilTenantDto` en Sprint 3.
@freezed
class Lote with _$Lote {
  const factory Lote({
    required String id,
    required double saldo,
    required double cantidadInicial,
    required String estadoCafeNombre,
    required int unidadMedidaId,
    required String variedadNombre,
    required String nivelAlturaNombre,
  }) = _Lote;
}
