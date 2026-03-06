// catalogo_part1.dart
import 'package:flutter/material.dart';
import 'package:lucky/screens/categoria_card.dart';

class CatalogoParte1 extends StatelessWidget {
  const CatalogoParte1({super.key});

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
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Catálogo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: [
                      CategoriaCard(
                        titulo: 'Hombre',
                        imagenPath: 'assets/catalogo_hombre.jpg',
                        onTap: () {
                          print('Navegar a categorías de Hombre');
                        },
                      ),
                      CategoriaCard(
                        titulo: 'Mujer',
                        imagenPath: 'assets/catalogo_mujer.jpg',
                        onTap: () {
                          print('Navegar a categorías de Mujer');
                        },
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
