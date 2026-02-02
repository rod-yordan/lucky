import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  bool _ocultarContrasena = true;

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
                  // Logo centrado
                  Center(child: Image.asset('logo.jpg', height: 45)),
                  const SizedBox(height: 16),
                  // Bienvenido de vuelta centrado
                  const Text(
                    'Únete a nuestra comunidad',
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
                    const SizedBox(height: 32),

                    _campoTexto(label: 'Nombres', placeholder: 'Juan Carlos'),

                    const SizedBox(height: 24),

                    _campoTexto(
                      label: 'Apellidos',
                      placeholder: 'Peréz Alvarado',
                    ),

                    const SizedBox(height: 24),

                    _campoTexto(
                      label: 'Correo electrónico',
                      placeholder: 'ejemplo@correo.com',
                    ),

                    const SizedBox(height: 24),

                    _campoContrasena(),

                    const SizedBox(height: 44),

                    // Botón de iniciar sesión
                    _botonRegistrarse(),
                    const Spacer(),

                    // Registro
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta?',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(height: 8),

                          // Navegar a registro
                          TextButton(
                            onPressed: () {
                              context.go('/iniciarSesion');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                            ),
                            child: const Text(
                              'Inicia sesión',
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
  Widget _campoTexto({required String label, required String placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
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
        const SizedBox(height: 12),
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
  Widget _botonRegistrarse() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          context.go('/');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Registrarse',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
