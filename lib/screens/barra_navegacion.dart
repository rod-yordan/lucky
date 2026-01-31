import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarraNavegacion extends StatelessWidget {
  final int currentIndex;

  const BarraNavegacion({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catálogo'),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Cupones',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mi cuenta'),
      ],
    );
  }
}
