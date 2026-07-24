import '../../../../core/api/api_client.dart';
import '../dtos/compra_dto.dart';

/// Una línea de una compra a registrar (`CONTEXTO-MOVIL-FLUTTER.md`,
/// sección 6.3). Solo se manda, nunca se recibe — por eso no es un DTO con
/// `fromJson`, solo un `toJson()` propio.
class LineaCompraInput {
  const LineaCompraInput({
    required this.estadoCafeId,
    required this.variedadId,
    required this.alturaId,
    required this.humedad,
    required this.cantidad,
    required this.costoUnitario,
  });

  final int estadoCafeId;
  final int variedadId;
  final int alturaId;
  final double humedad;
  final double cantidad;
  final double costoUnitario;

  Map<String, dynamic> toJson() => {
    'estadoCafeId': estadoCafeId,
    'variedadId': variedadId,
    'alturaId': alturaId,
    'humedad': humedad,
    'cantidad': cantidad,
    'costoUnitario': costoUnitario,
  };
}

/// Fuente de datos remota de compras (`CONTEXTO-MOVIL-FLUTTER.md`, sección
/// 6.3).
class ComprasRemoteDataSource {
  const ComprasRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  /// `metodoPagoId` es opcional según la documentación del endpoint: solo
  /// se incluye en el body si no es nulo, mismo patrón de body parcial ya
  /// usado en `ProveedorRemoteDataSource.actualizar` (Sprint 5).
  Future<CompraDto> crear({
    required int proveedorId,
    int? metodoPagoId,
    required List<LineaCompraInput> lineas,
  }) async {
    final response = await _apiClient.post(
      '/compras',
      data: {
        'proveedorId': proveedorId,
        if (metodoPagoId != null) 'metodoPagoId': metodoPagoId,
        'lineas': lineas.map((linea) => linea.toJson()).toList(),
      },
    );
    return CompraDto.fromJson(response.data as Map<String, dynamic>);
  }
}
