import 'package:dio/dio.dart';

class DioClient {
  // Cambia esta URL por la de tu backend Laravel
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  static void init() {
    // Agregar interceptor para logging en desarrollo
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('QUERY: ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // Para cuando implementes autenticación
  static void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void removeAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
