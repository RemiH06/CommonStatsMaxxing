import 'package:flutter/foundation.dart';
import '../models/Routine.dart';
import '../models/Exercise.dart';
import '../services/DatabaseService.dart';

class RoutineProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<Routine> _routines = [];
  Routine? _selectedRoutine;
  bool _isLoading = false;
  
  List<Routine> get routines => _routines;
  Routine? get selectedRoutine => _selectedRoutine;
  bool get isLoading => _isLoading;
  
  // carga todas las rutinas desde la base de datos
  Future<void> LoadRoutines() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _routines = await _db.GetAllRoutines();
    } catch (e) {
      print('Error cargando rutinas: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // agrega una nueva rutina
  Future<void> AddRoutine(Routine routine) async {
    try {
      int id = await _db.SaveRoutine(routine);
      routine = routine.CopyWith(id: id);
      _routines.add(routine);
      notifyListeners();
    } catch (e) {
      print('Error agregando rutina: $e');
    }
  }
  
  // actualiza una rutina existente
  Future<void> UpdateRoutine(Routine routine) async {
    try {
      await _db.SaveRoutine(routine);
      int index = _routines.indexWhere((r) => r.id == routine.id);
      if (index != -1) {
        _routines[index] = routine;
        if (_selectedRoutine?.id == routine.id) {
          _selectedRoutine = routine;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error actualizando rutina: $e');
    }
  }
  
  // elimina una rutina
  Future<void> DeleteRoutine(int id) async {
    try {
      await _db.DeleteRoutine(id);
      _routines.removeWhere((r) => r.id == id);
      if (_selectedRoutine?.id == id) {
        _selectedRoutine = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error eliminando rutina: $e');
    }
  }
  
  // selecciona una rutina
  void SelectRoutine(Routine routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }
  
  // obtiene rutinas para un dia especifico
  List<Routine> GetRoutinesForDate(DateTime date) {
    return _routines.where((routine) => routine.IsScheduledForToday(date)).toList();
  }
  
  // obtiene rutinas por tipo
  List<Routine> GetRoutinesByType(String type) {
    return _routines.where((routine) => routine.type == type).toList();
  }
  
  // obtiene solo rutinas personalizadas
  List<Routine> GetCustomRoutines() {
    return _routines.where((routine) => routine.isCustom).toList();
  }
  
  // obtiene solo rutinas preestablecidas
  List<Routine> GetPresetRoutines() {
    return _routines.where((routine) => !routine.isCustom).toList();
  }
  
  // verifica si hay ejercicio hoy
  bool HasExerciseToday() {
    DateTime today = DateTime.now();
    return GetRoutinesForDate(today).isNotEmpty;
  }
  
  // obtiene la rutina activa del usuario (la primera que encuentre para hoy)
  Routine? GetTodaysRoutine() {
    List<Routine> todaysRoutines = GetRoutinesForDate(DateTime.now());
    return todaysRoutines.isNotEmpty ? todaysRoutines.first : null;
  }
}