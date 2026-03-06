// screens/informacion_compra.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';

class InformacionCompra extends StatefulWidget {
  const InformacionCompra({super.key});

  @override
  State<InformacionCompra> createState() => _InformacionCompraState();
}

class _InformacionCompraState extends State<InformacionCompra> {
  // Controladores para los campos de texto
  final TextEditingController _dniController = TextEditingController(
    text: '88 888 888',
  );
  final TextEditingController _telefonoController = TextEditingController(
    text: '+51 999 999 999',
  );

  // Variables para los radio buttons
  int _tipoEntrega = 0; // 0: Retiro en tienda, 1: Envío a provincia

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
                          'Información de compra',
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

            // ================= CONTENIDO PRINCIPAL =================
            Expanded(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========== DATOS PERSONALES ==========
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 12, top: 8),
                        child: Text(
                          'Datos personales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Tipo de documento
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 8),
                              child: Text(
                                'Tipo de documento',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'DNI',
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: ['DNI', 'CE', 'Pasaporte'].map((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Número de documento
                      _buildTextField(
                        label: 'Número de documento',
                        controller: _dniController,
                      ),

                      // Teléfono
                      _buildTextField(
                        label: 'Teléfono',
                        controller: _telefonoController,
                      ),

                      const SizedBox(height: 24),
                      Container(height: 1, color: Colors.grey.shade300),
                      const SizedBox(height: 24),

                      // ========== DATOS DE ENTREGA ==========
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          'Datos de entrega',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Opciones de entrega
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            // Retiro en tienda
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _tipoEntrega = 0;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _tipoEntrega == 0
                                              ? const Color(0xFFFF0000)
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: _tipoEntrega == 0
                                          ? Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFFF0000),
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Retiro en tienda',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Envío a provincia
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _tipoEntrega = 1;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _tipoEntrega == 1
                                              ? const Color(0xFFFF0000)
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: _tipoEntrega == 1
                                          ? Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFFF0000),
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Envío a provincia',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Campos adicionales para envío a provincia (sin dirección)
                      if (_tipoEntrega == 1) ...[
                        // Provincia y Distrito
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Provincia',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: 'Lima',
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                          ),
                                          items:
                                              [
                                                'Lima',
                                                'Arequipa',
                                                'Cusco',
                                                'Trujillo',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (String? newValue) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        'Distrito',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: 'Miraflores',
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                          ),
                                          items:
                                              [
                                                'Miraflores',
                                                'San Isidro',
                                                'Barranco',
                                                'Surco',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (String? newValue) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // ❌ ELIMINADO: Campo de dirección
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ================= BARRA INFERIOR =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer<CarritoProvider>(
                        builder: (context, carritoProvider, child) {
                          return Text(
                            'S/ ${carritoProvider.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón continuar con el pago
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí irá la navegación a la pantalla de pago
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Procesando pago...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continuar con el pago',
                        style: TextStyle(
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

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dniController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
