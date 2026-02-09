import 'package:flutter/material.dart';

class FavoritosProvider with ChangeNotifier {
  // Lista de productos favoritos
  List<Map<String, dynamic>> _productosFavoritos = [];

  // Getter para acceder a los favoritos
  List<Map<String, dynamic>> get productosFavoritos => _productosFavoritos;

  // Getter para saber si hay favoritos
  bool get tieneFavoritos => _productosFavoritos.isNotEmpty;

  // Método para verificar si un producto ya está en favoritos
  bool esFavorito(Map<String, dynamic> producto) {
    return _productosFavoritos.any((p) => p['titulo'] == producto['titulo']);
  }

  // Método para agregar un producto a favoritos
  void agregarFavorito(Map<String, dynamic> producto) {
    // Verificar si ya está en favoritos
    if (!esFavorito(producto)) {
      _productosFavoritos.add({...producto, 'esFavorito': true});
      notifyListeners();
    }
  }

  // Método para eliminar un producto de favoritos
  void eliminarFavorito(Map<String, dynamic> producto) {
    _productosFavoritos.removeWhere((p) => p['titulo'] == producto['titulo']);
    notifyListeners();
  }

  // Método para alternar favorito (agregar/eliminar)
  void toggleFavorito(Map<String, dynamic> producto) {
    if (esFavorito(producto)) {
      eliminarFavorito(producto);
    } else {
      agregarFavorito(producto);
    }
  }

  // Método para limpiar todos los favoritos
  void limpiarFavoritos() {
    _productosFavoritos.clear();
    notifyListeners();
  }
}
