// services/carrito_service.dart
import 'package:dio/dio.dart';
import 'package:lucky/models/carrito_model.dart';
import 'package:lucky/utils/dio_client.dart';

class CarritoService {
  final Dio _dio = ApiClient.dio;

  // ==================== OBTENER CARRITO ====================
  Future<CarritoModel> obtenerCarrito(int idUsuario) async {
    try {
      print('🔵 Obteniendo carrito para usuario: $idUsuario');
      final response = await _dio.get(
        '/carrito',
        queryParameters: {'id_usuario': idUsuario},
      );

      print('📥 Respuesta obtenerCarrito: ${response.data}');

      if (response.data['success'] == true && response.data['data'] != null) {
        final carrito = CarritoModel.fromJson(response.data['data']);
        print('🟡 Items obtenidos: ${carrito.items.length}');
        return carrito;
      }

      // Si no hay carrito, crear uno nuevo
      print('🟡 No hay carrito, creando uno nuevo...');
      return await crearCarrito(idUsuario);
    } on DioException catch (e) {
      print('🔴 Error obtenerCarrito: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== CREAR CARRITO ====================
  Future<CarritoModel> crearCarrito(int idUsuario) async {
    try {
      print('🔵 Creando carrito para usuario: $idUsuario');
      final response = await _dio.post(
        '/carrito/crear',
        data: {'id_usuario': idUsuario},
      );

      print('📥 Respuesta crearCarrito: ${response.data}');

      if (response.data['success'] == true && response.data['data'] != null) {
        final carrito = CarritoModel.fromJson(response.data['data']);
        print('🟡 Carrito creado - Items: ${carrito.items.length}');
        return carrito;
      }

      throw Exception('No se pudo crear el carrito');
    } on DioException catch (e) {
      print('🔴 Error DIO completo:');
      print('   Status code: ${e.response?.statusCode}');
      print('   Data: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== AGREGAR PRODUCTO ====================
  Future<CarritoModel> agregarProducto({
    required int idUsuario,
    required int idVariante,
    int cantidad = 1,
  }) async {
    print('🔵 Intentando agregar producto:');
    print('   idUsuario: $idUsuario');
    print('   idVariante: $idVariante');
    print('   cantidad: $cantidad');

    try {
      final response = await _dio.post(
        '/carrito/agregar',
        data: {
          'id_usuario': idUsuario,
          'id_variante': idVariante,
          'cantidad': cantidad,
        },
      );

      print('📥 Respuesta del servidor: ${response.data}');

      if (response.data['success'] == true && response.data['data'] != null) {
        final carrito = CarritoModel.fromJson(response.data['data']);
        print('🟡 Items recibidos del backend: ${carrito.items.length}');
        return carrito;
      }

      throw Exception(response.data['message'] ?? 'Error al agregar producto');
    } on DioException catch (e) {
      print('❌ Error Dio: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== ACTUALIZAR CANTIDAD ====================
  Future<CarritoModel> actualizarCantidad({
    required int idUsuario,
    required int idDetalleCarrito,
    required int cantidad,
  }) async {
    print('🔵 Actualizando cantidad:');
    print('   idUsuario: $idUsuario');
    print('   idDetalleCarrito: $idDetalleCarrito');
    print('   nueva cantidad: $cantidad');

    try {
      final response = await _dio.put(
        '/carrito/actualizar',
        data: {
          'id_usuario': idUsuario,
          'id_detalle_carrito': idDetalleCarrito,
          'cantidad': cantidad,
        },
      );

      print('📥 Respuesta actualizarCantidad: ${response.data}');

      if (response.data['success'] == true && response.data['data'] != null) {
        final carrito = CarritoModel.fromJson(response.data['data']);
        print('✅ Cantidad actualizada - Items: ${carrito.items.length}');
        return carrito;
      }

      throw Exception(
        response.data['message'] ?? 'Error al actualizar cantidad',
      );
    } on DioException catch (e) {
      print('❌ Error actualizarCantidad: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== ELIMINAR PRODUCTO ====================
  Future<CarritoModel> eliminarProducto({
    required int idUsuario,
    required int idDetalleCarrito,
  }) async {
    print('🔵 Eliminando producto:');
    print('   idUsuario: $idUsuario');
    print('   idDetalleCarrito: $idDetalleCarrito');

    try {
      final response = await _dio.delete(
        '/carrito/eliminar',
        data: {'id_usuario': idUsuario, 'id_detalle_carrito': idDetalleCarrito},
      );

      print('📥 Respuesta eliminarProducto: ${response.data}');

      if (response.data['success'] == true && response.data['data'] != null) {
        final carrito = CarritoModel.fromJson(response.data['data']);
        print('✅ Producto eliminado - Items: ${carrito.items.length}');
        return carrito;
      }

      throw Exception(response.data['message'] ?? 'Error al eliminar producto');
    } on DioException catch (e) {
      print('❌ Error eliminarProducto: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== LIMPIAR CARRITO ====================
  Future<bool> limpiarCarrito(int idUsuario) async {
    print('🔵 Limpiando carrito para usuario: $idUsuario');

    try {
      final response = await _dio.delete(
        '/carrito/limpiar',
        data: {'id_usuario': idUsuario},
      );

      print('📥 Respuesta limpiarCarrito: ${response.data}');
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('❌ Error limpiarCarrito: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== VERIFICAR STOCK ====================
  Future<bool> verificarStock(int idVariante, int cantidad) async {
    print('🔵 Verificando stock:');
    print('   idVariante: $idVariante');
    print('   cantidad: $cantidad');

    try {
      final response = await _dio.get(
        '/variantes/$idVariante/verificar-stock',
        queryParameters: {'cantidad': cantidad},
      );

      print('📥 Respuesta verificarStock: ${response.data}');
      return response.data['disponible'] ?? false;
    } on DioException catch (e) {
      print('❌ Error verificarStock: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== OBTENER TOTAL ====================
  Future<double> obtenerTotal(int idCarrito) async {
    print('🔵 Obteniendo total para carrito: $idCarrito');

    try {
      final response = await _dio.get('/carrito/$idCarrito/total');
      print('📥 Respuesta obtenerTotal: ${response.data}');
      return (response.data['total'] ?? 0).toDouble();
    } on DioException catch (e) {
      print('❌ Error obtenerTotal: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // ==================== MANEJO DE ERRORES SIMPLE ====================
  String _handleError(DioException error) {
    if (error.response != null) {
      if (error.response?.data != null &&
          error.response?.data['message'] != null) {
        return error.response?.data['message'];
      }
      return 'Error ${error.response?.statusCode}';
    }
    return 'Error de conexión: ${error.message}';
  }
}
