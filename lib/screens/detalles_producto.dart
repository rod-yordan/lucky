import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/providers/favoritos_provider.dart';
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

  // Método para mostrar el overlay de confirmación
  void _mostrarMensajeConfirmacion(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.green,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Agregado al carrito',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Mostrar el overlay
    overlay.insert(overlayEntry);

    // Ocultar automáticamente después de 2 segundos
    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
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
                      vertical: 7,
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
                                        color: Color(0xFFFF0000),
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

            // ================= CONTENIDO (TODO SE DESPLAZA) =================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Imagen del producto
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
                                child: Image.network(
                                  imagenesProducto[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
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
                              children: List.generate(imagenesProducto.length, (
                                index,
                              ) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
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
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Información del producto
                    Container(
                      color: const Color(0xFFF7F7F7),
                      child: Padding(
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
                                    color: Color(0xFFFF0000),
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
                                              height: 1,
                                              color: Colors.grey.shade700,
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
                                      color: const Color(0xFFFF0000),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= BARRA INFERIOR CON BOTONES =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Botón "A favoritos"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final favoritosProvider =
                            Provider.of<FavoritosProvider>(
                              context,
                              listen: false,
                            );
                        favoritosProvider.toggleFavorito(widget.producto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              favoritosProvider.esFavorito(widget.producto)
                                  ? 'Agregado a favoritos'
                                  : 'Eliminado de favoritos',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.grey.shade500,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Consumer<FavoritosProvider>(
                        builder: (context, favoritosProvider, child) {
                          final esFavorito = favoritosProvider.esFavorito(
                            widget.producto,
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                esFavorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color: esFavorito ? Colors.black : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                esFavorito ? 'En favoritos' : 'A favoritos',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botón "Al carrito"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final carritoProvider = Provider.of<CarritoProvider>(
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
                        carritoProvider.agregarProducto(productoCarrito);

                        // Mostrar mensaje de confirmación usando overlay
                        _mostrarMensajeConfirmacion(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 20),
                          const SizedBox(width: 4),
                          Text('Al carrito', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
