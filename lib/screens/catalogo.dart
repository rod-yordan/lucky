import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

 

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Column(
       
          mainAxisAlignment: .center,
          children: [
            const Text('Categorias:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go("");
              },
              child: const Text("Hombre"),
            ),
            ElevatedButton(
              onPressed: () {
                context.go("");
              },
              child: const Text("Mujer"),
            ),
          ],
        ),
      ),
    );
  }
}