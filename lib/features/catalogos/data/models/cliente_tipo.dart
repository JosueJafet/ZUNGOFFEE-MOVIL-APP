import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente_tipo.freezed.dart';

/// Un tipo de cliente del catálogo `GET /catalogos` (`clientesTipo`) —
/// referenciado por `Cliente.tipoId` (`features/clientes`).
@freezed
class ClienteTipo with _$ClienteTipo {
  const factory ClienteTipo({required int id, required String nombre}) =
      _ClienteTipo;
}