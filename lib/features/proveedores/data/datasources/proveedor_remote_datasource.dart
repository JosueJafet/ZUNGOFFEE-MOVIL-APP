import '../../../../core/api/api_client.dart';
import '../dtos/proveedor_dto.dart';

/// Fuente de datos remota de proveedores
/// (`CONTEXTO-MOVIL-FLUTTER.md`, secciones 6.2 y 7).
class ProveedorRemoteDataSource {
  const ProveedorRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ProveedorDto>> getProveedores() async {
    final response = await _apiClient.get('/proveedores');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => ProveedorDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProveedorDto> crear({
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    final response = await _apiClient.post(
      '/proveedores',
      data: {
        'nombre': nombre,
        if (sexo != null) 'sexo': sexo,
        if (lugar != null) 'lugar': lugar,
        if (finca != null) 'finca': finca,
        if (telefono != null) 'telefono': telefono,
      },
    );
    return ProveedorDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualización parcial: solo se mandan los campos no nulos, para no
  /// sobreescribir con `null` un campo que el usuario no quiso cambiar
  /// (`CONTEXTO-MOVIL-FLUTTER.md`, sección 7: "parcial del body de
  /// arriba").
  Future<ProveedorDto> actualizar(
    int id, {
    String? nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    final response = await _apiClient.patch(
      '/proveedores/$id',
      data: {
        if (nombre != null) 'nombre': nombre,
        if (sexo != null) 'sexo': sexo,
        if (lugar != null) 'lugar': lugar,
        if (finca != null) 'finca': finca,
        if (telefono != null) 'telefono': telefono,
      },
    );
    return ProveedorDto.fromJson(response.data as Map<String, dynamic>);
  }
}
