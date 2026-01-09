class Ingredient {
  int? id;
  String name;
  double quantity; // cantidad necesaria
  String unit; // "gramos", "ml", "piezas", "tazas", etc.
  double? estimatedPrice; // precio estimado por unidad
  String category; // "proteina", "vegetal", "fruta", "carbohidrato", etc.
  List<String> allergens; // alergenos: ["lacteos", "gluten", "nueces", etc.]
  
  // informacion nutricional (por 100g o 100ml)
  double? calories;
  double? protein; // gramos
  double? carbs; // gramos
  double? fats; // gramos
  double? fiber; // gramos
  
  bool isPurchased; // para marcar en la lista de compras
  
  Ingredient({
    this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.estimatedPrice,
    this.category = "otro",
    this.allergens = const [],
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.isPurchased = false,
  });
  
  // Calcula el precio total de este ingrediente
  double CalculateTotalPrice() {
    if (estimatedPrice == null) return 0.0;
    return estimatedPrice! * quantity;
  }
  
  // Formato de precio
  String GetFormattedPrice() {
    double price = CalculateTotalPrice();
    return "\$${price.toStringAsFixed(2)} MXN";
  }
  
  // Descripcion completa
  String GetFullDescription() {
    return "$quantity $unit de $name";
  }
  
  // Verifica si contiene algun alergeno de la lista
  bool ContainsAllergen(List<String> userAllergens) {
    return allergens.any((allergen) => userAllergens.contains(allergen));
  }
  
  // Calcula calorias totales basado en la cantidad
  double? CalculateTotalCalories() {
    if (calories == null) return null;
    
    // asumimos que calories es por 100g/100ml
    double multiplier = _GetQuantityMultiplier();
    return calories! * multiplier;
  }
  
  // Obtiene el multiplicador basado en la unidad
  double _GetQuantityMultiplier() {
    // convierte la cantidad a la base de 100g/100ml
    switch (unit.toLowerCase()) {
      case 'gramos':
      case 'g':
      case 'ml':
        return quantity / 100.0;
      case 'kilogramos':
      case 'kg':
        return (quantity * 1000) / 100.0;
      case 'litros':
      case 'l':
        return (quantity * 1000) / 100.0;
      default:
        return quantity; // para piezas u otras unidades
    }
  }
  
  Map<String, dynamic> ToJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'estimatedPrice': estimatedPrice,
      'category': category,
      'allergens': allergens,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'isPurchased': isPurchased,
    };
  }
  
  factory Ingredient.FromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      estimatedPrice: json['estimatedPrice']?.toDouble(),
      category: json['category'] ?? "otro",
      allergens: List<String>.from(json['allergens'] ?? []),
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      carbs: json['carbs']?.toDouble(),
      fats: json['fats']?.toDouble(),
      fiber: json['fiber']?.toDouble(),
      isPurchased: json['isPurchased'] ?? false,
    );
  }
  
  Ingredient CopyWith({
    int? id,
    String? name,
    double? quantity,
    String? unit,
    double? estimatedPrice,
    String? category,
    List<String>? allergens,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    bool? isPurchased,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      category: category ?? this.category,
      allergens: allergens ?? this.allergens,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}