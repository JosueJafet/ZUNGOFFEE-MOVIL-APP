import 'package:freezed_annotation/freezed_annotation.dart';

part 'variedad_cafe.freezed.dart';

/// Una variedad de café del catálogo `GET /catalogos` (`variedadesCafe`).
@freezed
class VariedadCafe with _$VariedadCafe {
  const factory VariedadCafe({required int id, required String nombre}) =
      _VariedadCafe;
}
