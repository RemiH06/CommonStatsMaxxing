import 'Ingredient.dart';

class Recipe {
  int? id;
  String name;
  String description;
  List<Ingredient> ingredients;
  List<String> steps; // pasos a seguir para preparar
  int preparationTimeMinutes;
  int cookingTimeMinutes;
  int servings; // porciones que rinde
  String mealType; // "desayuno", "comida", "cena"
  String? imageUrl;
  List<String> tags; // "vegetariano", "alto en proteina", etc.
  
  // informacion nutricional total de la receta
  double? totalCalories;
  double? totalProtein;
  double? totalCarbs;
  double? totalFats;
  
  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.preparationTimeMinutes,
    required this.cookingTimeMinutes,
    required this.servings,
    required this.mealType,
    this.imageUrl,
    this.tags = const [],
    this.totalCalories,
    this.totalProtein,
    this.totalCarbs,
    this.totalFats,
  });
  
  // Calcula el tiempo total de preparacion
  int GetTotalTime() {
    return preparationTimeMinutes + cookingTimeMinutes;
  }
  
  // Formato de tiempo legible
  String GetFormattedTime() {
    int total = GetTotalTime();
    if (total >= 60) {
      int hours = total ~/ 60;
      int minutes = total % 60;
      if (minutes > 0) {
        return "${hours}h ${minutes}min";
      } else {
        return "${hours}h";
      }
    } else {
      return "${total}min";
    }
  }
  
  // Calcula el costo total de la receta
  double CalculateTotalCost() {
    return ingredients.fold(0.0, (total, ingredient) {
      return total + ingredient.CalculateTotalPrice();
    });
  }
  
  // Calcula el costo por porcion
  double CalculateCostPerServing() {
    return CalculateTotalCost() / servings;
  }
  
  // Formato de precio
  String GetFormattedCost() {
    double cost = CalculateTotalCost();
    return "\$${cost.toStringAsFixed(2)} MXN";
  }
  
  // Formato de precio por porcion
  String GetFormattedCostPerServing() {
    double cost = CalculateCostPerServing();
    return "\$${cost.toStringAsFixed(2)} MXN/porción";
  }
  
  // Calcula informacion nutricional total si no esta definida
  void CalculateNutrition() {
    totalCalories = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFats = 0;
    
    for (var ingredient in ingredients) {
      totalCalories = (totalCalories ?? 0) + (ingredient.CalculateTotalCalories() ?? 0);
      totalProtein = (totalProtein ?? 0) + (ingredient.protein ?? 0);
      totalCarbs = (totalCarbs ?? 0) + (ingredient.carbs ?? 0);
      totalFats = (totalFats ?? 0) + (ingredient.fats ?? 0);
    }
  }
  
  // Informacion nutricional por porcion
  Map<String, double> GetNutritionPerServing() {
    if (totalCalories == null) {
      CalculateNutrition();
    }
    
    return {
      'calories': (totalCalories ?? 0) / servings,
      'protein': (totalProtein ?? 0) / servings,
      'carbs': (totalCarbs ?? 0) / servings,
      'fats': (totalFats ?? 0) / servings,
    };
  }
  
  // Verifica si contiene alergenos
  bool ContainsAllergens(List<String> userAllergens) {
    return ingredients.any((ingredient) => ingredient.ContainsAllergen(userAllergens));
  }
  
  // Lista de todos los alergenos en la receta
  List<String> GetAllAllergens() {
    Set<String> allergens = {};
    for (var ingredient in ingredients) {
      allergens.addAll(ingredient.allergens);
    }
    return allergens.toList();
  }
  
  Map<String, dynamic> ToJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients.map((i) => i.ToJson()).toList(),
      'steps': steps,
      'preparationTimeMinutes': preparationTimeMinutes,
      'cookingTimeMinutes': cookingTimeMinutes,
      'servings': servings,
      'mealType': mealType,
      'imageUrl': imageUrl,
      'tags': tags,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }
  
  factory Recipe.FromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.FromJson(i))
          .toList(),
      steps: List<String>.from(json['steps']),
      preparationTimeMinutes: json['preparationTimeMinutes'],
      cookingTimeMinutes: json['cookingTimeMinutes'],
      servings: json['servings'],
      mealType: json['mealType'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      totalCalories: json['totalCalories']?.toDouble(),
      totalProtein: json['totalProtein']?.toDouble(),
      totalCarbs: json['totalCarbs']?.toDouble(),
      totalFats: json['totalFats']?.toDouble(),
    );
  }
  
  Recipe CopyWith({
    int? id,
    String? name,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? steps,
    int? preparationTimeMinutes,
    int? cookingTimeMinutes,
    int? servings,
    String? mealType,
    String? imageUrl,
    List<String>? tags,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFats,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      cookingTimeMinutes: cookingTimeMinutes ?? this.cookingTimeMinutes,
      servings: servings ?? this.servings,
      mealType: mealType ?? this.mealType,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFats: totalFats ?? this.totalFats,
    );
  }
}