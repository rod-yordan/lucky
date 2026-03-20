import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/producto_card.dart';
import 'package:lucky/services/producto_service.dart';
import 'package:lucky/models/producto_model.dart';
import 'package:dio/dio.dart';

class CatalogoParte3 extends StatefulWidget {
  final String categoria;
  final int? categoriaId;
  final String genero;
  final int? generoId;

  const CatalogoParte3({
    super.key,
    required this.categoria,
    required this.categoriaId,
    required this.genero,
    this.generoId,
  });

  @override
  State<CatalogoParte3> createState() => _CatalogoParte3State();
}

class _CatalogoParte3State extends State<CatalogoParte3> {
  final ProductoService _productoService = ProductoService();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api'));

  List<ProductoModel> _productos = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('🎯 ENTRE A initState DE CatalogoParte3');
    print('   categoria: ${widget.categoria}');
    print('   categoriaId: ${widget.categoriaId}');
    print('   genero: ${widget.genero}');
    print('   generoId: ${widget.generoId}');
    _cargarProductos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _cargarProductos();
      }
    }
  }

  Future<void> _cargarProductos() async {
    if (_isLoading) return;

    print('🟡 Iniciando _cargarProductos');
    print('   _isLoading: $_isLoading');
    print('   _currentPage: $_currentPage');

    setState(() {
      _isLoading = true;
    });

    try {
      final url = '/productos';
      final params = {
        'page': _currentPage,
        'limit': 10,
        'categoria': widget.categoriaId,
        'genero': widget.generoId,
      };

      print('🔵 URL: $url');
      print('🔵 Parámetros: $params');

      final response = await _dio.get(url, queryParameters: params);

      print('🔵 Status code: ${response.statusCode}');
      print('🔵 Respuesta completa: ${response.data}');

      if (response.data['success'] == true) {
        final List<dynamic> lista = response.data['data'] ?? [];
        print('✅ Productos encontrados: ${lista.length}');

        if (lista.isNotEmpty) {
          for (var item in lista) {
            print('   - ${item['titulo']}');
          }
        }

        final nuevosProductos = lista
            .map((e) => ProductoModel.fromJson(e))
            .toList();

        setState(() {
          if (nuevosProductos.isNotEmpty) {
            _productos.addAll(nuevosProductos);
            _currentPage++;
            _hasMore = nuevosProductos.length == 10;
          } else {
            _hasMore = false;
          }
          _isLoading = false;
        });
      } else {
        print('❌ Error en respuesta: ${response.data}');
        setState(() {
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      print('🔴 DioException: ${e.message}');
      print('🔴 Response: ${e.response?.data}');
      print('🔴 Status: ${e.response?.statusCode}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('🔴 Error general: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refrescar() async {
    setState(() {
      _productos.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    await _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/catalogo');
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.categoria,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.genero,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refrescar,
                color: const Color(0xFFED1C24),
                child: _isLoading && _productos.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFED1C24),
                        ),
                      )
                    : _productos.isEmpty
                    ? _emptyState()
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 170 / 320,
                            ),
                        itemCount: _productos.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _productos.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFED1C24),
                                ),
                              ),
                            );
                          }
                          final producto = _productos[index];
                          return ProductoCard(
                            producto: producto.toMap(),
                            onTap: () {
                              context.push(
                                '/detallesProducto',
                                extra: producto.toMap(),
                              );
                            },
                            mostrarCorazon: true,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay productos en esta categoría',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Pronto tendremos más productos para ti',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
