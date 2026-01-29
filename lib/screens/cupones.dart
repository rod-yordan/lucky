import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Cupones extends StatefulWidget {
  const Cupones({super.key});
  @override
  State<Cupones> createState() => _CuponesState();
}

class _CuponesState extends State<Cupones> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Column(
       
          mainAxisAlignment: .center,
          children: [
            const Text('Mis cupones:'),
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