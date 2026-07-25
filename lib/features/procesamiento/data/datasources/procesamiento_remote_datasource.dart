import '../../../../core/api/api_client.dart';
import '../dtos/procesamiento_dto.dart';

/// Fuente de datos remota de procesamiento (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.6).
class ProcesamientoRemoteDataSource {
  const ProcesamientoRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `loteOrigenId` se declara `String` (coincide con `Lote.id`,
  /// `BigIntId`) y se manda tal cual — mismo criterio que
  /// `LineaVentaInput.loteId` (Sprint 7): el contrato acepta tanto número
  /// como string para IDs de lote.
  Future<ProcesamientoDto> crear({
    required String loteOrigenId,
    required int estadoDestinoId,
    required double cantidadEntrada,
    required double cantidadSalida,
  }) async {
    final response = await _apiClient.post(
      '/procesamiento',
      data: {
        'loteOrigenId': loteOrigenId,
        'estadoDestinoId': estadoDestinoId,
        'cantidadEntrada': cantidadEntrada,
        'cantidadSalida': cantidadSalida,
      },
    );
    return ProcesamientoDto.fromJson(response.data as Map<String, dynamic>);
  }
}
