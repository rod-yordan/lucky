import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucky/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:lucky/providers/carrito_provider.dart';
import 'package:lucky/models/ubicacion_item.dart';
import 'package:lucky/services/ubicacion_service.dart';

class InformacionCompra extends StatefulWidget {
  const InformacionCompra({super.key});

  @override
  State<InformacionCompra> createState() => _InformacionCompraState();
}

class _InformacionCompraState extends State<InformacionCompra> {
  final TextEditingController _numeroDocumentoController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final UbicacionService _ubicacionService = UbicacionService();

  List<UbicacionItem> _tiposDocumento = [];
  List<UbicacionItem> _departamentos = [];
  List<UbicacionItem> _provincias = [];
  List<UbicacionItem> _distritos = [];

  UbicacionItem? _tipoDocumentoSeleccionado;
  UbicacionItem? _departamentoSeleccionado;
  UbicacionItem? _provinciaSeleccionada;
  UbicacionItem? _distritoSeleccionado;

  // 1 = tienda, 2 = envío
  int _tipoEntrega = 1;

  // Costo de envío calculado
  double? _costoEnvioCalculado;

  // Datos de la agencia
  String? _nombreAgencia;
  String? _direccionAgencia;
  String? _tiempoEstimadoEnvio;

  @override
  void initState() {
    super.initState();
    _cargarTiposDocumento();
    _cargarDepartamentos();
  }

  Future<void> _cargarTiposDocumento() async {
    try {
      final data = await _ubicacionService.obtenerTiposDocumento();

      if (!mounted) return;

      setState(() {
        _tiposDocumento = data;
      });
    } catch (e) {
      _mostrarError('No se pudieron cargar los tipos de documento');
    }
  }

  Future<void> _cargarDepartamentos() async {
    try {
      final data = await _ubicacionService.obtenerDepartamentos();

      if (!mounted) return;

      setState(() {
        _departamentos = data;
      });
    } catch (e) {
      _mostrarError('No se pudieron cargar los departamentos');
    }
  }

  Future<void> _cargarProvincias(int idDepartamento) async {
    setState(() {
      _provincias = [];
      _distritos = [];
      _provinciaSeleccionada = null;
      _distritoSeleccionado = null;
      _costoEnvioCalculado = null;
      _nombreAgencia = null;
      _direccionAgencia = null;
      _tiempoEstimadoEnvio = null;
    });

    try {
      final data = await _ubicacionService.obtenerProvincias(idDepartamento);

      if (!mounted) return;

      setState(() {
        _provincias = data;
      });
    } catch (e) {
      _mostrarError('No se pudieron cargar las provincias');
    }
  }

  Future<void> _cargarDistritos(int idProvincia) async {
    setState(() {
      _distritos = [];
      _distritoSeleccionado = null;
      _costoEnvioCalculado = null;
      _nombreAgencia = null;
      _direccionAgencia = null;
      _tiempoEstimadoEnvio = null;
    });

    try {
      final data = await _ubicacionService.obtenerDistritos(idProvincia);

      if (!mounted) return;

      setState(() {
        _distritos = data;
      });
    } catch (e) {
      _mostrarError('No se pudieron cargar los distritos');
    }
  }

