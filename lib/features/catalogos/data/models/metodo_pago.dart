import 'package:freezed_annotation/freezed_annotation.dart';

part 'metodo_pago.freezed.dart';

/// Un método de pago del catálogo `GET /catalogos` (`metodosPago`).
@freezed
class MetodoPago with _$MetodoPago {
  const factory MetodoPago({required int id, required String nombre}) =
      _MetodoPago;
}
