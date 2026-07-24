import 'package:freezed_annotation/freezed_annotation.dart';

part 'nivel_altura.freezed.dart';

/// Un nivel de altura del catálogo `GET /catalogos` (`nivelesAltura`).
/// `msnmMin`/`msnmMax` son el rango de metros sobre el nivel del mar.
@freezed
class NivelAltura with _$NivelAltura {
  const factory NivelAltura({
    required int id,
    required String nombre,
    int? msnmMin,
    int? msnmMax,
  }) = _NivelAltura;
}
