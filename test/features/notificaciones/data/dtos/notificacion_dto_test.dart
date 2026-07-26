import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/notificaciones/data/dtos/notificacion_dto.dart';

void main() {
  group('NotificacionDto', () {
    // JSON de ejemplo de `GET /notificaciones` (`CONTEXTO-MOVIL-FLUTTER.md`,
    // sección 6.7). El ejemplo corta con "..." tras `leida` — solo se
    // modelan los campos confirmados.
    final json = {
      'id': '3',
      'titulo': 'Compra registrada',
      'mensaje': 'Se registró una compra de 10 quintales',
      'leida': false,
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = NotificacionDto.fromJson(json);

      expect(dto.id, '3');
      expect(dto.titulo, 'Compra registrada');
      expect(dto.mensaje, 'Se registró una compra de 10 quintales');
      expect(dto.leida, isFalse);
    });

    test('toDomain mapea al modelo de dominio Notificacion', () {
      final notificacion = NotificacionDto.fromJson(json).toDomain();

      expect(notificacion.id, '3');
      expect(notificacion.titulo, 'Compra registrada');
      expect(notificacion.mensaje, 'Se registró una compra de 10 quintales');
      expect(notificacion.leida, isFalse);
    });
  });
}
