import 'package:freezed_annotation/freezed_annotation.dart';

part 'pago.freezed.dart';

/// Modelo de dominio de un pago de bodega, mapeado desde `PagoDto`. Solo
/// lo ve `super_admin` (`CONTEXTO-PLATAFORMA-WEB.md`, sección 8.14).
@freezed
class Pago with _$Pago {
  const factory Pago({
    required int id,
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
    DateTime? fechaPago,
    required int estadoPagoId,
    required int registradoPor,
    // "pagado" / "vencido" / "pendiente" — ya resuelto por el servidor
    // (`GET /pagos/tenant/:id`), no se recalcula del lado del cliente.
    required String estadoCalculado,
  }) = _Pago;
}
