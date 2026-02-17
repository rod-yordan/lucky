// Modelo de Usuario (adaptado a tu tabla 'usuario' en BD)
class UsuarioModel {
  final int id;
  final String nombres;
  final String apellidos;
  final String correo;
  final int idRol;
  final String? createdAt;
  final String? updatedAt;

  UsuarioModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.idRol,
    this.createdAt,
    this.updatedAt,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      correo: json['correo'] ?? '',
      idRol: json['id_rol'] ?? 2,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}

// Request para Login (usa correo y contrasena)
class LoginRequest {
  final String correo;
  final String contrasena;

  LoginRequest({
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}

// Request para Registro (usa nombres, apellidos, correo, contrasena)
class RegistroRequest {
  final String nombres;
  final String apellidos;
  final String correo;
  final String contrasena;

  RegistroRequest({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}

// Respuesta de Autenticación
class AuthResponse {
  final String? message;
  final UsuarioModel? user;
  final String? token;

  AuthResponse({
    this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      user: json['user'] != null ? UsuarioModel.fromJson(json['user']) : null,
      token: json['token'],
    );
  }
}