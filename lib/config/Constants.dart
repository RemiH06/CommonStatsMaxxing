class CsmConstants {
  // Información de la app
  static const String APP_NAME = "CommonStatsMaxxing";
  static const String APP_VERSION = "1.0.0";
  static const String APP_ABBREVIATION = "CSM";
  
  // Configuración de base de datos
  static const String DATABASE_NAME = "csm_database.db";
  static const int DATABASE_VERSION = 1;
  
  // Tablas de la base de datos
  static const String TABLE_USER_PROFILE = "user_profile";
  static const String TABLE_EXERCISES = "exercises";
  static const String TABLE_ROUTINES = "routines";
  static const String TABLE_MEALS = "meals";
  static const String TABLE_RECIPES = "recipes";
  static const String TABLE_INGREDIENTS = "ingredients";
  static const String TABLE_SHOPPING_LIST = "shopping_list";
  static const String TABLE_FITBIT_DATA = "fitbit_data";
  
  // Tipos de rutina preestablecidas
  static const String ROUTINE_FEMININE_SCULPTING = "feminine_sculpting";
  static const String ROUTINE_GENERAL_FITNESS = "general_fitness";
  static const String ROUTINE_STRENGTH_BUILDING = "strength_building";
  
  // Rutas de archivos JSON de rutinas
  static const String JSON_PATH_FEMININE = "assets/data/routines/feminine_sculpting.json";
  static const String JSON_PATH_GENERAL = "assets/data/routines/general_fitness.json";
  static const String JSON_PATH_STRENGTH = "assets/data/routines/strength_building.json";
  
  // Opciones de género asignado al nacer
  static const List<String> ASSIGNED_GENDER_OPTIONS = [
    "masculino",
    "femenino",
    "intersexual",
  ];
  
  // Opciones de identidad de género
  static const List<String> GENDER_IDENTITY_OPTIONS = [
    "hombre",
    "mujer",
    "no binario",
    "género fluido",
    "agénero",
    "otro",
  ];
  
  // Tipos de terapia hormonal
  static const List<String> HORMONE_THERAPY_TYPES = [
    "estrógeno",
    "testosterona",
    "bloqueadores de testosterona",
    "bloqueadores de estrógeno",
    "combinada",
  ];
  
  // Periodos de compras
  static const List<String> SHOPPING_PERIODS = [
    "weekly",           // cada semana
    "biweekly",         // cada dos semanas
    "last_saturday",    // último sábado del mes
    "first_sunday",     // primer domingo del mes
    "last_day",         // último día del mes
    "first_day",        // primer día del mes
  ];
  
  // Días de la semana
  static const List<String> DAYS_OF_WEEK = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  
  // Nombres en español de días (para mostrar en UI)
  static const Map<String, String> DAYS_SPANISH = {
    "Monday": "Lunes",
    "Tuesday": "Martes",
    "Wednesday": "Miércoles",
    "Thursday": "Jueves",
    "Friday": "Viernes",
    "Saturday": "Sábado",
    "Sunday": "Domingo",
  };
  
  // Restricciones dietéticas comunes
  static const List<String> DIETARY_RESTRICTIONS = [
    "vegetariano",
    "vegano",
    "sin gluten",
    "sin lactosa",
    "sin frutos secos",
    "sin mariscos",
    "halal",
    "kosher",
    "bajo en sodio",
    "bajo en carbohidratos",
  ];
  
  // Tipos de comida
  static const List<String> MEAL_TYPES = [
    "desayuno",
    "comida",
    "cena",
  ];
  
  // Configuración de notificaciones
  static const String NOTIFICATION_CHANNEL_ID = "csm_exercise_notifications";
  static const String NOTIFICATION_CHANNEL_NAME = "Recordatorios de Ejercicio";
  static const String NOTIFICATION_CHANNEL_DESCRIPTION = "Notificaciones para recordarte hacer ejercicio";
  
  // IDs de notificaciones
  static const int NOTIFICATION_ID_EXERCISE = 1000;
  static const int NOTIFICATION_ID_SHOPPING = 2000;
  static const int NOTIFICATION_ID_MEAL = 3000;
  
  // Configuración de Fitbit API
  // NOTA: deberás reemplazar estos valores con los de tu app en Fitbit
  static const String FITBIT_CLIENT_ID = "TU_CLIENT_ID_AQUI";
  static const String FITBIT_CLIENT_SECRET = "TU_CLIENT_SECRET_AQUI";
  static const String FITBIT_REDIRECT_URI = "csm://callback";
  static const String FITBIT_AUTH_URL = "https://www.fitbit.com/oauth2/authorize";
  static const String FITBIT_TOKEN_URL = "https://api.fitbit.com/oauth2/token";
  static const String FITBIT_API_BASE = "https://api.fitbit.com/1/user/-";
  
  // Endpoints de Fitbit
  static const String FITBIT_ENDPOINT_STEPS = "/activities/steps/date";
  static const String FITBIT_ENDPOINT_CALORIES = "/activities/calories/date";
  static const String FITBIT_ENDPOINT_DISTANCE = "/activities/distance/date";
  static const String FITBIT_ENDPOINT_HEART_RATE = "/activities/heart/date";
  
  // Configuración de UI
  static const double BORDER_RADIUS_SMALL = 8.0;
  static const double BORDER_RADIUS_MEDIUM = 12.0;
  static const double BORDER_RADIUS_LARGE = 16.0;
  static const double BORDER_WIDTH = 2.0;
  
  // Padding estándar
  static const double PADDING_SMALL = 8.0;
  static const double PADDING_MEDIUM = 16.0;
  static const double PADDING_LARGE = 24.0;
  
  // Tamaños de íconos
  static const double ICON_SIZE_SMALL = 16.0;
  static const double ICON_SIZE_MEDIUM = 24.0;
  static const double ICON_SIZE_LARGE = 32.0;
  
  // Unidades de medida
  static const String UNIT_WEIGHT = "kg";
  static const String UNIT_HEIGHT = "cm";
  static const String UNIT_DISTANCE = "km";
  static const String UNIT_CURRENCY = "MXN";
  
  // Límites y validaciones
  static const double MIN_WEIGHT = 30.0;  // kg
  static const double MAX_WEIGHT = 300.0; // kg
  static const double MIN_HEIGHT = 100.0; // cm
  static const double MAX_HEIGHT = 250.0; // cm
  static const double MIN_BUDGET = 100.0; // pesos por semana
  static const double MAX_BUDGET = 10000.0; // pesos por semana
  
  // Formatos de fecha
  static const String DATE_FORMAT_DISPLAY = "dd/MM/yyyy";
  static const String DATE_FORMAT_API = "yyyy-MM-dd";
  static const String TIME_FORMAT = "HH:mm";
  
  // Preferencias compartidas (keys para SharedPreferences)
  static const String PREF_USER_PROFILE = "user_profile";
  static const String PREF_THEME_MODE = "theme_mode";
  static const String PREF_FIRST_LAUNCH = "first_launch";
  static const String PREF_FITBIT_TOKEN = "fitbit_token";
  static const String PREF_FITBIT_REFRESH_TOKEN = "fitbit_refresh_token";
  static const String PREF_FITBIT_EXPIRES_AT = "fitbit_expires_at";
}