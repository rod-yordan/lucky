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

  final List<Map<String, dynamic>> productos = [
    {
      'imagen': 'assets/jean_mujer.png',
      'titulo': 'Jean Mujer Skinny Denim',
      'precio': 89.90,
      'precioAntes': 179.90,
    },
    {
      'imagen': 'assets/jean_hombre.png',
      'titulo': 'Jean Hombre Silueta Slim',
      'precio': 119.90,
      'precioAntes': 159.90,
    },
    {
      'imagen': 'assets/jean_hombre.png',
      'titulo': 'Jean Hombre Silueta Slim',
      'precio': 119.90,
      'precioAntes': 159.90,
    },
  ];

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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _barraInferior(context),
      body: SafeArea(
        child: Column(
          children: [
            // ================= BARRA SUPERIOR =================
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: const [SizedBox(height: 20)]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _BarraSuperior(),
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            // ================= CONTENIDO =================
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: const [
                          SizedBox(height: 12),
                          _Categorias(),
                          SizedBox(height: 14),
                        ],
                      ),
                    ),

                    _bannerCarrusel(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _seccionProductos(
                            titulo: 'Recomendado',
                            productos: productos,
                          ),
                          _seccionProductos(
                            titulo: 'Más populares',
                            productos: productos,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BANNER =================
  Widget _bannerCarrusel() {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        onPageChanged: (i) => setState(() => _paginaActual = i),
        itemBuilder: (_, i) {
          return Image.asset(
            banners[i],
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }

  // ================= SECCIÓN REUTILIZABLE =================
  Widget _seccionProductos({
    required String titulo,
    required List<Map<String, dynamic>> productos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Ver todo', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        _listaProductos(productos),
      ],
    );
  }

  // ================= LISTA PRODUCTOS =================
  Widget _listaProductos(List<Map<String, dynamic>> lista) {
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, i) => _productoCard(lista[i]),
      ),
    );
  }

  // ================= CARD PRODUCTO =================
  Widget _productoCard(Map<String, dynamic> p) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              p['imagen'],
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['titulo'], maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(
                  'S/ ${p['precio']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'S/ ${p['precioAntes']}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= BARRA INFERIOR =================
  Widget _barraInferior(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        if (i == 0) context.go('/');
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

// ================= WIDGETS PEQUEÑOS =================

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('logo.jpg', height: 45),
            const Icon(Icons.shopping_cart_outlined, size: 28),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text('Buscar productos...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Categorias extends StatelessWidget {
  const _Categorias();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Todo', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Mujer'),
        Text('Hombre'),
        Text('Promociones'),
      ],
    );
  }
}
