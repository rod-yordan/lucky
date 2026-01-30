import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final PageController _pageController = PageController();
  int _paginaActual = 0;

  final List<String> banners = ['assets/banner1.png', 'assets/banner2.png'];

  @override
  void initState() {
    super.initState();
    _autoScroll();
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;

      _paginaActual = (_paginaActual + 1) % banners.length;

      _pageController.animateToPage(
        _paginaActual,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Column(children: [_barraSuperior(), _categorias()]),
            ),

            _bannerCarrusel(context),
            _recomendado(),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _barraInferior(context),
    );
  }

  // Widget barra superior
  Widget _barraSuperior() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('logo.jpg', height: 50),
            const Icon(Icons.shopping_cart_outlined, size: 28),
          ],
        ),
        const SizedBox(height: 16),
        // Barra de búsqueda
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
              Text('Buscar productos...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Categorías
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

  // Widget para banners publicitarios
  Widget _bannerCarrusel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 0),
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _paginaActual = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => context.go('/catalogo'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      banners[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),

            // Indicadores
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _paginaActual == index ? 10 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _paginaActual == index
                          ? Colors.white
                          : Colors.white.withAlpha(120),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recomendado
  Widget _recomendado() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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

  // Barra inferior
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
