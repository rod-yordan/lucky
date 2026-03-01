import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/models/genero_model.dart';
import 'package:lucky/models/producto_model.dart';
import 'package:lucky/screens/producto_card.dart';
import 'package:lucky/services/genero_service.dart';
import 'package:lucky/services/producto_service.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final PageController _pageController = PageController();
  int _paginaActual = 0;

  final List<String> banners = ['assets/banner1.png', 'assets/banner2.png'];

  // Servicios
  final ProductoService _productoService = ProductoService();
  final GeneroService _generoService = GeneroService();

  // Futures para cargar datos
  late Future<List<ProductoModel>> _recomendadosFuture;
  late Future<List<ProductoModel>> _popularesFuture;
  late Future<List<GeneroModel>> _generosFuture;

  // Listas para almacenar los productos cargados
  List<ProductoModel> _recomendados = [];
  List<ProductoModel> _populares = [];
  List<GeneroModel> _generos = [];
  int? _generoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _cargarGeneros();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Iniciar autoScroll después de que la vista esté construida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _autoScroll();
      }
    });
  }

  void _cargarProductos() {
    // Cargar productos recomendados
    _recomendadosFuture = _productoService
        .getProductosRecomendados(limit: 10)
        .then((productos) {
          if (mounted) {
            setState(() {
              _recomendados = productos;
            });
          }
          return productos;
        });

    // Cargar productos populares
    _popularesFuture = _productoService.getProductosPopulares(limit: 10).then((
      productos,
    ) {
      if (mounted) {
        setState(() {
          _populares = productos;
        });
      }
      return productos;
    });
  }

  // Cargar géneros desde la API
  void _cargarGeneros() {
    _generosFuture = _generoService
        .getGeneros()
        .then((generos) {
          if (mounted) {
            setState(() {
              _generos = generos;
            });
          }
          return generos;
        })
        .catchError((error) {
          print('Error cargando géneros: $error');
          return <GeneroModel>[];
        });
  }

  // Método para refrescar los productos (pull to refresh)
  Future<void> _refrescarProductos() async {
    ProductoService.resetPaginacion();
    await Future.wait([
      _productoService.getProductosRecomendados(limit: 10).then((productos) {
        if (mounted) {
          setState(() {
            _recomendados = productos;
          });
        }
      }),
      _productoService.getProductosPopulares(limit: 10).then((productos) {
        if (mounted) {
          setState(() {
            _populares = productos;
          });
        }
      }),
      _generoService.getGeneros().then((generos) {
        if (mounted) {
          setState(() {
            _generos = generos;
          });
        }
      }),
    ]);
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;

      // Verificar que el PageController está attached
      if (_pageController.hasClients) {
        _paginaActual = (_paginaActual + 1) % banners.length;
        _pageController.animateToPage(
          _paginaActual,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(height: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _barraSuperior(),
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.black12),
                ],
              ),
            ),

            // ================= CONTENIDO =================
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: RefreshIndicator(
                  onRefresh: _refrescarProductos,
                  color: const Color(0xFFED1C24),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _generosList(),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),

                      _bannerCarrusel(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Sección de productos recomendados
                            _buildSeccionProductos(
                              titulo: 'Recomendado',
                              future: _recomendadosFuture,
                              productos: _recomendados,
                            ),

                            // Sección de productos populares
                            _buildSeccionProductos(
                              titulo: 'Más populares',
                              future: _popularesFuture,
                              productos: _populares,
                            ),

                            const SizedBox(height: 24),
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

  Widget _barraSuperior() {
    return Consumer<CarritoProvider>(
      builder: (context, carritoProvider, child) {
        final cantidadTotal = carritoProvider.cantidadTotal;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/logo.jpg', height: 45),
                Stack(
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
                            cantidadTotal > 9 ? '9+' : cantidadTotal.toString(),
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
                ),
              ],
            ),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                context.go('/busqueda');
              },
              child: Container(
                width: double.infinity,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Buscar productos...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _generosList() {
    return FutureBuilder<List<GeneroModel>>(
      future: _generosFuture,
      builder: (context, snapshot) {
        // Mientras carga
        if (snapshot.connectionState == ConnectionState.waiting &&
            _generos.isEmpty) {
          return _generosSkeleton();
        }

        // Mostrar géneros
        return _generosChips();
      },
    );
  }

  // Skeleton para géneros (mientras carga)
  Widget _generosSkeleton() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  // Chips de géneros desde la API
  Widget _generosChips() {
    // Agregamos "Todo" al inicio de la lista
    final List<dynamic> items = [
      {'id': null, 'nombre': 'Todo'},
      ..._generos,
      {'id': null, 'nombre': 'Promociones'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final int? id = item is GeneroModel ? item.idGenero : item['id'];
          final String nombre = item is GeneroModel
              ? item.nombreGenero
              : item['nombre'];
          final seleccionado = _generoSeleccionado == id;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(nombre),
              selected: seleccionado,
              onSelected: (selected) {
                setState(() {
                  _generoSeleccionado = selected ? id : null;
                });

                if (nombre == 'Promociones') {
                  context.go('/catalogo', extra: {'en_oferta': true});
                } else if (id != null) {
                  context.go('/catalogo', extra: {'genero_id': id});
                } else {
                  // "Todo"
                  context.go('/catalogo');
                }
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFED1C24).withAlpha(30),
              checkmarkColor: const Color(0xFFED1C24),
              labelStyle: TextStyle(
                color: seleccionado ? const Color(0xFFED1C24) : Colors.black,
                fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: seleccionado
                      ? const Color(0xFFED1C24)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= BANNER =================
  Widget _bannerCarrusel() {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _paginaActual = i),
            itemBuilder: (_, i) {
              return Image.asset(
                banners[i],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
          // Indicadores
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }

  // ================= SECCIÓN DE PRODUCTOS CON FUTUREBUILDER =================
  Widget _buildSeccionProductos({
    required String titulo,
    required Future<List<ProductoModel>> future,
    required List<ProductoModel> productos,
  }) {
    return FutureBuilder<List<ProductoModel>>(
      future: future,
      builder: (context, snapshot) {
        // Mientras carga
        if (snapshot.connectionState == ConnectionState.waiting &&
            productos.isEmpty) {
          return _buildSeccionCargando(titulo);
        }

        // Si hay error
        if (snapshot.hasError) {
          print('Error cargando $titulo: ${snapshot.error}');
          return _buildSeccionError(titulo);
        }

        // Si no hay productos
        if (productos.isEmpty) {
          return _buildSeccionVacia(titulo);
        }

        // Mostrar productos
        return _seccionProductos(
          titulo: titulo,
          productos: productos.map((p) => p.toMap()).toList(),
        );
      },
    );
  }

  // ================= SECCIÓN CARGANDO =================
  Widget _buildSeccionCargando(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Ver todo', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        SizedBox(
          height: 330,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Mostrar 3 skeletons
            itemBuilder: (context, index) {
              return _buildProductoSkeleton();
            },
          ),
        ),
      ],
    );
  }

  // ================= SKELETON PARA PRODUCTO =================
  Widget _buildProductoSkeleton() {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                Container(height: 16, width: 100, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(height: 16, width: 80, color: Colors.grey.shade300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECCIÓN ERROR =================
  Widget _buildSeccionError(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error al cargar productos',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cargarProductos();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED1C24),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= SECCIÓN VACÍA =================
  Widget _buildSeccionVacia(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'No hay productos disponibles',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= SECCIÓN REUTILIZABLE (MANTENIENDO TU CÓDIGO ORIGINAL) =================
  Widget _seccionProductos({
    required String titulo,
    required List<Map<String, dynamic>> productos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a la lista completa según la sección
                  if (titulo == 'Recomendado') {
                    context.go('/catalogo', extra: {'recomendados': true});
                  } else {
                    context.go('/catalogo', extra: {'populares': true});
                  }
                },
                child: const Text(
                  'Ver todo',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        _listaProductos(productos),
      ],
    );
  }

  // ================= LISTA PRODUCTOS (MANTENIENDO TU CÓDIGO ORIGINAL) =================
  Widget _listaProductos(List<Map<String, dynamic>> lista) {
    return SizedBox(
      height: 330,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lista.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) => _productoCard(lista[i]),
      ),
    );
  }

  // ================= CARD PRODUCTO (MANTENIENDO TU CÓDIGO ORIGINAL) =================
  Widget _productoCard(Map<String, dynamic> p) {
    return ProductoCard(
      producto: p,
      onTap: () {
        context.go('/detallesProducto', extra: p);
      },
      mostrarCorazon: false, // No mostrar corazón en página principal
    );
  }
}
