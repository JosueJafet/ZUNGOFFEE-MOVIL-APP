import 'package:freezed_annotation/freezed_annotation.dart';

part 'unidad_medida.freezed.dart';

/// Una unidad de medida del catálogo `GET /catalogos` (`unidadesMedida`).
/// La unidad de cada estado del café (`estadosCafe.unidadMedidaId`) no es
/// elegible por el usuario, pero sí hay que mostrar su nombre real
/// (`CONTEXTO-PLATAFORMA-WEB.md`, sección 5: uva → galones, húmedo y
/// pergamino seco → quintales, tostado y molido → libras) — se resuelve
/// desde este catálogo en vez de hardcodear el nombre.
@freezed
class UnidadMedida with _$UnidadMedida {
  const factory UnidadMedida({required int id, required String nombre}) =
      _UnidadMedida;
}

/// Busca el nombre de la unidad con [id] en `unidadesMedida` — `"Unidad"`
/// si no se encuentra (nunca debería pasar contra la API real, pero evita
/// reventar si el catálogo cambia).
extension UnidadMedidaLookup on List<UnidadMedida> {
  String nombreDe(int id) {
    for (final unidad in this) {
      if (unidad.id == id) return unidad.nombre;
    }
    return 'Unidad';
  }
}
