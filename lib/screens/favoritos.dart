import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});
  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Column(
       
          mainAxisAlignment: .center,
          children: [
            const Text('Mis favoritos:'),
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