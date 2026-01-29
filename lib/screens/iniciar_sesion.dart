import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});
  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Column(
       
          mainAxisAlignment: .center,
          children: [
            const Text('No tienes una cuenta? Registrate:'),
            ElevatedButton(
              onPressed: () {
                context.go("/registroUsuario");
              },
              child: const Text("Registrarse"),
            ),
            
            ],
        ),
      ),
    );
  }
}