  Future<void> _calcularEnvio(int idDistrito) async {
    try {
      final resultado = await _ubicacionService.calcularCostoEnvio(idDistrito);

      if (mounted) {
        setState(() {
          _costoEnvioCalculado = resultado['costo_envio'] as double;
          _nombreAgencia = resultado['nombre_agencia'] as String?;
          _direccionAgencia = resultado['direccion_agencia'] as String?;
          _tiempoEstimadoEnvio = resultado['tiempo_estimado'] as String?;
        });
      }
    } catch (e) {
      _mostrarError(e.toString());
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _continuarPago() {
    if (_tipoDocumentoSeleccionado == null) {
      _mostrarError('Selecciona el tipo de documento');
      return;
    }

    if (_numeroDocumentoController.text.trim().isEmpty) {
      _mostrarError('Ingresa tu número de documento');
      return;
    }

    if (_telefonoController.text.trim().isEmpty) {
      _mostrarError('Ingresa tu teléfono');
      return;
    }

    if (_tipoEntrega == 2) {
      if (_departamentoSeleccionado == null ||
          _provinciaSeleccionada == null ||
          _distritoSeleccionado == null) {
        _mostrarError('Completa departamento, provincia y distrito');
        return;
      }
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usuario = authProvider.usuario;

    context.push(
      '/resumen-compra',
      extra: {
        'nombreUsuario': '${usuario?.nombres ?? ''} ${usuario?.apellidos ?? ''}'
            .trim(),
        'idTipoDocumento': _tipoDocumentoSeleccionado!.id,
        'tipoDocumentoNombre': _tipoDocumentoSeleccionado!.nombre,
        'numeroDocumento': _numeroDocumentoController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'idTipoEntrega': _tipoEntrega,
        'departamentoNombre': _departamentoSeleccionado?.nombre,
        'provinciaNombre': _provinciaSeleccionada?.nombre,
        'distritoNombre': _distritoSeleccionado?.nombre,
        'idDistrito': _distritoSeleccionado?.id,
        'costoEnvio': _costoEnvioCalculado ?? 0.0,
        'nombreAgencia': _nombreAgencia,
        'direccionAgencia': _direccionAgencia,
        'tiempoEstimadoEnvio': _tiempoEstimadoEnvio,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    color: const Color(0xFFF7F7F7),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 24,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 24,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Datos personales',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _campoDropdownUbicacion(
                                  label: 'Tipo de documento',
                                  value: _tipoDocumentoSeleccionado,
                                  items: _tiposDocumento,
                                  hint: 'Selecciona un tipo de documento',
                                  onChanged: (value) {
                                    setState(() {
                                      _tipoDocumentoSeleccionado = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                _campoTexto(
                                  label: 'Número de documento',
                                  placeholder: 'Ingresa tu número de documento',
                                  controller: _numeroDocumentoController,
                                ),
                                const SizedBox(height: 24),
                                _campoTexto(
                                  label: 'Teléfono',
                                  placeholder: 'Ingresa tu teléfono',
                                  controller: _telefonoController,
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  'Datos de entrega',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // RETIRO EN TIENDA = 1
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _tipoEntrega = 1;
                                      _departamentoSeleccionado = null;
                                      _provinciaSeleccionada = null;
                                      _distritoSeleccionado = null;
                                      _provincias = [];
                                      _distritos = [];
                                      _costoEnvioCalculado = null;
                                      _nombreAgencia = null;
                                      _direccionAgencia = null;
                                      _tiempoEstimadoEnvio = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        _buildRadioCircle(
                                          selected: _tipoEntrega == 1,
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

                                // ENVÍO = 2
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _tipoEntrega = 2;
                                      _costoEnvioCalculado = null;
                                      _nombreAgencia = null;
                                      _direccionAgencia = null;
                                      _tiempoEstimadoEnvio = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        _buildRadioCircle(
                                          selected: _tipoEntrega == 2,
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

                                const SizedBox(height: 20),

                                if (_tipoEntrega == 2) ...[
                                  _campoDropdownUbicacion(
                                    label: 'Departamento',
                                    value: _departamentoSeleccionado,
                                    items: _departamentos,
                                    hint: 'Selecciona un departamento',
                                    onChanged: (value) {
                                      setState(() {
                                        _departamentoSeleccionado = value;
                                      });

                                      if (value != null) {
                                        _cargarProvincias(value.id);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  _campoDropdownUbicacion(
                                    label: 'Provincia',
                                    value: _provinciaSeleccionada,
                                    items: _provincias,
                                    enabled: _departamentoSeleccionado != null,
                                    hint: _departamentoSeleccionado == null
                                        ? 'Primero selecciona un departamento'
                                        : 'Selecciona una provincia',
                                    onChanged: (value) {
                                      setState(() {
                                        _provinciaSeleccionada = value;
                                      });

                                      if (value != null) {
                                        _cargarDistritos(value.id);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  _campoDropdownUbicacion(
                                    label: 'Distrito',
                                    value: _distritoSeleccionado,
                                    items: _distritos,
                                    enabled: _provinciaSeleccionada != null,
                                    hint: _provinciaSeleccionada == null
                                        ? 'Primero selecciona una provincia'
                                        : 'Selecciona un distrito',
                                    onChanged: (value) {
                                      setState(() {
                                        _distritoSeleccionado = value;
                                      });

                                      if (value != null && _tipoEntrega == 2) {
                                        _calcularEnvio(value.id);
                                      }
                                    },
                                  ),
                                ],

                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer<CarritoProvider>(
                        builder: (context, carritoProvider, child) {
                          final subtotal = carritoProvider.total;
                          final totalConEnvio =
                              subtotal + (_costoEnvioCalculado ?? 0);
                          return Text(
                            'S/ ${totalConEnvio.toStringAsFixed(2)}',
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continuarPago,
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

  Widget _campoTexto({
    required String label,
    required String placeholder,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _campoDropdownUbicacion({
    required String label,
    required List<UbicacionItem> items,
    required ValueChanged<UbicacionItem?> onChanged,
    UbicacionItem? value,
    bool enabled = true,
    String hint = 'Selecciona una opción',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade200 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UbicacionItem>(
              value: value,
              isExpanded: true,
              hint: Text(hint),
              icon: const Icon(Icons.arrow_drop_down),
              items: items.map((item) {
                return DropdownMenuItem<UbicacionItem>(
                  value: item,
                  child: Text(item.nombre),
                );
              }).toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioCircle({required bool selected}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _numeroDocumentoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
