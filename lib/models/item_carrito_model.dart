import 'package:lucky/models/producto_model.dart';
import 'package:lucky/models/variante_model.dart';

class ItemCarritoModel {
  final int idDetalle;
  final int idCarrito;
  final ProductoModel producto;
  final VarianteModel variante;
  final int cantidad;

  ItemCarritoModel({
    required this.idDetalle,
    required this.idCarrito,
    required this.producto,
    required this.variante,
    required this.cantidad,
  });

  factory ItemCarritoModel.fromJson(Map<String, dynamic> json) {
    return ItemCarritoModel(
      idDetalle: json['id_detalle'] ?? 0,
      idCarrito: json['id_carrito'] ?? 0,
      producto: ProductoModel.fromJson(json['producto'] ?? {}),
      variante: VarianteModel.fromJson(json['variante'] ?? {}),
      cantidad: json['cantidad'] ?? 1,
    );
  }

  // Propiedades útiles
  double get subtotal => (producto.precio * cantidad);
  String get titulo => producto.titulo;
  String get talla => variante.talla;
  String? get color => variante.color;
}
