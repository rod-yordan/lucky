import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/favoritos_provider.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
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
                            // Aquí podrías agregar funcionalidad de limpiar favoritos
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Navegar a la página principal
                              // (Esto se manejará desde la barra de navegación)
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0000),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Ver productos'),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    color: const Color(0xFFF7F7F7),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        // Grid de productos favoritos
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: productosFavoritos.length,
                          itemBuilder: (context, index) {
                            return _productoFavoritoCard(
                              productosFavoritos[index],
                              favoritosProvider,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
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

  Widget _productoFavoritoCard(
    Map<String, dynamic> producto,
    FavoritosProvider favoritosProvider,
  ) {
    final List<String> imagenes = producto['imagenes'] != null
        ? List<String>.from(producto['imagenes'])
        : [];
    final String imagenPrincipal = imagenes.isNotEmpty ? imagenes[0] : '';
    final int descuentoPorcentaje = producto['descuento'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con botón de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  imagenPrincipal,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Botón para quitar de favoritos
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    favoritosProvider.eliminarFavorito(producto);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(200),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 20,
                      color: Color(0xFFFF0000),
                    ),
                  ),
                ),
              ),
              // Badge de descuento
              if (descuentoPorcentaje > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000),
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
                ),
            ],
          ),
          // Información del producto
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  producto['titulo'] ?? 'Producto sin nombre',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Precios
                Row(
                  children: [
                    Text(
                      'S/ ${producto['precio']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Color(0xFFFF0000),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (producto['precioAntes'] != null &&
                        producto['precioAntes'] != producto['precio']) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'S/ ${producto['precioAntes']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
