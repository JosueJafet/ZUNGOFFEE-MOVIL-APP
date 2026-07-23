import 'package:flutter_test/flutter_test.dart';
import 'package:zungofee_mobile/core/constants/estado_cafe.dart';

void main() {
  group('EstadoCafeTransiciones.esValida', () {
    test('pergamino seco puede tostarse a cualquier nivel', () {
      expect(
        EstadoCafeTransiciones.esValida(
          origenId: EstadoCafeId.pergaminoSeco,
          destinoId: EstadoCafeId.tostadoMedio,
        ),
        isTrue,
      );
    });

    test('un tostado puede molerse', () {
      expect(
        EstadoCafeTransiciones.esValida(
          origenId: EstadoCafeId.tostadoAlto,
          destinoId: EstadoCafeId.molido,
        ),
        isTrue,
      );
    });

    test('uva no puede tostarse directamente', () {
      expect(
        EstadoCafeTransiciones.esValida(
          origenId: EstadoCafeId.uva,
          destinoId: EstadoCafeId.tostadoAlto,
        ),
        isFalse,
      );
    });

    test('húmedo no puede molerse directamente', () {
      expect(
        EstadoCafeTransiciones.esValida(
          origenId: EstadoCafeId.humedo,
          destinoId: EstadoCafeId.molido,
        ),
        isFalse,
      );
    });
  });
}
