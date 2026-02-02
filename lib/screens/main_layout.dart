import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/barra_navegacion.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BarraNavegacion(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navegar a la página correspondiente
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/catalogo');
              break;
            case 2:
              context.go('/cupones');
              break;
            case 3:
              context.go('/favoritos');
              break;
            case 4:
              context.go('/iniciarSesion');
              break;
          }
        },
      ),
      body: SafeArea(child: widget.child),
    );
  }
}
