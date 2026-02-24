class VarianteModel {
  final int id;
  final String talla;
  final String? color;
  final int stock;
  final String sku;
  final bool disponible;

  VarianteModel({
    required this.id,
    required this.talla,
    this.color,
    required this.stock,
    required this.sku,
    required this.disponible,
  });

  factory VarianteModel.fromJson(Map<String, dynamic> json) {
    return VarianteModel(
      id: json['id'] ?? 0,
      talla: json['talla'] ?? '',
      color: json['color'],
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      disponible: json['disponible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'talla': talla,
      'color': color,
      'stock': stock,
      'sku': sku,
      'disponible': disponible,
    };
  }

  // Para mostrar en UI
  String get nombreCompleto {
    if (color != null && color!.isNotEmpty) {
      return 'Talla $talla - $color';
    }
    return 'Talla $talla';
  }
}