/// IDs del catálogo `estados_cafe`, documentados en
/// `CONTEXTO-MOVIL-FLUTTER.md` (secciones 2.1, 6.1, 6.6 y 8): el café pasa
/// por 5 etapas de negocio, pero el catálogo tiene 7 registros porque el
/// tostado se divide en 3 niveles (alto/medio/bajo).
abstract final class EstadoCafeId {
  const EstadoCafeId._();

  static const int uva = 1;
  static const int humedo = 2;
  static const int pergaminoSeco = 3;
  static const int tostadoAlto = 4;
  static const int tostadoMedio = 5;
  static const int tostadoBajo = 6;
  static const int molido = 7;

  /// Los 3 niveles de tostado, agrupados (sección 6.6).
  static const List<int> tostado = [tostadoAlto, tostadoMedio, tostadoBajo];

  /// Únicos valores válidos como `estadoCafeId` al registrar una compra
  /// (sección 6.1) — el catálogo completo trae los 7, pero solo estos 3
  /// son comprables.
  static const List<int> compraValidos = [uva, humedo, pergaminoSeco];
}

/// Reglas de transición válidas al procesar café (tostar/moler), tal como
/// las documenta la sección 2.1 y 6.6: solo se puede tostar un pergamino
/// seco (nunca uva o húmedo directamente), y solo se puede moler algo que
/// ya esté tostado. Cualquier otra combinación la API la rechaza con 400.
///
/// Esto es una validación temprana de UX (para no dejar elegir una
/// combinación inválida en un formulario) — la API sigue siendo la
/// fuente de verdad final sobre si una transición es válida.
abstract final class EstadoCafeTransiciones {
  const EstadoCafeTransiciones._();

  static const Map<int, List<int>> _destinosPermitidos = {
    EstadoCafeId.pergaminoSeco: EstadoCafeId.tostado,
    EstadoCafeId.tostadoAlto: [EstadoCafeId.molido],
    EstadoCafeId.tostadoMedio: [EstadoCafeId.molido],
    EstadoCafeId.tostadoBajo: [EstadoCafeId.molido],
  };

  /// `true` si, según las reglas documentadas, se puede procesar un lote
  /// en [origenId] hacia [destinoId].
  static bool esValida({required int origenId, required int destinoId}) {
    return _destinosPermitidos[origenId]?.contains(destinoId) ?? false;
  }
}
