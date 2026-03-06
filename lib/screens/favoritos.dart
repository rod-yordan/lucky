import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/producto_card.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/favoritos_provider.dart';

class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40), // Espacio para centrar
                        const Text(
                          'Mis Favoritos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Opcional: menú de opciones
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            // ================= CONTENIDO =================
            Expanded(
              child: Consumer<FavoritosProvider>(
                builder: (context, favoritosProvider, child) {
                  final productosFavoritos =
                      favoritosProvider.productosFavoritos;

                  if (productosFavoritos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes favoritos',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega productos a tus favoritos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    color: const Color(0xFFF7F7F7),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columnas
                            crossAxisSpacing: 16, // Espacio horizontal
                            mainAxisSpacing: 16, // Espacio vertical
                            childAspectRatio:
                                170 / 320, // Ancho/Alto (170/330 ≈ 0.515)
                          ),
                      itemCount: productosFavoritos.length,
                      itemBuilder: (context, index) {
                        final producto = productosFavoritos[index];
                        return ProductoCard(
                          producto: producto,
                          onTap: () {
                            context.push('/detallesProducto', extra: producto);
                          },
                          mostrarCorazon: true,
                          esFavorito: true,
                          onCorazonTap: () {
                            favoritosProvider.eliminarFavorito(producto);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Eliminado de favoritos'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
