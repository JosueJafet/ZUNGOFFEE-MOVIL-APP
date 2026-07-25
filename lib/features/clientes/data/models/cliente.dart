import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente.freezed.dart';

/// Modelo de dominio de un cliente, mapeado desde `ClienteDto`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, secciones 6.2b y 7). Mismo patrón que
/// `Proveedor` (Sprint 5), sin `sexo`/`finca` — no aplican a un cliente.
@freezed
class Cliente with _$Cliente {
  const factory Cliente({
    required int id,
    required int tenantId,
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
    required bool estado,
  }) = _Cliente;
}