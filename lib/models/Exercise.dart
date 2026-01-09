class Exercise {
  int? id; // null cuando es nuevo, se asigna al guardar en BD
  String name;
  String description;
  String targetArea; // "gluteos", "piernas", "abdomen", "brazos", "pecho", etc.
  String difficulty; // "facil", "medio", "dificil"
  int? repetitions; // numero de reps (null si es por tiempo)
  int? durationSeconds; // duracion en segundos (null si es por reps)
  int sets; // numero de series
  int restSeconds; // descanso entre series
  String? videoUrl; // opcional, URL de video demostrativo
  String? imageUrl; // opcional, URL de imagen
  List<String> equipment; // equipo necesario: ["mancuernas", "colchoneta", etc.]
  List<String> tags; // tags para busqueda: ["feminizante", "cardio", etc.]
  
  Exercise({
    this.id,
    required this.name,
    required this.description,
    required this.targetArea,
    this.difficulty = "medio",
    this.repetitions,
    this.durationSeconds,
    required this.sets,
    this.restSeconds = 60,
    this.videoUrl,
    this.imageUrl,
    this.equipment = const [],
    this.tags = const [],
  });
  
  // Calcula el tiempo total del ejercicio en segundos
  int CalculateTotalTime() {
    int exerciseTime;
    
    if (durationSeconds != null) {
      exerciseTime = durationSeconds! * sets;
    } else if (repetitions != null) {
      // asumimos ~3 segundos por repeticion
      exerciseTime = (repetitions! * 3) * sets;
    } else {
      exerciseTime = 0;
    }
    
    // suma el tiempo de descanso entre series (sets - 1 descansos)
    int totalRestTime = restSeconds * (sets - 1);
    
    return exerciseTime + totalRestTime;
  }
  
  // Formato de tiempo legible
  String GetFormattedTime() {
    int totalSeconds = CalculateTotalTime();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    
    if (minutes > 0) {
      return "$minutes min $seconds seg";
    } else {
      return "$seconds seg";
    }
  }
  
  // Descripcion corta del ejercicio
  String GetShortDescription() {
    if (repetitions != null) {
      return "$sets series x $repetitions reps";
    } else if (durationSeconds != null) {
      return "$sets series x $durationSeconds seg";
    } else {
      return "$sets series";
    }
  }
  
  Map<String, dynamic> ToJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetArea': targetArea,
      'difficulty': difficulty,
      'repetitions': repetitions,
      'durationSeconds': durationSeconds,
      'sets': sets,
      'restSeconds': restSeconds,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'equipment': equipment,
      'tags': tags,
    };
  }
  
  factory Exercise.FromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      targetArea: json['targetArea'],
      difficulty: json['difficulty'] ?? "medio",
      repetitions: json['repetitions'],
      durationSeconds: json['durationSeconds'],
      sets: json['sets'],
      restSeconds: json['restSeconds'] ?? 60,
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'],
      equipment: List<String>.from(json['equipment'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
  
  // copia del ejercicio con modificaciones opcionales
  Exercise CopyWith({
    int? id,
    String? name,
    String? description,
    String? targetArea,
    String? difficulty,
    int? repetitions,
    int? durationSeconds,
    int? sets,
    int? restSeconds,
    String? videoUrl,
    String? imageUrl,
    List<String>? equipment,
    List<String>? tags,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetArea: targetArea ?? this.targetArea,
      difficulty: difficulty ?? this.difficulty,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      sets: sets ?? this.sets,
      restSeconds: restSeconds ?? this.restSeconds,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      equipment: equipment ?? this.equipment,
      tags: tags ?? this.tags,
    );
  }
}