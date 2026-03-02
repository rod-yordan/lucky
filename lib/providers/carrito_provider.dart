// providers/carrito_provider.dart
import 'package:flutter/material.dart';
import 'package:lucky/models/carrito_model.dart';
import 'package:lucky/services/carrito_service.dart';
import 'package:lucky/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CarritoProvider with ChangeNotifier {
  // === SERVICIO ===
  final CarritoService _service = CarritoService();

  // === ESTADO CON MODELOS ===
  CarritoModel? _carrito;
  bool _isLoading = false;
  String? _error;

  // === GETTERS PARA UI ===
  CarritoModel? get carrito => _carrito;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // === COMPATIBILIDAD CON UI ACTUAL (usando Map) ===
  List<Map<String, dynamic>> get productos {
    if (_carrito == null) return [];
    return _carrito!.items.map((item) => item.toMap()).toList();
  }

  double get total => _carrito?.total ?? 0;

  int get cantidadTotal => _carrito?.cantidadTotal ?? 0;

  // ==================== CARGAR CARRITO ====================
  Future<void> cargarCarrito(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      _carrito = null;
      notifyListeners();
      return;
    }

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) {
      print('🔴 ID de usuario inválido: $idUsuario');
      _error = 'Usuario inválido';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🟡 Cargando carrito para usuario: $idUsuario');
      _carrito = await _service.obtenerCarrito(idUsuario);
      print('✅ Carrito cargado: ${_carrito?.items.length} items');
    } catch (e) {
      print('🔴 Error cargando carrito: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== AGREGAR PRODUCTO ====================
  Future<void> agregarProducto(
    BuildContext context,
    Map<String, dynamic> productoMap,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      print('🔴 Usuario no logueado');
      _error = 'Debes iniciar sesión para agregar al carrito';
      notifyListeners();
      return;
    }

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) {
      print('🔴 ID de usuario inválido: $idUsuario');
      _error = 'Usuario inválido';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final idVariante = productoMap['id_variante'];

      if (idVariante == null) {
        throw Exception('Error: El producto no tiene ID de variante');
      }

      print(
        '🟡 Agregando producto - Usuario: $idUsuario, Variante: $idVariante',
      );

      _carrito = await _service.agregarProducto(
        idUsuario: idUsuario,
        idVariante: idVariante,
        cantidad: productoMap['cantidad'] ?? 1,
      );

      print('🟡 Items en carrito AHORA: ${_carrito?.items.length}');
      print('✅ Producto agregado correctamente');
      _error = null;
    } catch (e) {
      print('🔴 Error agregando producto: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== INCREMENTAR CANTIDAD ====================
  Future<void> incrementarCantidad(BuildContext context, int index) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn || _carrito == null) return;

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) return;

    final item = _carrito!.items[index];

    try {
      print('🟡 Incrementando cantidad: ${item.idDetalle}');
      _carrito = await _service.actualizarCantidad(
        idUsuario: idUsuario,
        idDetalleCarrito: item.idDetalle,
        cantidad: item.cantidad + 1,
      );
      notifyListeners();
    } catch (e) {
      print('🔴 Error incrementando: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==================== DECREMENTAR CANTIDAD ====================
  Future<void> decrementarCantidad(BuildContext context, int index) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn || _carrito == null) return;

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) return;

    final item = _carrito!.items[index];
    if (item.cantidad <= 1) return;

    try {
      print('🟡 Decrementando cantidad: ${item.idDetalle}');
      _carrito = await _service.actualizarCantidad(
        idUsuario: idUsuario,
        idDetalleCarrito: item.idDetalle,
        cantidad: item.cantidad - 1,
      );
      notifyListeners();
    } catch (e) {
      print('🔴 Error decrementando: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==================== ELIMINAR PRODUCTO ====================
  Future<void> eliminarProducto(BuildContext context, int index) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn || _carrito == null) return;

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) return;

    final item = _carrito!.items[index];

    try {
      print('🟡 Eliminando producto: ${item.idDetalle}');
      _carrito = await _service.eliminarProducto(
        idUsuario: idUsuario,
        idDetalleCarrito: item.idDetalle,
      );
      notifyListeners();
    } catch (e) {
      print('🔴 Error eliminando: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==================== LIMPIAR CARRITO ====================
  Future<void> limpiarCarrito(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn || _carrito == null) return;

    final idUsuario = authProvider.usuario!.id;
    if (idUsuario <= 0) return;

    try {
      print('🟡 Limpiando carrito');
      await _service.limpiarCarrito(idUsuario);
      _carrito = null;
      notifyListeners();
    } catch (e) {
      print('🔴 Error limpiando: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==================== CERRAR SESIÓN ====================
  void cerrarSesion() {
    _carrito = null;
    _error = null;
    notifyListeners();
  }
}
