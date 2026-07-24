import 'package:freezed_annotation/freezed_annotation.dart';

import 'estado_cafe_catalogo.dart';
import 'metodo_pago.dart';
import 'nivel_altura.dart';
import 'variedad_cafe.dart';

part 'catalogos.freezed.dart';

/// Agregado de todos los catálogos de `GET /catalogos`, mapeado desde
/// `CatalogosDto`.
@freezed
class Catalogos with _$Catalogos {
  const factory Catalogos({
    required List<MetodoPago> metodosPago,
    required List<VariedadCafe> variedadesCafe,
    required List<NivelAltura> nivelesAltura,
    required List<EstadoCafeCatalogo> estadosCafe,
  }) = _Catalogos;
}
