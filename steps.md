lib/
├── main.dart
├── config/
│   ├── Colors.dart          # Paleta de colores
│   ├── Theme.dart           # Tema claro/oscuro
│   └── Constants.dart       # Constantes globales
├── models/
│   ├── Exercise.dart        # Modelo de ejercicio
│   ├── Routine.dart         # Modelo de rutina
│   ├── Meal.dart            # Modelo de comida
│   ├── Recipe.dart          # Modelo de receta
│   ├── Ingredient.dart      # Modelo de ingrediente
│   └── UserProfile.dart     # Perfil del usuario
├── services/
│   ├── DatabaseService.dart     # SQLite
│   ├── NotificationService.dart # Notificaciones
│   ├── FitbitService.dart       # API de Fitbit
│   └── CalendarService.dart     # Manejo de calendario
├── providers/
│   ├── RoutineProvider.dart     # Estado de rutinas
│   ├── DietProvider.dart        # Estado de dieta
│   └── SettingsProvider.dart    # Estado de configuración
├── screens/
│   ├── MainScreen.dart          # Pantalla principal con 3 vistas
│   ├── DietView.dart            # Vista izquierda
│   ├── RoutineView.dart         # Vista central
│   └── SettingsView.dart        # Vista derecha
├── widgets/
│   ├── CustomButton.dart
│   ├── CustomCard.dart
│   ├── RecipeCard.dart
│   └── ExerciseCard.dart
└── data/
    ├── routines/
    │   ├── feminine_sculpting.json
    │   ├── general_fitness.json
    │   └── strength_building.json
    └── recipes/
        └── sample_recipes.json