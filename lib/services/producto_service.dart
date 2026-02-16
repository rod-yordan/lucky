import 'package:dio/dio.dart';
import 'package:lucky/models/producto_model.dart';
import 'package:lucky/utils/dio_client.dart';

class ProductoService {
  final Dio _dio = DioClient.dio;
  static int paginaActual = 0;
  static bool tieneMasPaginas = true;
  static int totalProductos = 0;

  // Obtener productos con paginación
  Future<List<ProductoModel>> getProductos({
    int page = 0,
    int limit = 10,
    String? categoria,
    String? genero,
    String? busqueda,
    String? orden = 'created_at',
    String? direccion = 'desc',
  }) async {
    try {
      // Construir query parameters
      Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
        'orden': orden,
        'direccion': direccion,
      };

      if (categoria != null && categoria.isNotEmpty) {
        queryParams['categoria'] = categoria;
      }

      if (genero != null && genero.isNotEmpty) {
        queryParams['genero'] = genero;
      }

      if (busqueda != null && busqueda.isNotEmpty) {
        queryParams['busqueda'] = busqueda;
      }

      final response = await _dio.get(
        '/productos',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<ProductoModel> productos = [];

        if (response.data['data'] != null) {
          final List<dynamic> lista = response.data['data'];
          productos.addAll(lista.map((e) => ProductoModel.fromJson(e)));

          // Actualizar estado de paginación
          paginaActual = response.data['current_page'] ?? page;
          totalProductos = response.data['total'] ?? 0;
          tieneMasPaginas =
              (response.data['current_page'] ?? 0) <
              (response.data['last_page'] ?? 0);
        }

        return productos;
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error al cargar los productos: $e');
    }
  }

  // Obtener un producto por ID
  Future<ProductoModel> getProductoById(int id) async {
    try {
      final response = await _dio.get('/productos/$id');

      if (response.data['success'] == true && response.data['data'] != null) {
        return ProductoModel.fromJson(response.data['data']);
      }

      throw Exception('Producto no encontrado');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener productos recomendados
  Future<List<ProductoModel>> getProductosRecomendados({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/productos/recomendados',
        queryParameters: {'limit': limit},
      );

      if (response.data['success'] == true) {
        final List<dynamic> lista = response.data['data'] ?? [];
        return lista.map((e) => ProductoModel.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener productos populares
  Future<List<ProductoModel>> getProductosPopulares({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/productos/populares',
        queryParameters: {'limit': limit},
      );

      if (response.data['success'] == true) {
        final List<dynamic> lista = response.data['data'] ?? [];
        return lista.map((e) => ProductoModel.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener productos en oferta
  Future<List<ProductoModel>> getProductosEnOferta({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/productos/ofertas',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.data['success'] == true) {
        final List<ProductoModel> productos = [];

        if (response.data['data'] != null) {
          final List<dynamic> lista = response.data['data'];
          productos.addAll(lista.map((e) => ProductoModel.fromJson(e)));
        }

        return productos;
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Buscar productos
  Future<List<ProductoModel>> buscarProductos(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/productos/buscar',
        queryParameters: {'q': query, 'page': page, 'limit': limit},
      );

      if (response.data['success'] == true) {
        final List<ProductoModel> productos = [];

        if (response.data['data'] != null) {
          final List<dynamic> lista = response.data['data'];
          productos.addAll(lista.map((e) => ProductoModel.fromJson(e)));
        }

        return productos;
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Resetear paginación
  static void resetPaginacion() {
    paginaActual = 0;
    tieneMasPaginas = true;
    totalProductos = 0;
  }

  // Manejo de errores
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de recepción agotado';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 404) {
          return 'Producto no encontrado';
        } else if (error.response?.statusCode == 422) {
          return 'Datos inválidos';
        } else if (error.response?.statusCode == 500) {
          return 'Error en el servidor';
        }
        return 'Error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Petición cancelada';
      default:
        return 'Error de conexión: ${error.message}';
    }
  }
}
