import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';

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
      'imagenes': [
        'assets/jean_mujer.png',
        'assets/jean_mujer2.jpg',
        'assets/jean_mujer3.jpg',
        'assets/jean_mujer4.jpg',
      ],
      'titulo': 'Jean Mujer Skinny Denim',
      'precio': 89.90,
      'precioAntes': 179.90,
      'descuento': 50,
    },
    {
      'imagenes': [
        'assets/jean_hombre.png',
        'assets/jean_hombre2.png',
        'assets/jean_hombre3.png',
      ],
      'titulo': 'Jean Hombre Silueta Slim',
      'precio': 119.90,
      'precioAntes': 159.90,
      'descuento': 25,
    },
    {
      'imagenes': [
        'assets/casaca_hombre.png',
        'assets/casaca_hombre2.png',
        'assets/casaca_hombre3.png',
        'assets/casaca_hombre4.png',
      ],
      'titulo': 'Casaca Hombre Knife Total Bio Blue',
      'precio': 209.90,
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
      body: SafeArea(
        child: Column(
          children: [
            // ================= BARRA SUPERIOR =================
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(height: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _barraSuperior(),
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
                        children: [
                          const SizedBox(height: 12),
                          _categorias(),
                          const SizedBox(height: 14),
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

  Widget _barraSuperior() {
    return Consumer<CarritoProvider>(
      builder: (context, carritoProvider, child) {
        final cantidadTotal = carritoProvider.cantidadTotal;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/logo.jpg', height: 45),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.go('/carrito');
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    if (cantidadTotal > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFED1C24),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            cantidadTotal > 9 ? '9+' : cantidadTotal.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                context.go('/busqueda');
              },
              child: Container(
                width: double.infinity,
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
                    Text(
                      'Buscar productos...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= CATEGORIAS =================
  Widget _categorias() {
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

  // ================= BANNER =================
  Widget _bannerCarrusel() {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
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
      height: 330,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) => _productoCard(lista[i]),
      ),
    );
  }

  // ================= CARD PRODUCTO =================
  Widget _productoCard(Map<String, dynamic> p) {
    final List<String> imagenes = List<String>.from(p['imagenes']);
    final String imagenPrincipal = imagenes.isNotEmpty ? imagenes[0] : '';
    int descuentoPorcentaje = p['descuento'] ?? 0;

    return GestureDetector(
      onTap: () {
        context.go('/detallesProducto', extra: p);
      },
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                imagenPrincipal,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['titulo'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'S/ ${p['precio']}',
                        style: const TextStyle(
                          color: Color(0xFFED1C24),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (descuentoPorcentaje > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFED1C24),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-$descuentoPorcentaje%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (p['precioAntes'] != null &&
                      p['precioAntes'] != p['precio']) ...[
                    Stack(
                      children: [
                        Text(
                          'S/ ${p['precioAntes']}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
