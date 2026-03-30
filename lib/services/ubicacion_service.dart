import 'package:dio/dio.dart';
import 'package:lucky/models/ubicacion_item.dart';
import 'package:lucky/utils/dio_client.dart';

class UbicacionService {
  final Dio _dio = ApiClient.dio;

  Future<List<UbicacionItem>> obtenerTiposDocumento() async {
    try {
      final response = await _dio.get('/ubicaciones/tipos-documento');

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => UbicacionItem.fromJson(e)).toList();
      }

      throw Exception('No se pudieron cargar los tipos de documento');
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<UbicacionItem>> obtenerDepartamentos() async {
    try {
      final response = await _dio.get('/ubicaciones/departamentos');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => UbicacionItem.fromJson(e)).toList();
      }

      throw Exception('No se pudieron cargar los departamentos');
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<UbicacionItem>> obtenerProvincias(int idDepartamento) async {
    try {
      final response = await _dio.get(
        '/ubicaciones/provincias/$idDepartamento',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => UbicacionItem.fromJson(e)).toList();
      }

      throw Exception('No se pudieron cargar las provincias');
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<UbicacionItem>> obtenerDistritos(int idProvincia) async {
    try {
      final response = await _dio.get('/ubicaciones/distritos/$idProvincia');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((e) => UbicacionItem.fromJson(e)).toList();
      }

      throw Exception('No se pudieron cargar los distritos');
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      return 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
    }

    return 'Error de conexión: ${e.message}';
  }
}
