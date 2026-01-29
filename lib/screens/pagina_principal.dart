import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _barraSuperior(),
            _categorias(),
            _recomendado(),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _barraInferior(context),
    );
  }

  //widget barra superior
  Widget _barraSuperior() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('logo.jpg', height: 50),
              const Icon(Icons.shopping_cart_outlined, size: 28),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Buscar productos...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🧭 Categorías
  Widget _categorias() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text('Todo', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Mujer'),
        Text('Hombre'),
        Text('Promociones'),
      ],
    );
  }

  // ⭐ Recomendado
  Widget _recomendado() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Recomendado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text('Ver todo', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  // 📱 Barra inferior
  Widget _barraInferior(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0: 
            context.go('/');
            break;
          case 1: 
            context.go("/catalogo");
            break;
          case 2: 
            context.go("/cupones");
            break;
          case 3:
            context.go("/favoritos");
            break;
          case 4: 
            context.go('/iniciarSesion');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catálogo'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Cupones'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mi cuenta'),
      ],
    );
  }
}
