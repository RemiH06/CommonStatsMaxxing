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
  List<String> allergies;
  List<String> dietaryRestrictions; // "vegetariano", "vegano", etc.
  
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
  
  // Calcula la edad actual
  int GetAge() {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    
    // ajusta si aun no ha cumplido años este año
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  // Calcula el IMC (Indice de Masa Corporal)
  double CalculateBMI() {
    double heightInMeters = height / 100.0;
    return weight / (heightInMeters * heightInMeters);
  }
  
  // Categoria del IMC
  String GetBMICategory() {
    double bmi = CalculateBMI();
    
    if (bmi < 18.5) {
      return "Bajo peso";
    } else if (bmi < 25) {
      return "Peso normal";
    } else if (bmi < 30) {
      return "Sobrepeso";
    } else {
      return "Obesidad";
    }
  }
  
  // Calcula tiempo en terapia hormonal
  String? GetHormoneTherapyDuration() {
    if (!onHormoneTherapy || hormoneStartDate == null) {
      return null;
    }
    
    DateTime now = DateTime.now();
    int months = (now.year - hormoneStartDate!.year) * 12 +
        (now.month - hormoneStartDate!.month);
    
    if (months < 12) {
      return "$months meses";
    } else {
      int years = months ~/ 12;
      int remainingMonths = months % 12;
      
      if (remainingMonths > 0) {
        return "$years años y $remainingMonths meses";
      } else {
        return "$years años";
      }
    }
  }
  
  // Verifica si tiene alergias
  bool HasAllergies() {
    return allergies.isNotEmpty;
  }
  
  // Verifica si tiene restricciones dietéticas
  bool HasDietaryRestrictions() {
    return dietaryRestrictions.isNotEmpty;
  }
  
  Map<String, dynamic> ToJson() {
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
  
  factory UserProfile.FromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      assignedGender: json['assignedGender'],
      genderIdentity: json['genderIdentity'],
      onHormoneTherapy: json['onHormoneTherapy'] ?? false,
      hormoneType: json['hormoneType'],
      hormoneStartDate: json['hormoneStartDate'] != null 
        ? DateTime.parse(json['hormoneStartDate']) 
        : null,
      budgetPerWeek: json['budgetPerWeek'].toDouble(),
      allergies: List<String>.from(json['allergies'] ?? []),
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      routineType: json['routineType'],
      notificationTime: json['notificationTime'] ?? "08:00",
      shoppingPeriod: json['shoppingPeriod'] ?? "weekly",
      shoppingDay: json['shoppingDay'] ?? "Saturday",
    );
  }
  
  UserProfile CopyWith({
    String? name,
    DateTime? birthDate,
    double? weight,
    double? height,
    String? assignedGender,
    String? genderIdentity,
    bool? onHormoneTherapy,
    String? hormoneType,
    DateTime? hormoneStartDate,
    double? budgetPerWeek,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    String? routineType,
    String? notificationTime,
    String? shoppingPeriod,
    String? shoppingDay,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      assignedGender: assignedGender ?? this.assignedGender,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      onHormoneTherapy: onHormoneTherapy ?? this.onHormoneTherapy,
      hormoneType: hormoneType ?? this.hormoneType,
      hormoneStartDate: hormoneStartDate ?? this.hormoneStartDate,
      budgetPerWeek: budgetPerWeek ?? this.budgetPerWeek,
      allergies: allergies ?? this.allergies,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      routineType: routineType ?? this.routineType,
      notificationTime: notificationTime ?? this.notificationTime,
      shoppingPeriod: shoppingPeriod ?? this.shoppingPeriod,
      shoppingDay: shoppingDay ?? this.shoppingDay,
    );
  }
}