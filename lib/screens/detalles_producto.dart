import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';

class DetallesProducto extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetallesProducto({super.key, required this.producto});

  @override
  State<DetallesProducto> createState() => _DetallesProductoState();
}

class _DetallesProductoState extends State<DetallesProducto> {
  String _tallaSeleccionada = '28';
  String _colorSeleccionado = 'Azul';
  int _paginaActual = 0;
  final PageController _pageController = PageController();

  List<String> get imagenesProducto {
    return List<String>.from(widget.producto['imagenes']);
  }

  final List<String> tallas = ['28', '30', '32'];
  final List<Map<String, dynamic>> colores = [
    {'nombre': 'Azul', 'codigo': Color(0xFF1E3A8A)},
    {'nombre': 'Negro', 'codigo': Colors.black},
    {'nombre': 'Gris', 'codigo': Color(0xFF6B7280)},
    {'nombre': 'Blanco', 'codigo': Colors.white},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    int descuentoPorcentaje = producto['descuento'] ?? 0;
    bool tienePrecioAnterior =
        producto['precioAntes'] != null &&
        producto['precioAntes'] != producto['precio'];

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
                        Consumer<CarritoProvider>(
                          builder: (context, carritoProvider, child) {
                            final cantidadTotal = carritoProvider.cantidadTotal;

                            return Stack(
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
                                        cantidadTotal > 9
                                            ? '9+'
                                            : cantidadTotal.toString(),
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
                            );
                          },
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
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: imagenesProducto.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _paginaActual = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    imagenesProducto[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  imagenesProducto.length,
                                  (index) {
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: _paginaActual == index ? 10 : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _paginaActual == index
                                            ? Colors.white
                                            : Colors.white.withAlpha(120),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
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
                                    margin: const EdgeInsets.only(right: 6),
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
                                    margin: const EdgeInsets.only(right: 10),
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
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.go('/favoritos');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.favorite_border,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'A favoritos',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Botón "Al carrito"
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final carritoProvider =
                                          Provider.of<CarritoProvider>(
                                            context,
                                            listen: false,
                                          );

                                      // Crear producto con las selecciones del usuario
                                      final productoCarrito = {
                                        ...widget.producto,
                                        'talla': _tallaSeleccionada,
                                        'color': _colorSeleccionado,
                                      };

                                      // Agregar al carrito usando el Provider
                                      carritoProvider.agregarProducto(
                                        productoCarrito,
                                      );

                                      // Mostrar mensaje de confirmación
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${widget.producto['titulo']} ($_tallaSeleccionada, $_colorSeleccionado) agregado al carrito',
                                          ),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'Ver carrito',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              if (mounted) {
                                                context.go('/carrito');
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFED1C24),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Al carrito',
                                          style: TextStyle(fontSize: 16),
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
