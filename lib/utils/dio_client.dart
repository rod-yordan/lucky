import 'package:dio/dio.dart';

// Cliente para APIs públicas (productos, etc)
class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ));

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 REQUEST[${options.method}] => PATH: ${options.path}');
          print('📦 BODY: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ERROR[${e.response?.statusCode}] => ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}

// Cliente para autenticación (con manejo de token)
class AuthClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ));

  static void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    // También guardar en ApiClient para peticiones autenticadas de productos
    ApiClient.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void removeAuthToken() {
    dio.options.headers.remove('Authorization');
    ApiClient.dio.options.headers.remove('Authorization');
  }

  static bool get isAuthenticated {
    return dio.options.headers.containsKey('Authorization');
  }
}


