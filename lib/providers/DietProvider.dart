import 'package:flutter/foundation.dart';
import '../models/Meal.dart';
import '../models/Recipe.dart';
import '../models/Ingredient.dart';
import '../services/DatabaseService.dart';
import '../services/CalendarService.dart';

class DietProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final CalendarService _calendar = CalendarService();
  
  List<Meal> _meals = [];
  List<Recipe> _recipes = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  List<Meal> get meals => _meals;
  List<Recipe> get recipes => _recipes;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  
  // carga todas las recetas
  Future<void> LoadRecipes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _recipes = await _db.GetAllRecipes();
    } catch (e) {
      print('Error cargando recetas: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // carga comidas (esto deberia cargar desde BD pero por ahora es una lista vacia)
  // TODO: implementar carga de comidas desde BD
  Future<void> LoadMeals() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // aqui deberia cargar desde la BD
      // por ahora dejamos la lista vacia
      _meals = [];
    } catch (e) {
      print('Error cargando comidas: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // agrega una nueva receta
  Future<void> AddRecipe(Recipe recipe) async {
    try {
      int id = await _db.SaveRecipe(recipe);
      recipe = recipe.CopyWith(id: id);
      _recipes.add(recipe);
      notifyListeners();
    } catch (e) {
      print('Error agregando receta: $e');
    }
  }
  
  // actualiza una receta
  Future<void> UpdateRecipe(Recipe recipe) async {
    try {
      await _db.SaveRecipe(recipe);
      int index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
        notifyListeners();
      }
    } catch (e) {
      print('Error actualizando receta: $e');
    }
  }
  
  // elimina una receta
  Future<void> DeleteRecipe(int id) async {
    try {
      await _db.DeleteRecipe(id);
      _recipes.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      print('Error eliminando receta: $e');
    }
  }
  
  // agrega una comida planificada
  Future<void> AddMeal(Meal meal) async {
    try {
      // TODO: guardar en BD cuando este implementado
      _meals.add(meal);
      notifyListeners();
    } catch (e) {
      print('Error agregando comida: $e');
    }
  }
  
  // marca una comida como completada
  Future<void> MarkMealAsCompleted(int mealId, bool completed) async {
    try {
      int index = _meals.indexWhere((m) => m.id == mealId);
      if (index != -1) {
        _meals[index] = _meals[index].CopyWith(isCompleted: completed);
        notifyListeners();
      }
    } catch (e) {
      print('Error marcando comida: $e');
    }
  }
  
  // cambia la fecha seleccionada
  void SetSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  // obtiene las comidas de la fecha seleccionada
  List<Meal> GetMealsForSelectedDate() {
    return _calendar.GetMealsForDate(_selectedDate, _meals);
  }
  
  // obtiene comidas por tipo (desayuno, comida, cena)
  List<Meal> GetMealsByType(String mealType) {
    return _meals.where((meal) => meal.mealType == mealType).toList();
  }
  
  // obtiene comidas de hoy
  List<Meal> GetTodaysMeals() {
    DateTime today = DateTime.now();
    return _calendar.GetMealsForDate(today, _meals);
  }
  
  // calcula el total de ingredientes para el periodo de compras
  Map<String, Ingredient> CalculateShoppingList(DateTime startDate, DateTime endDate) {
    List<Meal> mealsInRange = _calendar.GetMealsInRange(startDate, endDate, _meals);
    Map<String, Ingredient> consolidatedIngredients = {};
    
    for (var meal in mealsInRange) {
      for (var ingredient in meal.recipe.ingredients) {
        String key = ingredient.name.toLowerCase();
        
        if (consolidatedIngredients.containsKey(key)) {
          // suma la cantidad si ya existe
          Ingredient existing = consolidatedIngredients[key]!;
          consolidatedIngredients[key] = existing.CopyWith(
            quantity: existing.quantity + ingredient.quantity,
          );
        } else {
          // agrega nuevo ingrediente
          consolidatedIngredients[key] = ingredient.CopyWith();
        }
      }
    }
    
    return consolidatedIngredients;
  }
  
  // calcula el presupuesto total para un rango de fechas
  double CalculateBudgetForPeriod(DateTime startDate, DateTime endDate) {
    Map<String, Ingredient> shoppingList = CalculateShoppingList(startDate, endDate);
    double total = 0.0;
    
    shoppingList.forEach((key, ingredient) {
      total += ingredient.CalculateTotalPrice();
    });
    
    return total;
  }
  
  // obtiene recetas por tipo de comida
  List<Recipe> GetRecipesByMealType(String mealType) {
    return _recipes.where((recipe) => recipe.mealType == mealType).toList();
  }
  
  // obtiene recetas que no contengan alergenos
  List<Recipe> GetRecipesWithoutAllergens(List<String> allergens) {
    return _recipes.where((recipe) => !recipe.ContainsAllergens(allergens)).toList();
  }
  
  // busca recetas por nombre
  List<Recipe> SearchRecipes(String query) {
    String lowerQuery = query.toLowerCase();
    return _recipes.where((recipe) => 
      recipe.name.toLowerCase().contains(lowerQuery) ||
      recipe.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}