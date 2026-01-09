import 'Recipe.dart';

class Meal {
  int? id;
  DateTime date; // fecha para la que esta planeada esta comida
  String mealType; // "desayuno", "comida", "cena"
  Recipe recipe; // la receta asignada
  bool isCompleted; // si ya se consumio
  String? notes; // notas adicionales del usuario
  
  Meal({
    this.id,
    required this.date,
    required this.mealType,
    required this.recipe,
    this.isCompleted = false,
    this.notes,
  });
  
  // Obtiene la fecha sin hora para comparaciones
  DateTime GetDateOnly() {
    return DateTime(date.year, date.month, date.day);
  }
  
  // Verifica si esta comida es para hoy
  bool IsToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime mealDate = GetDateOnly();
    return today == mealDate;
  }
  
  // Verifica si esta comida es para una fecha especifica
  bool IsForDate(DateTime targetDate) {
    DateTime target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    DateTime mealDate = GetDateOnly();
    return target == mealDate;
  }
  
  // Obtiene descripcion del tipo de comida en formato bonito
  String GetMealTypeFormatted() {
    switch (mealType.toLowerCase()) {
      case 'desayuno':
        return '🌅 Desayuno';
      case 'comida':
        return '☀️ Comida';
      case 'cena':
        return '🌙 Cena';
      default:
        return mealType;
    }
  }
  
  // Obtiene la hora sugerida para esta comida
  String GetSuggestedTime() {
    switch (mealType.toLowerCase()) {
      case 'desayuno':
        return '08:00';
      case 'comida':
        return '14:00';
      case 'cena':
        return '20:00';
      default:
        return '12:00';
    }
  }
  
  Map<String, dynamic> ToJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'recipe': recipe.ToJson(),
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }
  
  factory Meal.FromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: json['mealType'],
      recipe: Recipe.FromJson(json['recipe']),
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'],
    );
  }
  
  Meal CopyWith({
    int? id,
    DateTime? date,
    String? mealType,
    Recipe? recipe,
    bool? isCompleted,
    String? notes,
  }) {
    return Meal(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipe: recipe ?? this.recipe,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}