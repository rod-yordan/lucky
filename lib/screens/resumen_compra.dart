import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';
import 'package:lucky/services/checkout_service.dart';

class ResumenCompra extends StatefulWidget {
  final Map<String, dynamic> data;

  const ResumenCompra({super.key, required this.data});

  @override
  State<ResumenCompra> createState() => _ResumenCompraState();
}

class _ResumenCompraState extends State<ResumenCompra> {
  final CheckoutService _checkoutService = CheckoutService();
  bool _procesando = false;

  double _calcularCostoEnvio() {
    // Por ahora no lo sumamos hasta integrarlo con backend
    return 0.0;
  }

  Future<void> _confirmarPedido() async {
    if (_procesando) return;

    setState(() {
      _procesando = true;
    });

    try {
      final data = widget.data;

      final response = await _checkoutService.confirmarCheckout(
        idTipoDocumento: data['idTipoDocumento'],
        numeroDocumento: data['numeroDocumento'],
        telefono: data['telefono'],
        idTipoEntrega: data['idTipoEntrega'],
        idDistrito: data['idTipoEntrega'] == 2 ? data['idDistrito'] : null,
      );

      if (!mounted) return;

      await Provider.of<CarritoProvider>(
        context,
        listen: false,
      ).cargarCarrito(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido realizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );

      context.go(
        '/pedido-completado',
        extra: {
          'numeroPedido': response['numero_pedido'],
          'totalPedido': response['total_pedido'],
          'estadoPedido': response['estado_pedido'],
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _procesando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final productos = carritoProvider.productos;

    final nombreUsuario = widget.data['nombreUsuario'] ?? 'Usuario';
    final numeroDocumento = widget.data['numeroDocumento'] ?? '-';
    final idTipoEntrega = widget.data['idTipoEntrega'] as int?;
    final distritoNombre = widget.data['distritoNombre'];

    final subtotal = carritoProvider.total;
    final costoEnvio = _calcularCostoEnvio();
    final totalFinal = subtotal + costoEnvio;

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
                              context.go('/');
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Resumen de compra',
                          style: TextStyle(
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

            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos del comprador',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _infoCard(
                        children: [
                          _infoRow('Nombre', nombreUsuario.toString()),
                          const SizedBox(height: 14),
                          _infoRow('Documento', numeroDocumento.toString()),
                          const SizedBox(height: 14),
                          _infoRow(
                            'Entrega',
                            idTipoEntrega == 1
                                ? 'Retiro en tienda'
                                : 'Envío a provincia',
                          ),
                          if (idTipoEntrega == 2 && distritoNombre != null) ...[
                            const SizedBox(height: 14),
                            _infoRow('Distrito', distritoNombre.toString()),
                          ],
                        ],
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (productos.isEmpty)
                        _infoCard(
                          children: const [
                            Text(
                              'No hay productos en el carrito.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      else
                        ...productos.map((producto) {
                          final nombre =
                              producto['nombre_producto'] ??
                              producto['nombre'] ??
                              'Producto';

                          final cantidad =
                              int.tryParse(
                                (producto['cantidad'] ?? 1).toString(),
                              ) ??
                              1;

                          final precio =
                              double.tryParse(
                                (producto['precio'] ??
                                        producto['precio_unitario'] ??
                                        0)
                                    .toString(),
                              ) ??
                              0.0;

                          final subtotalProducto = precio * cantidad;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _productoCard(
                              nombre: nombre.toString(),
                              cantidad: cantidad,
                              precio: precio,
                              subtotal: subtotalProducto,
                            ),
                          );
                        }),

                      const SizedBox(height: 28),

                      const Text(
                        'Resumen de pago',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _infoCard(
                        children: [
                          _resumenRow('Subtotal', subtotal),
                          const SizedBox(height: 14),
                          _resumenRow('Costo de envío', costoEnvio),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(height: 1),
                          ),
                          _resumenRow('Total', totalFinal, destacado: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total a pagar:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'S/ ${totalFinal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _procesando ? null : _confirmarPedido,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _procesando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Confirmar pedido',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
      ),
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _productoCard({
    required String nombre,
    required int cantidad,
    required double precio,
    required double subtotal,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombre,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            'Cantidad: $cantidad',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'Precio: S/ ${precio.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            'Subtotal: S/ ${subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _resumenRow(String label, double valor, {bool destacado = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: destacado ? 16 : 14,
            fontWeight: destacado ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          'S/ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: destacado ? 18 : 14,
            fontWeight: destacado ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
