import 'package:flutter/material.dart';

class BarraNavegacion extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap; // <-- Agregar callback

  const BarraNavegacion({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTap, // <-- Usar el callback
      elevation: 8, // Sombra más pronunciada
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
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
