import 'package:flutter/material.dart';

class CarritoProvider with ChangeNotifier {
  // Lista de productos en el carrito
  List<Map<String, dynamic>> _productos = [];

  // Getter para acceder a los productos
  List<Map<String, dynamic>> get productos => _productos;

  // Getter para calcular el total
  double get total {
    return _productos.fold(0, (sum, producto) {
      final precio = producto['precio'] is int
          ? (producto['precio'] as int).toDouble()
          : producto['precio'] as double;
      final cantidad = producto['cantidad'] as int;
      return sum + (precio * cantidad);
    });
  }

  // Getter para la cantidad total de items
  int get cantidadTotal {
    return _productos.fold(
      0,
      (sum, producto) => sum + (producto['cantidad'] as int),
    );
  }

  // Método para agregar un producto al carrito
  void agregarProducto(Map<String, dynamic> producto) {
    // Verificar si el producto ya está en el carrito (mismo título, talla y color)
    final index = _productos.indexWhere(
      (p) =>
          p['titulo'] == producto['titulo'] &&
          p['talla'] == producto['talla'] &&
          p['color'] == producto['color'],
    );

    if (index != -1) {
      // Si ya existe, incrementar cantidad
      _productos[index]['cantidad'] =
          (_productos[index]['cantidad'] as int) + 1;
    } else {
      // Si no existe, agregarlo con cantidad 1
      _productos.add({...producto, 'cantidad': 1});
    }

    // Notificar a todos los widgets que están escuchando
    notifyListeners();
  }

  // Método para incrementar cantidad de un producto
  void incrementarCantidad(int index) {
    _productos[index]['cantidad'] = (_productos[index]['cantidad'] as int) + 1;
    notifyListeners();
  }

  // Método para decrementar cantidad de un producto
  void decrementarCantidad(int index) {
    final cantidadActual = _productos[index]['cantidad'] as int;
    if (cantidadActual > 1) {
      _productos[index]['cantidad'] = cantidadActual - 1;
    } else {
      // Si la cantidad es 1, eliminar el producto
      eliminarProducto(index);
      return;
    }
    notifyListeners();
  }

  // Método para eliminar un producto del carrito
  void eliminarProducto(int index) {
    _productos.removeAt(index);
    notifyListeners();
  }

  // Método para limpiar todo el carrito
  void limpiarCarrito() {
    _productos.clear();
    notifyListeners();
  }
}
