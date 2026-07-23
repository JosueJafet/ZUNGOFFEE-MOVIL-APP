import 'package:freezed_annotation/freezed_annotation.dart';

part 'proveedor.freezed.dart';

/// Modelo de dominio de un proveedor, mapeado desde `ProveedorDto`
/// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.2).
@freezed
class Proveedor with _$Proveedor {
  const factory Proveedor({
    required int id,
    required int tenantId,
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    int? tipoId,
    String? telefono,
    required bool estado,
  }) = _Proveedor;
}
