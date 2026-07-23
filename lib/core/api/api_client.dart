import 'package:dio/dio.dart';

import '../config/app_environment.dart';
import '../errors/api_exception.dart';
import '../errors/network_exception.dart';
import 'session_token_provider.dart';

/// Cliente HTTP centralizado para la API de Zungo Coffee.
///
/// Único lugar del proyecto que debe hablar con `Dio` directamente — los
/// repositories de cada feature deben usar [get]/[post]/[patch], nunca
/// instanciar su propio `Dio`.
///
/// Toda excepción que sale de estos métodos es [ApiException] (la API
/// respondió con un error) o [NetworkException] (nunca hubo respuesta:
/// timeout, sin conexión, cold start de Render más lento que el timeout
/// configurado) — nunca un `DioException` crudo, para que
/// `AsyncValue.guard` de Riverpod las capture de forma directa en la UI.
class ApiClient {
  /// [dio] es un seam de pruebas: si no se pasa, se crea un `Dio` real
  /// configurado con [AppEnvironment]. Los tests pueden pasar un `Dio`
  /// con un `httpClientAdapter` falso, sin tocar la red.
  ApiClient(this._tokenProvider, {Dio? dio})
    : _dio = dio ??
          Dio(
            BaseOptions(
              baseUrl: AppEnvironment.apiBaseUrl,
              connectTimeout: AppEnvironment.apiConnectTimeout,
              receiveTimeout: AppEnvironment.apiReceiveTimeout,
            ),
          ) {
    _dio.interceptors.add(_AuthInterceptor(_tokenProvider));
  }

  final Dio _dio;
  final SessionTokenProvider _tokenProvider;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _guard(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<Response<dynamic>> post(String path, {Object? data}) {
    return _guard(() => _dio.post(path, data: data));
  }

  Future<Response<dynamic>> patch(String path, {Object? data}) {
    return _guard(() => _dio.patch(path, data: data));
  }

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      Error.throwWithStackTrace(_translate(e), e.stackTrace);
    }
  }

  /// Traduce un `DioException` a [ApiException] (hubo respuesta con el
  /// formato de error estándar de la API) o [NetworkException] (no hubo
  /// respuesta). Sobre un 401 no se hace ningún redirect aquí — eso es
  /// responsabilidad del router, que reacciona a los cambios de sesión.
  Exception _translate(DioException e) {
    final data = e.response?.data;
    if (e.response != null && data is Map<String, dynamic>) {
      return ApiException(
        statusCode: (data['statusCode'] as int?) ?? e.response!.statusCode ?? 0,
        message: _readMessage(data['message']),
        error: data['error'] as String?,
      );
    }
    return NetworkException(_networkMessageFor(e.type));
  }

  /// `message` casi siempre es un `String`, pero NestJS también puede
  /// devolverlo como `List<String>` en errores de validación.
  String? _readMessage(Object? message) {
    if (message is String) return message;
    if (message is List) return message.join(', ');
    return null;
  }

  String _networkMessageFor(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'La conexión tardó demasiado. El servidor puede estar '
            'arrancando en frío (hasta ~50s) o la señal es débil — '
            'intenta de nuevo.';
      case DioExceptionType.connectionError:
        return 'No hay conexión con el servidor. Revisa tu conexión a '
            'internet.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return 'Ocurrió un error de red inesperado.';
    }
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._tokenProvider);

  final SessionTokenProvider _tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
