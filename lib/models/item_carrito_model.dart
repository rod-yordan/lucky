// models/item_carrito_model.dart
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
      idDetalle:
          json['id_detalle_carrito'] ??
          0, // ← CAMBIADO de 'id_detalle' a 'id_detalle_carrito'
      idCarrito: json['id_carrito'] ?? 0,
      producto: ProductoModel.fromJson(
        json['variante']['producto'] ?? {},
      ), // ← AHORA VIENE DENTRO DE 'variante'
      variante: VarianteModel.fromJson(json['variante'] ?? {}),
      cantidad: json['cantidad'] ?? 1,
    );
  }

  // ✅ MÉTODO toMap() para compatibilidad con UI actual
  Map<String, dynamic> toMap() {
    return {
      'id_detalle': idDetalle,
      'id_carrito': idCarrito,
      'id_variante': variante.id,
      'id_producto': producto.id,
      'titulo': producto.titulo,
      'descripcion': producto.descripcion,
      'precio': producto.precio,
      'precioAntes': producto.precioAntes,
      'descuento': producto.descuento,
      'imagenes': producto.imagenes,
      'imagen_principal': producto.imagenPrincipal,
      'categoria': producto.categoria,
      'categoria_id': producto.categoriaId,
      'genero': producto.genero,
      'talla': variante.talla,
      'color': variante.color,
      'stock': variante.stock,
      'sku': variante.sku,
      'cantidad': cantidad,
    };
  }

  // Propiedades útiles
  double get subtotal => (producto.precio * cantidad);
  String get titulo => producto.titulo;
  String get talla => variante.talla;
  String? get color => variante.color;
}
