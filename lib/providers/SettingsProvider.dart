import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserProfile.dart';
import '../services/DatabaseService.dart';
import '../services/NotificationService.dart';
import '../services/FitbitService.dart';
import '../config/Constants.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final NotificationService _notifications = NotificationService();
  final FitbitService _fitbit = FitbitService();
  
  UserProfile? _userProfile;
  bool _isDarkMode = false;
  bool _isFirstLaunch = true;
  bool _isLoading = false;
  bool _isFitbitConnected = false;
  
  UserProfile? get userProfile => _userProfile;
  bool get isDarkMode => _isDarkMode;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoading => _isLoading;
  bool get isFitbitConnected => _isFitbitConnected;
  
  // inicializa el provider
  Future<void> Initialize() async {
    _isLoading = true;
    notifyListeners();
    
    await LoadUserProfile();
    await LoadThemePreference();
    await CheckFirstLaunch();
    await CheckFitbitConnection();
    
    _isLoading = false;
    notifyListeners();
  }
  
  // carga el perfil del usuario
  Future<void> LoadUserProfile() async {
    try {
      _userProfile = await _db.GetUserProfile();
    } catch (e) {
      print('Error cargando perfil de usuario: $e');
    }
  }
  
  // guarda el perfil del usuario
  Future<void> SaveUserProfile(UserProfile profile) async {
    try {
      await _db.SaveUserProfile(profile);
      _userProfile = profile;
      
      // actualiza las notificaciones con la nueva configuracion
      await UpdateNotifications();
      
      notifyListeners();
    } catch (e) {
      print('Error guardando perfil de usuario: $e');
    }
  }
  
  // actualiza las notificaciones segun la configuracion del usuario
  Future<void> UpdateNotifications() async {
    if (_userProfile == null) return;
    
    try {
      // cancela las notificaciones anteriores
      await _notifications.CancelAllNotifications();
      
      // programa notificaciones de compras
      await _notifications.ScheduleShoppingNotification(
        _userProfile!.shoppingPeriod,
        _userProfile!.shoppingDay,
      );
      
      // las notificaciones de ejercicio se programan cuando hay rutinas activas
      // eso lo maneja el RoutineProvider
      
    } catch (e) {
      print('Error actualizando notificaciones: $e');
    }
  }
  
  // carga la preferencia de tema
  Future<void> LoadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(CsmConstants.PREF_THEME_MODE) ?? false;
    } catch (e) {
      print('Error cargando preferencia de tema: $e');
    }
  }
  
  // cambia el modo oscuro/claro
  Future<void> ToggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CsmConstants.PREF_THEME_MODE, _isDarkMode);
    } catch (e) {
      print('Error guardando preferencia de tema: $e');
    }
    
    notifyListeners();
  }
  
  // verifica si es el primer lanzamiento
  Future<void> CheckFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch = prefs.getBool(CsmConstants.PREF_FIRST_LAUNCH) ?? true;
    } catch (e) {
      print('Error verificando primer lanzamiento: $e');
    }
  }
  
  // marca que ya no es el primer lanzamiento
  Future<void> CompleteFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(CsmConstants.PREF_FIRST_LAUNCH, false);
      _isFirstLaunch = false;
      notifyListeners();
    } catch (e) {
      print('Error marcando primer lanzamiento: $e');
    }
  }
  
  // verifica la conexion con Fitbit
  Future<void> CheckFitbitConnection() async {
    try {
      await _fitbit.LoadTokens();
      _isFitbitConnected = _fitbit.IsAuthenticated();
    } catch (e) {
      print('Error verificando conexion con Fitbit: $e');
    }
  }
  
  // conecta con Fitbit
  Future<bool> ConnectFitbit() async {
    try {
      bool success = await _fitbit.Authenticate();
      if (success) {
        _isFitbitConnected = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error conectando con Fitbit: $e');
      return false;
    }
  }
  
  // desconecta de Fitbit
  Future<void> DisconnectFitbit() async {
    try {
      await _fitbit.Logout();
      _isFitbitConnected = false;
      notifyListeners();
    } catch (e) {
      print('Error desconectando de Fitbit: $e');
    }
  }
  
  // actualiza el peso del usuario
  Future<void> UpdateWeight(double newWeight) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(weight: newWeight);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza la altura del usuario
  Future<void> UpdateHeight(double newHeight) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(height: newHeight);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza el presupuesto semanal
  Future<void> UpdateBudget(double newBudget) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(budgetPerWeek: newBudget);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza la hora de notificaciones
  Future<void> UpdateNotificationTime(String newTime) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(notificationTime: newTime);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza el tipo de rutina preferida
  Future<void> UpdateRoutineType(String newType) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(routineType: newType);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza el periodo de compras
  Future<void> UpdateShoppingPeriod(String newPeriod, String newDay) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(
      shoppingPeriod: newPeriod,
      shoppingDay: newDay,
    );
    await SaveUserProfile(updatedProfile);
  }
  
  // agrega una alergia
  Future<void> AddAllergy(String allergy) async {
    if (_userProfile == null) return;
    
    List<String> allergies = List.from(_userProfile!.allergies);
    if (!allergies.contains(allergy)) {
      allergies.add(allergy);
      UserProfile updatedProfile = _userProfile!.CopyWith(allergies: allergies);
      await SaveUserProfile(updatedProfile);
    }
  }
  
  // elimina una alergia
  Future<void> RemoveAllergy(String allergy) async {
    if (_userProfile == null) return;
    
    List<String> allergies = List.from(_userProfile!.allergies);
    allergies.remove(allergy);
    UserProfile updatedProfile = _userProfile!.CopyWith(allergies: allergies);
    await SaveUserProfile(updatedProfile);
  }
  
  // agrega una restriccion dietetica
  Future<void> AddDietaryRestriction(String restriction) async {
    if (_userProfile == null) return;
    
    List<String> restrictions = List.from(_userProfile!.dietaryRestrictions);
    if (!restrictions.contains(restriction)) {
      restrictions.add(restriction);
      UserProfile updatedProfile = _userProfile!.CopyWith(dietaryRestrictions: restrictions);
      await SaveUserProfile(updatedProfile);
    }
  }
  
  // elimina una restriccion dietetica
  Future<void> RemoveDietaryRestriction(String restriction) async {
    if (_userProfile == null) return;
    
    List<String> restrictions = List.from(_userProfile!.dietaryRestrictions);
    restrictions.remove(restriction);
    UserProfile updatedProfile = _userProfile!.CopyWith(dietaryRestrictions: restrictions);
    await SaveUserProfile(updatedProfile);
  }
  
  // actualiza informacion de terapia hormonal
  Future<void> UpdateHormoneTherapy({
    required bool onTherapy,
    String? hormoneType,
    DateTime? startDate,
  }) async {
    if (_userProfile == null) return;
    
    UserProfile updatedProfile = _userProfile!.CopyWith(
      onHormoneTherapy: onTherapy,
      hormoneType: hormoneType,
      hormoneStartDate: startDate,
    );
    await SaveUserProfile(updatedProfile);
  }
}