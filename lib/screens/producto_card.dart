import 'package:flutter/material.dart';

class ProductoCard extends StatelessWidget {
  final Map<String, dynamic> producto;
  final VoidCallback? onTap;
  final bool mostrarCorazon;
  final bool esFavorito;
  final VoidCallback? onCorazonTap;

  const ProductoCard({
    super.key,
    required this.producto,
    this.onTap,
    this.mostrarCorazon = false,
    this.esFavorito = false,
    this.onCorazonTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = List<String>.from(producto['imagenes']);
    final String imagenPrincipal = imagenes.isNotEmpty ? imagenes[0] : '';
    int descuentoPorcentaje = producto['descuento'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                imagenPrincipal,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y corazón a la derecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título (ocupa la mayor parte del espacio)
                      Expanded(
                        child: Text(
                          producto['titulo'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      // Corazón a la derecha (solo si mostrarCorazon es true)
                      if (mostrarCorazon)
                        GestureDetector(
                          onTap: onCorazonTap,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, top: 2),
                            child: Icon(
                              esFavorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: esFavorito ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'S/ ${producto['precio']}',
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
                  if (producto['precioAntes'] != null &&
                      producto['precioAntes'] != producto['precio']) ...[
                    Stack(
                      children: [
                        Text(
                          'S/ ${producto['precioAntes']}',
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
