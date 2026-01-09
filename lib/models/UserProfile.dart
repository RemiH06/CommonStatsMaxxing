class UserProfile {
  String name;
  DateTime birthDate;
  double weight; // en kg
  double height; // en cm
  String assignedGender; // "masculino", "femenino", "intersexual"
  String genderIdentity; // "hombre", "mujer", "no binario", "otro"
  bool onHormoneTherapy;
  String? hormoneType; // "estrógeno", "testosterona", "bloqueadores", etc.
  DateTime? hormoneStartDate;
  
  // Preferencias de dieta
  double budgetPerWeek;
  List allergies;
  List dietaryRestrictions; // "vegetariano", "vegano", etc.
  
  // Preferencias de rutina
  String routineType; // "feminine_sculpting", "general_fitness", etc.
  
  // Configuración de notificaciones
  String notificationTime; // formato "HH:mm"
  
  // Configuración de compras
  String shoppingPeriod; // "weekly", "biweekly", "last_saturday", etc.
  String shoppingDay;
  
  UserProfile({
    required this.name,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.assignedGender,
    required this.genderIdentity,
    this.onHormoneTherapy = false,
    this.hormoneType,
    this.hormoneStartDate,
    required this.budgetPerWeek,
    this.allergies = const [],
    this.dietaryRestrictions = const [],
    required this.routineType,
    this.notificationTime = "08:00",
    this.shoppingPeriod = "weekly",
    this.shoppingDay = "Saturday",
  });
  
  Map ToJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'weight': weight,
      'height': height,
      'assignedGender': assignedGender,
      'genderIdentity': genderIdentity,
      'onHormoneTherapy': onHormoneTherapy,
      'hormoneType': hormoneType,
      'hormoneStartDate': hormoneStartDate?.toIso8601String(),
      'budgetPerWeek': budgetPerWeek,
      'allergies': allergies,
      'dietaryRestrictions': dietaryRestrictions,
      'routineType': routineType,
      'notificationTime': notificationTime,
      'shoppingPeriod': shoppingPeriod,
      'shoppingDay': shoppingDay,
    };
  }
  
  factory UserProfile.FromJson(Map json) {
    return UserProfile(
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      weight: json['weight'],
      height: json['height'],
      assignedGender: json['assignedGender'],
      genderIdentity: json['genderIdentity'],
      onHormoneTherapy: json['onHormoneTherapy'] ?? false,
      hormoneType: json['hormoneType'],
      hormoneStartDate: json['hormoneStartDate'] != null 
        ? DateTime.parse(json['hormoneStartDate']) 
        : null,
      budgetPerWeek: json['budgetPerWeek'],
      allergies: List.from(json['allergies'] ?? []),
      dietaryRestrictions: List.from(json['dietaryRestrictions'] ?? []),
      routineType: json['routineType'],
      notificationTime: json['notificationTime'] ?? "08:00",
      shoppingPeriod: json['shoppingPeriod'] ?? "weekly",
      shoppingDay: json['shoppingDay'] ?? "Saturday",
    );
  }
}