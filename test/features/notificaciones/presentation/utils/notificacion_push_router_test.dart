import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/router/route_paths.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/utils/notificacion_push_router.dart';

void main() {
  group('rutaParaTipoNotificacion', () {
    test('solicitud_pendiente -> /solicitudes', () {
      expect(
        rutaParaTipoNotificacion('solicitud_pendiente'),
        RoutePaths.solicitudes,
      );
    });

    test('pago_pendiente -> /pagos', () {
      expect(rutaParaTipoNotificacion('pago_pendiente'), RoutePaths.pagos);
    });

    test('compra_registrada -> /compras/historial', () {
      expect(
        rutaParaTipoNotificacion('compra_registrada'),
        RoutePaths.historialCompras,
      );
    });

    test('venta_registrada -> /ventas/historial', () {
      expect(
        rutaParaTipoNotificacion('venta_registrada'),
        RoutePaths.historialVentas,
      );
    });

    test('un tipo no contemplado devuelve null (no rompe)', () {
      expect(rutaParaTipoNotificacion('tipo_futuro_desconocido'), isNull);
    });
  });
}
