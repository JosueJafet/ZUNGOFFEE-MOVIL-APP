import '../../../../core/api/api_client.dart';
import '../dtos/venta_dto.dart';

/// Una línea de una venta a registrar (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.5). Solo se manda, nunca se recibe — por eso no es un DTO con
/// `fromJson`, solo un `toJson()` propio. `loteId` se declara `String`
/// (no `int`) porque coincide con `Lote.id` (`features/inventario`,
/// `BigIntId`) — el contrato acepta tanto número como string, así que se
/// manda tal cual sin parseo.
class LineaVentaInput {
  const LineaVentaInput({
    required this.loteId,
    required this.cantidad,
    required this.precioUnitario,
  });

  final String loteId;
  final double cantidad;
  final double precioUnitario;

  Map<String, dynamic> toJson() => {
    'loteId': loteId,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
  };
}

/// Fuente de datos remota de ventas (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.5).
class VentasRemoteDataSource {
  const VentasRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `metodoPagoId` es opcional según la documentación del endpoint —
  /// mismo patrón de body parcial que `ComprasRemoteDataSource.crear`
  /// (Sprint 6).
  Future<VentaDto> crear({
    required int clienteId,
    int? metodoPagoId,
    required List<LineaVentaInput> lineas,
  }) async {
    final response = await _apiClient.post(
      '/ventas',
      data: {
        'clienteId': clienteId,
        if (metodoPagoId != null) 'metodoPagoId': metodoPagoId,
        'lineas': lineas.map((linea) => linea.toJson()).toList(),
      },
    );
    return VentaDto.fromJson(response.data as Map<String, dynamic>);
  }
}