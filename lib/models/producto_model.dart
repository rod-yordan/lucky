class ProductoModel {
  final int id;
  final String titulo;
  final String descripcion;
  final double precio;
  final double? precioAntes;
  final int? descuento;
  final List<String> imagenes;
  final String imagenPrincipal;
  final String? categoria;
  final int? categoriaId;
  final String? genero;
  final List<String> tallas;
  final List<String> colores;
  final String? marca;
  final int stock;
  final String? sku;
  final bool disponible;
  final bool enOferta;

  ProductoModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    this.precioAntes,
    this.descuento,
    required this.imagenes,
    required this.imagenPrincipal,
    this.categoria,
    this.categoriaId,
    this.genero,
    required this.tallas,
    required this.colores,
    this.marca,
    required this.stock,
    this.sku,
    required this.disponible,
    required this.enOferta,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'] ?? '',
      precio: json['precio'].toDouble(),
      precioAntes: json['precio_antes']?.toDouble(),
      descuento: json['descuento'],
      imagenes: List<String>.from(json['imagenes'] ?? []),
      imagenPrincipal: json['imagen_principal'] ?? '',
      categoria: json['categoria'],
      categoriaId: json['categoria_id'],
      genero: json['genero'],
      tallas: List<String>.from(json['tallas'] ?? []),
      colores: List<String>.from(json['colores'] ?? []),
      marca: json['marca'],
      stock: json['stock'] ?? 0,
      sku: json['sku'],
      disponible: json['disponible'] ?? true,
      enOferta: json['en_oferta'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'precio': precio,
      'precio_antes': precioAntes,
      'descuento': descuento,
      'imagenes': imagenes,
      'imagen_principal': imagenPrincipal,
      'categoria': categoria,
      'categoria_id': categoriaId,
      'genero': genero,
      'tallas': tallas,
      'colores': colores,
      'marca': marca,
      'stock': stock,
      'sku': sku,
      'disponible': disponible,
      'en_oferta': enOferta,
    };
  }

  // Para compatibilidad con ProductoCard y código existente
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'precio': precio,
      'precioAntes':
          precioAntes, // ← IMPORTANTE: usar 'precioAntes' (sin guión bajo)
      'descuento': descuento,
      'imagenes': imagenes, // ← Lista de URLs completas
      'imagen_principal': imagenPrincipal,
      'categoria': categoria,
      'categoria_id': categoriaId,
      'genero': genero,
      'tallas': tallas,
      'colores': colores,
      'marca': marca,
      'stock': stock,
      'sku': sku,
      'disponible': disponible,
      'en_oferta': enOferta,
    };
  }
}
