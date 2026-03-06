// screens/catalogo_parte2.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/screens/categoria_card.dart';

class CatalogoParte2 extends StatelessWidget {
  final String genero;
  final int? generoId;

  const CatalogoParte2({super.key, required this.genero, this.generoId});

  // Lista de categorías disponibles
  final List<Map<String, dynamic>> _categorias = const [
    {'titulo': 'Pantalones', 'imagen': 'assets/categoria_pantalones.jpg'},
    {'titulo': 'Casacas', 'imagen': 'assets/categoria_casacas.jpg'},
    {'titulo': 'Camisas', 'imagen': 'assets/categoria_camisas.jpg'},
    {'titulo': 'Polos', 'imagen': 'assets/categoria_polos.jpg'},
    {'titulo': 'Ropa deportiva', 'imagen': 'assets/categoria_deportiva.jpg'},
  ];

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
                        Text(
                          genero,
                          style: const TextStyle(
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

            // ================= CONTENIDO PRINCIPAL =================
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grid de categorías usando CategoriaCard
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: _categorias.length,
                          itemBuilder: (context, index) {
                            final categoria = _categorias[index];
                            return CategoriaCard(
                              titulo: categoria['titulo'],
                              imagenPath: categoria['imagen'],
                              onTap: () {
                                print(
                                  'Navegar a ${categoria['titulo']} de $genero',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Categoría: ${categoria['titulo']} de $genero',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                // Aquí luego irá la navegación a la siguiente pantalla
                                // context.push('/productos-por-categoria', extra: {
                                //   'genero': genero,
                                //   'generoId': generoId,
                                //   'categoria': categoria['titulo'],
                                // });
                              },
                            );
                          },
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
}
