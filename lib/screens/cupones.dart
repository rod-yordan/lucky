import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Cupones extends StatefulWidget {
  const Cupones({super.key});
  @override
  State<Cupones> createState() => _CuponesState();
}

class _CuponesState extends State<Cupones> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Cupones'
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: const [
                _CuponItem(
                  texto: 'Cupon con valor de S/ 20 de descuento en cualquier prenda de la tienda.',
                  diasVence: '7 d',
                ),
                _CuponItem(
                  texto: 'Cupon del 30% descuento en cualquier sudadera de la tienda.', 
                  diasVence: '30 d',
                ),
                _CuponItem(
                  texto: 'Cupon de S/50 valido para cualquier prenda femenina', 
                  diasVence: '10 d'
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CuponItem extends StatelessWidget {
  final String texto;
  final String diasVence;

  const _CuponItem({required this.texto, required this.diasVence});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de Ticket 
          const Icon(Icons.confirmation_num_outlined, color: Colors.black, size: 28),
          const SizedBox(width: 12),
          // Contenido del cupón
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF002D5E), 
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Etiqueta Roja de 
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Vence: $diasVence',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}