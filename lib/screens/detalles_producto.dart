import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/barra_navegacion.dart';

class DetallesProducto extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetallesProducto({super.key, required this.producto});

  @override
  State<DetallesProducto> createState() => _DetallesProductoState();
}

class _DetallesProductoState extends State<DetallesProducto> {
  String _tallaSeleccionada = '28';
  String _colorSeleccionado = 'Azul';

  final List<String> tallas = ['28', '30', '32'];
  final List<Map<String, dynamic>> colores = [
    {'nombre': 'Azul', 'codigo': Color(0xFF1E3A8A)},
    {'nombre': 'Negro', 'codigo': Colors.black},
    {'nombre': 'Gris', 'codigo': Color(0xFF6B7280)},
    {'nombre': 'Blanco', 'codigo': Colors.white},
  ];

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    int descuentoPorcentaje = producto['descuento'] ?? 0;
    bool tienePrecioAnterior =
        producto['precioAntes'] != null &&
        producto['precioAntes'] != producto['precio'];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BarraNavegacion(currentIndex: 0),
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
                        GestureDetector(
                          onTap: () {
                            context.go('/');
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const Icon(Icons.shopping_cart_outlined, size: 28),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            // ================= CONTENIDO =================
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Imagen del producto
                      Container(
                        height: 500,
                        width: double.infinity,
                        color: Colors.white,
                        child: Image.asset(
                          producto['imagen'],
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),

                      // Información del producto
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            Text(
                              producto['titulo'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 8),

                            // Precios
                            Row(
                              children: [
                                Text(
                                  'S/ ${producto['precio']}',
                                  style: const TextStyle(
                                    color: Color(0xFFED1C24),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // Precio anterior (si existe)
                                if (tienePrecioAnterior) ...[
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Stack(
                                      children: [
                                        Text(
                                          'S/ ${producto['precioAntes']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height: 1, // Grosor del tachado
                                              color: Colors
                                                  .grey
                                                  .shade700, // Color gris
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                if (descuentoPorcentaje > 0) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFED1C24),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '-$descuentoPorcentaje%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Selección de color
                            const Text(
                              'Color:',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: colores.map((color) {
                                bool seleccionado =
                                    color['nombre'] == _colorSeleccionado;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _colorSeleccionado = color['nombre'];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: seleccionado
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: color['codigo'],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade500,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),

                            // Selección de talla
                            const Text(
                              'Talla:',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: tallas.map((talla) {
                                bool seleccionada = talla == _tallaSeleccionada;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _tallaSeleccionada = talla;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: seleccionada
                                          ? Colors.grey.shade300
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: seleccionada
                                            ? Colors.black
                                            : Colors.grey.shade500,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      talla,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 32),

                            // Botones de acción
                            Row(
                              children: [
                                // Botón "A favoritos"
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.favorite_border,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'A favoritos',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Botón "Al carrito"
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Al carrito',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Descripción (opcional)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descripción',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Jean de corte skinny en tela denim de alta calidad. Perfecto para looks casuales y elegantes. Confeccionado con materiales resistentes para mayor durabilidad.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
