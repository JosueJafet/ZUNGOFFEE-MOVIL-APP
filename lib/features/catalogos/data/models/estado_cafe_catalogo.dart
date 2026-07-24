import 'package:freezed_annotation/freezed_annotation.dart';

part 'estado_cafe_catalogo.freezed.dart';

/// Un estado de café del catálogo `GET /catalogos` (`estadosCafe`) — nombre
/// distinto a `EstadoCafeId` (`core/constants/estado_cafe.dart`, Sprint 2)
/// para no confundir este catálogo con nombres reales con la lista de
/// constantes de IDs ya existente.
@freezed
class EstadoCafeCatalogo with _$EstadoCafeCatalogo {
  const factory EstadoCafeCatalogo({
    required int id,
    required String nombre,
    required int unidadMedidaId,
  }) = _EstadoCafeCatalogo;
}
