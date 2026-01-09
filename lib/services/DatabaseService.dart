import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/UserProfile.dart';
import '../models/Exercise.dart';
import '../models/Routine.dart';
import '../models/Meal.dart';
import '../models/Recipe.dart';
import '../models/Ingredient.dart';
import '../config/Constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  static Database? _database;
  
  // obtiene la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _InitializeDatabase();
    return _database!;
  }
  
  // inicializa la base de datos
  Future<Database> _InitializeDatabase() async {
    String path = join(await getDatabasesPath(), CsmConstants.DATABASE_NAME);
    
    return await openDatabase(
      path,
      version: CsmConstants.DATABASE_VERSION,
      onCreate: _CreateDatabase,
    );
  }
  
  // crea todas las tablas
  Future<void> _CreateDatabase(Database db, int version) async {
    // tabla de perfil de usuario
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_USER_PROFILE} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        assignedGender TEXT NOT NULL,
        genderIdentity TEXT NOT NULL,
        onHormoneTherapy INTEGER NOT NULL,
        hormoneType TEXT,
        hormoneStartDate TEXT,
        budgetPerWeek REAL NOT NULL,
        allergies TEXT,
        dietaryRestrictions TEXT,
        routineType TEXT NOT NULL,
        notificationTime TEXT NOT NULL,
        shoppingPeriod TEXT NOT NULL,
        shoppingDay TEXT NOT NULL
      )
    ''');
    
    // tabla de ejercicios
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_EXERCISES} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        targetArea TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        repetitions INTEGER,
        durationSeconds INTEGER,
        sets INTEGER NOT NULL,
        restSeconds INTEGER NOT NULL,
        videoUrl TEXT,
        imageUrl TEXT,
        equipment TEXT,
        tags TEXT
      )
    ''');
    
    // tabla de rutinas
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_ROUTINES} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        daysOfWeek TEXT NOT NULL,
        exercises TEXT NOT NULL,
        notes TEXT,
        isCustom INTEGER NOT NULL
      )
    ''');
    
    // tabla de recetas
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_RECIPES} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        steps TEXT NOT NULL,
        preparationTimeMinutes INTEGER NOT NULL,
        cookingTimeMinutes INTEGER NOT NULL,
        servings INTEGER NOT NULL,
        mealType TEXT NOT NULL,
        imageUrl TEXT,
        tags TEXT,
        totalCalories REAL,
        totalProtein REAL,
        totalCarbs REAL,
        totalFats REAL
      )
    ''');
    
    // tabla de comidas planeadas
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_MEALS} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        mealType TEXT NOT NULL,
        recipeId INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        notes TEXT,
        FOREIGN KEY (recipeId) REFERENCES ${CsmConstants.TABLE_RECIPES} (id)
      )
    ''');
    
    // tabla de lista de compras
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_SHOPPING_LIST} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingredientName TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        estimatedPrice REAL,
        category TEXT NOT NULL,
        isPurchased INTEGER NOT NULL,
        periodStart TEXT NOT NULL,
        periodEnd TEXT NOT NULL
      )
    ''');
    
    // tabla de datos de fitbit
    await db.execute('''
      CREATE TABLE ${CsmConstants.TABLE_FITBIT_DATA} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER,
        calories INTEGER,
        distance REAL,
        activeMinutes INTEGER,
        heartRate INTEGER,
        UNIQUE(date)
      )
    ''');
  }
  
  // ====================
  // OPERACIONES DE USER PROFILE
  // ====================
  
  Future<void> SaveUserProfile(UserProfile profile) async {
    final db = await database;
    
    Map<String, dynamic> data = profile.ToJson();
    data['onHormoneTherapy'] = profile.onHormoneTherapy ? 1 : 0;
    data['allergies'] = profile.allergies.join(',');
    data['dietaryRestrictions'] = profile.dietaryRestrictions.join(',');
    
    // elimina el perfil anterior si existe
    await db.delete(CsmConstants.TABLE_USER_PROFILE);
    
    // inserta el nuevo perfil
    await db.insert(CsmConstants.TABLE_USER_PROFILE, data);
  }
  
  Future<UserProfile?> GetUserProfile() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      CsmConstants.TABLE_USER_PROFILE,
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    
    Map<String, dynamic> data = maps.first;
    data['onHormoneTherapy'] = data['onHormoneTherapy'] == 1;
    data['allergies'] = (data['allergies'] as String).split(',').where((s) => s.isNotEmpty).toList();
    data['dietaryRestrictions'] = (data['dietaryRestrictions'] as String).split(',').where((s) => s.isNotEmpty).toList();
    
    return UserProfile.FromJson(data);
  }
  
  // ====================
  // OPERACIONES DE EJERCICIOS
  // ====================
  
  Future<int> SaveExercise(Exercise exercise) async {
    final db = await database;
    
    Map<String, dynamic> data = exercise.ToJson();
    data['equipment'] = exercise.equipment.join(',');
    data['tags'] = exercise.tags.join(',');
    
    if (exercise.id == null) {
      return await db.insert(CsmConstants.TABLE_EXERCISES, data);
    } else {
      await db.update(
        CsmConstants.TABLE_EXERCISES,
        data,
        where: 'id = ?',
        whereArgs: [exercise.id],
      );
      return exercise.id!;
    }
  }
  
  Future<List<Exercise>> GetAllExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CsmConstants.TABLE_EXERCISES);
    
    return maps.map((map) {
      map['equipment'] = (map['equipment'] as String).split(',').where((s) => s.isNotEmpty).toList();
      map['tags'] = (map['tags'] as String).split(',').where((s) => s.isNotEmpty).toList();
      return Exercise.FromJson(map);
    }).toList();
  }
  
  Future<void> DeleteExercise(int id) async {
    final db = await database;
    await db.delete(
      CsmConstants.TABLE_EXERCISES,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // ====================
  // OPERACIONES DE RUTINAS
  // ====================
  
  Future<int> SaveRoutine(Routine routine) async {
    final db = await database;
    
    Map<String, dynamic> data = routine.ToJson();
    data['daysOfWeek'] = routine.daysOfWeek.join(',');
    data['exercises'] = routine.exercises.map((e) => e.id).join(',');
    data['isCustom'] = routine.isCustom ? 1 : 0;
    
    if (routine.id == null) {
      return await db.insert(CsmConstants.TABLE_ROUTINES, data);
    } else {
      await db.update(
        CsmConstants.TABLE_ROUTINES,
        data,
        where: 'id = ?',
        whereArgs: [routine.id],
      );
      return routine.id!;
    }
  }
  
  Future<List<Routine>> GetAllRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CsmConstants.TABLE_ROUTINES);
    
    List<Routine> routines = [];
    for (var map in maps) {
      map['daysOfWeek'] = (map['daysOfWeek'] as String).split(',');
      map['isCustom'] = map['isCustom'] == 1;
      
      // carga los ejercicios
      List<String> exerciseIds = (map['exercises'] as String).split(',');
      List<Exercise> exercises = [];
      for (String idStr in exerciseIds) {
        if (idStr.isNotEmpty) {
          int id = int.parse(idStr);
          Exercise? exercise = await GetExerciseById(id);
          if (exercise != null) exercises.add(exercise);
        }
      }
      map['exercises'] = exercises.map((e) => e.ToJson()).toList();
      
      routines.add(Routine.FromJson(map));
    }
    
    return routines;
  }
  
  Future<Exercise?> GetExerciseById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      CsmConstants.TABLE_EXERCISES,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    
    Map<String, dynamic> map = maps.first;
    map['equipment'] = (map['equipment'] as String).split(',').where((s) => s.isNotEmpty).toList();
    map['tags'] = (map['tags'] as String).split(',').where((s) => s.isNotEmpty).toList();
    
    return Exercise.FromJson(map);
  }
  
  Future<void> DeleteRoutine(int id) async {
    final db = await database;
    await db.delete(
      CsmConstants.TABLE_ROUTINES,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // ====================
  // OPERACIONES DE RECETAS
  // ====================
  
  Future<int> SaveRecipe(Recipe recipe) async {
    final db = await database;
    
    Map<String, dynamic> data = recipe.ToJson();
    data['ingredients'] = recipe.ingredients.map((i) => i.ToJson()).join('|||');
    data['steps'] = recipe.steps.join('|||');
    data['tags'] = recipe.tags.join(',');
    
    if (recipe.id == null) {
      return await db.insert(CsmConstants.TABLE_RECIPES, data);
    } else {
      await db.update(
        CsmConstants.TABLE_RECIPES,
        data,
        where: 'id = ?',
        whereArgs: [recipe.id],
      );
      return recipe.id!;
    }
  }
  
  Future<List<Recipe>> GetAllRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CsmConstants.TABLE_RECIPES);
    
    // esto es una simplificacion, en realidad necesitas deserializar correctamente
    // los ingredientes desde el string guardado en la BD
    return maps.map((map) => Recipe.FromJson(map)).toList();
  }
  
  Future<void> DeleteRecipe(int id) async {
    final db = await database;
    await db.delete(
      CsmConstants.TABLE_RECIPES,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // cierra la base de datos
  Future<void> Close() async {
    final db = await database;
    await db.close();
  }
}