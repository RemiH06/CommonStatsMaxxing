import 'Exercise.dart';

class Routine {
  int? id;
  String name;
  String description;
  String type; // "feminine_sculpting", "general_fitness", etc.
  List<String> daysOfWeek; // ["Monday", "Wednesday", "Friday"]
  List<Exercise> exercises;
  String? notes; // notas adicionales sobre la rutina
  bool isCustom; // true si el usuario la creo, false si es preestablecida
  
  Routine({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.daysOfWeek,
    required this.exercises,
    this.notes,
    this.isCustom = false,
  });
  
  // Calcula el tiempo total de toda la rutina
  int CalculateTotalDuration() {
    return exercises.fold(0, (total, exercise) => total + exercise.CalculateTotalTime());
  }
  
  // Formato de duracion legible
  String GetFormattedDuration() {
    int totalSeconds = CalculateTotalDuration();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    
    if (minutes > 0) {
      return "$minutes min $seconds seg";
    } else {
      return "$seconds seg";
    }
  }
  
  // Obtiene los dias en formato legible en español
  String GetDaysInSpanish() {
    Map<String, String> daysMap = {
      "Monday": "Lun",
      "Tuesday": "Mar",
      "Wednesday": "Mié",
      "Thursday": "Jue",
      "Friday": "Vie",
      "Saturday": "Sáb",
      "Sunday": "Dom",
    };
    
    return daysOfWeek.map((day) => daysMap[day] ?? day).join(", ");
  }
  
  // Verifica si la rutina se debe hacer hoy
  bool IsScheduledForToday(DateTime date) {
    String dayName = _GetDayName(date);
    return daysOfWeek.contains(dayName);
  }
  
  // Obtiene el nombre del dia en ingles
  String _GetDayName(DateTime date) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[date.weekday - 1];
  }
  
  // Cuenta ejercicios por area
  Map<String, int> GetExercisesByArea() {
    Map<String, int> areaCount = {};
    
    for (var exercise in exercises) {
      areaCount[exercise.targetArea] = (areaCount[exercise.targetArea] ?? 0) + 1;
    }
    
    return areaCount;
  }
  
  Map<String, dynamic> ToJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'daysOfWeek': daysOfWeek,
      'exercises': exercises.map((e) => e.ToJson()).toList(),
      'notes': notes,
      'isCustom': isCustom,
    };
  }
  
  factory Routine.FromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.FromJson(e))
          .toList(),
      notes: json['notes'],
      isCustom: json['isCustom'] ?? false,
    );
  }
  
  Routine CopyWith({
    int? id,
    String? name,
    String? description,
    String? type,
    List<String>? daysOfWeek,
    List<Exercise>? exercises,
    String? notes,
    bool? isCustom,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}