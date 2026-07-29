import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../dtos/perfil_dto.dart';

/// Fuente de datos remota del perfil del usuario autenticado
/// (`GET /perfil`, `CONTEXTO-MOVIL-FLUTTER.md` sección 6.8).
class PerfilRemoteDataSource {
  const PerfilRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PerfilDto> getPerfil() async {
    final response = await _apiClient.get('/perfil');
    return PerfilDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `PATCH /perfil` (`CONTEXTO-MOVIL-FLUTTER.md`, sección 6.8): único
  /// campo editable es `nombre`. El contrato no muestra ningún ejemplo
  /// de JSON de respuesta (solo "→ 200 OK") — no se parsea el cuerpo,
  /// mismo criterio ya aplicado en `anular` (Sprint 9) y `marcarLeida`
  /// (Sprint 10); quien llama refresca con un `GET /perfil` real tras
  /// el éxito.
  Future<void> actualizar(String nombre) async {
    await _apiClient.patch('/perfil', data: {'nombre': nombre});
  }

  /// `POST /perfil/foto` (`CONTEXTO-FOTO-PERFIL-MOVIL.md`): multipart con
  /// campo `foto` (no `file`, no `avatar`). A diferencia de `actualizar`,
  /// la respuesta sí trae el `PerfilDto` completo con `foto_url` ya
  /// actualizada — se parsea directo, sin depender de un refresh aparte.
  ///
  /// `contentType` se infiere de la extensión de [nombreArchivo] (vía
  /// `MultipartFile.lookupMediaType`) — sin esto, `MultipartFile.fromBytes`
  /// manda `application/octet-stream` por defecto, y la API rechaza con
  /// 400 cualquier mimetype que no sea `image/jpeg|png|webp`.
  Future<PerfilDto> subirFoto({
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    final formData = FormData.fromMap({
      'foto': MultipartFile.fromBytes(
        bytes,
        filename: nombreArchivo,
        contentType: MultipartFile.lookupMediaType(nombreArchivo),
      ),
    });
    final response = await _apiClient.post('/perfil/foto', data: formData);
    return PerfilDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// `DELETE /perfil/foto` (`CONTEXTO-FOTO-PERFIL-MOVIL.md`, actualizado):
  /// borra el archivo del bucket y devuelve el `PerfilDto` con
  /// `foto_url: null`. Idempotente — llamarlo sin foto responde 200 con
  /// el perfil tal cual, no hace falta chequear antes si hay una.
  Future<PerfilDto> eliminarFoto() async {
    final response = await _apiClient.delete('/perfil/foto');
    return PerfilDto.fromJson(response.data as Map<String, dynamic>);
  }
}
