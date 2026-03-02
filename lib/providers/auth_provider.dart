// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:lucky/models/auth_model.dart';
import 'package:lucky/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UsuarioModel? _usuario;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isChecking = true;

  // Getters
  UsuarioModel? get usuario => _usuario;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn =>
      _usuario != null && (_usuario?.id ?? 0) > 0; // ← MEJORADO
  bool get isChecking => _isChecking;

  // ==================== CONSTRUCTOR ====================
  AuthProvider() {
    _checkAuthStatus();
  }

  // ==================== VERIFICAR SESIÓN GUARDADA ====================
  Future<void> _checkAuthStatus() async {
    _isChecking = true;
    notifyListeners();

    final hasToken = await _authService.isLoggedIn();

    if (hasToken) {
      try {
        final usuario = await _authService.getPerfil();
        final token = await _authService.getStoredToken();

        if (usuario.id > 0) {
          // ← VERIFICAR ID VÁLIDO
          _usuario = usuario;
          _token = token;
          print('✅ Sesión recuperada: ${usuario.nombres} (ID: ${usuario.id})');
        } else {
          print('❌ ID de usuario inválido: ${usuario.id}');
          await _authService.logout();
        }
      } catch (e) {
        print('❌ Error recuperando sesión: $e');
        await _authService.logout();
      }
    }

    _isChecking = false;
    notifyListeners();
  }

  // ==================== LOGIN ====================
  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = LoginRequest(correo: correo, contrasena: contrasena);
      final response = await _authService.login(request);

      if (response.user != null && response.token != null) {
        // Verificar que el ID sea válido
        if (response.user!.id <= 0) {
          throw Exception('ID de usuario inválido: ${response.user!.id}');
        }

        _usuario = response.user;
        _token = response.token;
        _isLoading = false;
        notifyListeners();
        print('✅ Login exitoso: ${_usuario?.nombres} (ID: ${_usuario?.id})');
        return true;
      } else {
        _error = response.message ?? 'Error al iniciar sesión';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== REGISTRO ====================
  Future<bool> register(RegistroRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(request);

      if (response.user != null) {
        // Verificar que el ID sea válido
        if (response.user!.id <= 0) {
          throw Exception('ID de usuario inválido: ${response.user!.id}');
        }

        // Si el registro devuelve usuario y token (login automático)
        if (response.token != null) {
          _usuario = response.user;
          _token = response.token;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Error al registrarse';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== CARGAR PERFIL ====================
  Future<bool> cargarPerfil() async {
    if (!isLoggedIn) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final usuario = await _authService.getPerfil();

      if (usuario.id <= 0) {
        throw Exception('ID de usuario inválido: ${usuario.id}');
      }

      _usuario = usuario;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    await _authService.logout();
    _usuario = null;
    _token = null;
    notifyListeners();
  }

  // ==================== LIMPIAR ERROR ====================
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
