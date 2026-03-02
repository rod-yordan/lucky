// services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:lucky/models/auth_model.dart';
import 'package:lucky/utils/dio_client.dart';
import 'package:lucky/services/pref_service.dart'; // ← AGREGAR

class AuthService {
  final Dio _dio = AuthClient.dio;
  final PrefService _prefs = PrefService(); // ← AGREGAR

  // Guardar token
  Future<void> _saveToken(String token) async {
    await _prefs.setString('token', token); // ← GUARDAR EN SHARED PREFERENCES
    AuthClient.setAuthToken(token);
  }

  // Obtener token guardado
  Future<String?> getStoredToken() async {
    return _prefs.getString('token', defaultValue: ''); // ← RECUPERAR
  }

  // Eliminar token (logout)
  Future<void> removeToken() async {
    await _prefs.remove('token'); // ← ELIMINAR
    AuthClient.removeAuthToken();
  }

  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  // Iniciar sesión
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/login', data: request.toJson());

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);

        // Guardar token si existe
        if (authResponse.token != null) {
          await _saveToken(authResponse.token!); // ← AHORA USA _saveToken
        }

        return authResponse;
      } else {
        throw Exception('Error en el login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Registrar usuario
  Future<AuthResponse> register(RegistroRequest request) async {
    try {
      final response = await _dio.post('/register', data: request.toJson());

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);

        // Si el registro devuelve token (login automático)
        if (authResponse.token != null) {
          await _saveToken(authResponse.token!);
        }

        return authResponse;
      } else {
        throw Exception('Error en el registro: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener perfil del usuario autenticado
  Future<UsuarioModel> getPerfil() async {
    try {
      final response = await _dio.get('/perfil');

      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener perfil');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await removeToken(); // ← AHORA USA removeToken
  }

  // Manejo de errores
  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;

      // Si el error es un mapa con mensaje
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      // Errores de validación
      if (data is Map && data['errors'] != null) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }

      return 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
    } else {
      return 'Error de conexión: ${e.message}';
    }
  }
}
