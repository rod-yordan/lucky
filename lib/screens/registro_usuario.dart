import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

 

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Column(
       
          mainAxisAlignment: .center,
          children: [
            const Text('Registrate:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go("/iniciarSesion");
              },
              child: const Text("Ir a iniciar sesion"),
            ),
          ],
        ),
      ),
    );
  }
}
