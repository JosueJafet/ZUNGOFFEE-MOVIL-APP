import '../../../../core/api/api_client.dart';
import '../dtos/cliente_dto.dart';

/// Fuente de datos remota de clientes
/// (`CONTEXTO-MOVIL-FLUTTER.md`, secciones 6.2b y 7).
class ClienteRemoteDataSource {
  const ClienteRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ClienteDto>> getClientes() async {
    final response = await _apiClient.get('/clientes');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => ClienteDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ClienteDto> crear({
    required String nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    final response = await _apiClient.post(
      '/clientes',
      data: {
        'nombre': nombre,
        if (tipoId != null) 'tipoId': tipoId,
        if (lugar != null) 'lugar': lugar,
        if (telefono != null) 'telefono': telefono,
      },
    );
    return ClienteDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualización parcial: solo se mandan los campos no nulos, para no
  /// sobreescribir con `null` un campo que el usuario no quiso cambiar
  /// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 7) — mismo patrón que
  /// `ProveedorRemoteDataSource.actualizar` (Sprint 5).
  Future<ClienteDto> actualizar(
    int id, {
    String? nombre,
    int? tipoId,
    String? lugar,
    String? telefono,
  }) async {
    final response = await _apiClient.patch(
      '/clientes/$id',
      data: {
        if (nombre != null) 'nombre': nombre,
        if (tipoId != null) 'tipoId': tipoId,
        if (lugar != null) 'lugar': lugar,
        if (telefono != null) 'telefono': telefono,
      },
    );
    return ClienteDto.fromJson(response.data as Map<String, dynamic>);
  }
}