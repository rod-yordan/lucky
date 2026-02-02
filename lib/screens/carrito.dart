import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        const SizedBox(width: 8),
                        const Text(
                          'Carrito',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
              child: Consumer<CarritoProvider>(
                builder: (context, carritoProvider, child) {
                  final productos = carritoProvider.productos;
                  final total = carritoProvider.total;

                  if (productos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tu carrito está vacío',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega productos para continuar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.go('/');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFED1C24),
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
                    child: Column(
                      children: [
                        // Lista de productos
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: productos.length,
                            itemBuilder: (context, index) {
                              final producto = productos[index];
                              return _itemCarrito(
                                producto,
                                index,
                                carritoProvider,
                              );
                            },
                          ),
                        ),

                        // Sección de total y botón de compra
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors
                                    .black12, // <-- MISMA línea que la barra superior
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'S/ ${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Botón continuar compra
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Lógica para continuar con la compra
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Procediendo al pago...'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Continuar con la compra',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _itemCarrito(
    Map<String, dynamic> producto,
    int index,
    CarritoProvider carritoProvider,
  ) {
    // Obtener la primera imagen del array
    final List<String> imagenes = producto['imagenes'] != null
        ? List<String>.from(producto['imagenes'])
        : [];
    final String imagenPrincipal = imagenes.isNotEmpty ? imagenes[0] : '';

    // Obtener datos del producto
    final String titulo = producto['titulo'] ?? '';
    final double precio = producto['precio'] is int
        ? (producto['precio'] as int).toDouble()
        : producto['precio'] as double;
    final int cantidad = producto['cantidad'] as int;
    final String talla = producto['talla'] ?? '';
    final String color = producto['color'] ?? '';
    final double? precioAntes = producto['precioAntes'] != null
        ? (producto['precioAntes'] is int
              ? (producto['precioAntes'] as int).toDouble()
              : producto['precioAntes'] as double)
        : null;
    final int? descuento = producto['descuento'] as int?;

    // Función para obtener el color
    Color _getColorCodigo(String nombreColor) {
      switch (nombreColor) {
        case 'Azul':
          return const Color(0xFF1E3A8A);
        case 'Negro':
          return Colors.black;
        case 'Gris':
          return const Color(0xFF6B7280);
        case 'Blanco':
          return Colors.white;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagenPrincipal.isNotEmpty
                  ? Image.asset(
                      imagenPrincipal,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 100,
                    )
                  : Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Color y talla
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColorCodigo(color),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      color,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Talla: $talla',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Precio y cantidad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'S/ ${precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFED1C24),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (precioAntes != null)
                          Text(
                            'S/ ${precioAntes.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (descuento != null && descuento > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFED1C24),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-$descuento%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Selector de cantidad
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          // Botón menos
                          IconButton(
                            onPressed: () =>
                                carritoProvider.decrementarCantidad(index),
                            icon: const Icon(Icons.remove, size: 16),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            cantidad.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Botón más
                          IconButton(
                            onPressed: () =>
                                carritoProvider.incrementarCantidad(index),
                            icon: const Icon(Icons.add, size: 16),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Botón eliminar
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      carritoProvider.eliminarProducto(index);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
