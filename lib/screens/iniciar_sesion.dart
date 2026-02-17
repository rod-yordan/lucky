import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/services/auth_service.dart';
import 'package:lucky/models/auth_model.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  bool _ocultarContrasena = true;
  bool _isLoading = false;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _handleLogin() async {
    // Validar campos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        correo: _emailController.text.trim(),
        contrasena: _passwordController.text,
      );

      final response = await _authService.login(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido ${response.user?.nombreCompleto ?? ''}!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Redirigir a la página principal
        context.go('/');
      }
    } catch (e) {
      _mostrarError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= BARRA SUPERIOR =================
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Center(child: Image.asset('logo.jpg', height: 45)),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenido de vuelta',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            // ================= CONTENIDO
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Campo de correo
                    _campoTexto(
                      label: 'Correo electrónico',
                      placeholder: 'ejemplo@correo.com',
                      controller: _emailController,
                    ),

                    const SizedBox(height: 24),

                    // Campo de contraseña
                    _campoContrasena(),

                    const SizedBox(height: 12),

                    // Olvidaste contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Aquí puedes navegar a recuperar contraseña
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botón de iniciar sesión
                    _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : _botonIniciarSesion(),
                    
                    const Spacer(),

                    // Registro
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(height: 8),

                          TextButton(
                            onPressed: () {
                              context.go('/registroUsuario');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                            ),
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CAMPO DE TEXTO =================
  Widget _campoTexto({
    required String label, 
    required String placeholder,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // ================= CAMPO DE CONTRASEÑA =================
  Widget _campoContrasena() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _ocultarContrasena,
                  decoration: InputDecoration(
                    hintText: '********',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _ocultarContrasena = !_ocultarContrasena;
                  });
                },
                child: Icon(
                  _ocultarContrasena ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= BOTÓN INICIAR SESIÓN =================
  Widget _botonIniciarSesion() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Iniciar sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}