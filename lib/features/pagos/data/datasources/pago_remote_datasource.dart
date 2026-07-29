import '../../../../core/api/api_client.dart';
import '../../../../core/utils/api_date.dart';
import '../dtos/pago_dto.dart';
import '../dtos/pagos_resumen_dto.dart';

/// Fuente de datos remota de pagos — contrato confirmado por Rubio,
/// backend (no está en ningún `CONTEXTO-*.md`).
class PagoRemoteDataSource {
  const PagoRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PagosResumenDto> getResumen() async {
    final response = await _apiClient.get('/pagos/resumen');
    return PagosResumenDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<PagoDto>> getHistorialPorBodega(int tenantId) async {
    final response = await _apiClient.get('/pagos/tenant/$tenantId');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => PagoDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Descarta el body de la respuesta a propósito: `POST /pagos` no
  /// incluye `estado_calculado` (gotcha verificado por Rubio), así que
  /// parsearlo con `PagoDto` fallaría — quien dispara esto invalida y
  /// vuelve a pedir `pagosHistorialProvider` (que sí lo trae siempre),
  /// mismo criterio que `BodegaRemoteDataSource.suspender`/`activar`.
  Future<void> registrar({
    required int tenantId,
    required DateTime periodo,
    required double monto,
    required DateTime fechaVencimiento,
  }) async {
    await _apiClient.post(
      '/pagos',
      data: {
        'tenantId': tenantId,
        'periodo': ApiDate.toRequestDate(periodo),
        'monto': monto,
        'fechaVencimiento': ApiDate.toRequestDate(fechaVencimiento),
      },
    );
  }

  /// Mismo motivo que `registrar`: `PATCH /pagos/:id/marcar-pagado`
  /// tampoco incluye `estado_calculado` en su respuesta.
  Future<void> marcarPagado(int id) async {
    await _apiClient.patch('/pagos/$id/marcar-pagado');
  }
}
