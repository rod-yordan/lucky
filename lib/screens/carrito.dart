import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});
  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Mis productos:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go("/");
              },
              child: const Text(""),
            ),
          ],
        ),
      ),
    );
  }
}
