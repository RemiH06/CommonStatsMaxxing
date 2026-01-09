import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Constants.dart';

class FitbitService {
  static final FitbitService _instance = FitbitService._internal();
  factory FitbitService() => _instance;
  FitbitService._internal();
  
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiresAt;
  
  // verifica si estamos autenticados
  bool IsAuthenticated() {
    return _accessToken != null && 
           _tokenExpiresAt != null && 
           _tokenExpiresAt!.isAfter(DateTime.now());
  }
  
  // carga tokens guardados
  Future<void> LoadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(CsmConstants.PREF_FITBIT_TOKEN);
    _refreshToken = prefs.getString(CsmConstants.PREF_FITBIT_REFRESH_TOKEN);
    
    String? expiresAtStr = prefs.getString(CsmConstants.PREF_FITBIT_EXPIRES_AT);
    if (expiresAtStr != null) {
      _tokenExpiresAt = DateTime.parse(expiresAtStr);
    }
  }
  
  // guarda tokens
  Future<void> _SaveTokens(String accessToken, String refreshToken, int expiresIn) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CsmConstants.PREF_FITBIT_TOKEN, accessToken);
    await prefs.setString(CsmConstants.PREF_FITBIT_REFRESH_TOKEN, refreshToken);
    await prefs.setString(CsmConstants.PREF_FITBIT_EXPIRES_AT, _tokenExpiresAt!.toIso8601String());
  }
  
  // NOTA: Este metodo es una simplificacion
  // En una app real necesitas implementar OAuth2 correctamente
  // con un webview o navegador para que el usuario autorice
  Future<bool> Authenticate() async {
    // TODO: implementar flujo OAuth2 completo
    // 1. Abrir webview con URL de autorizacion
    // 2. Usuario autoriza en Fitbit
    // 3. Capturar codigo de autorizacion
    // 4. Intercambiar codigo por access token
    
    // por ahora solo retorna false
    print('ERROR: Implementacion de OAuth2 pendiente');
    print('Necesitas configurar el flujo de autorizacion en FitbitService.Authenticate()');
    return false;
  }
  
  // refresca el access token usando el refresh token
  Future<bool> RefreshAccessToken() async {
    if (_refreshToken == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse(CsmConstants.FITBIT_TOKEN_URL),
        headers: {
          'Authorization': 'Basic ${_GetBasicAuth()}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken!,
        },
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _SaveTokens(
          data['access_token'],
          data['refresh_token'],
          data['expires_in'],
        );
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error refrescando token: $e');
      return false;
    }
  }
  
  // obtiene la cadena de autorizacion basica
  String _GetBasicAuth() {
    String credentials = '${CsmConstants.FITBIT_CLIENT_ID}:${CsmConstants.FITBIT_CLIENT_SECRET}';
    return base64Encode(utf8.encode(credentials));
  }
  
  // realiza una peticion a la API de Fitbit
  Future<Map<String, dynamic>?> _MakeRequest(String endpoint) async {
    if (!IsAuthenticated()) {
      bool refreshed = await RefreshAccessToken();
      if (!refreshed) {
        print('No autenticado y no se pudo refrescar token');
        return null;
      }
    }
    
    try {
      final response = await http.get(
        Uri.parse('${CsmConstants.FITBIT_API_BASE}$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // token expirado, intenta refrescar
        bool refreshed = await RefreshAccessToken();
        if (refreshed) {
          return await _MakeRequest(endpoint); // reintenta
        }
      }
      
      print('Error en request: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error haciendo request: $e');
      return null;
    }
  }
  
  // obtiene pasos de un dia especifico
  Future<int?> GetStepsForDate(DateTime date) async {
    String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    String endpoint = '${CsmConstants.FITBIT_ENDPOINT_STEPS}/$dateStr/1d.json';
    
    Map<String, dynamic>? data = await _MakeRequest(endpoint);
    if (data != null && data.containsKey('activities-steps')) {
      List steps = data['activities-steps'];
      if (steps.isNotEmpty) {
        return int.tryParse(steps[0]['value']);
      }
    }
    
    return null;
  }
  
  // obtiene calorias de un dia especifico
  Future<int?> GetCaloriesForDate(DateTime date) async {
    String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    String endpoint = '${CsmConstants.FITBIT_ENDPOINT_CALORIES}/$dateStr/1d.json';
    
    Map<String, dynamic>? data = await _MakeRequest(endpoint);
    if (data != null && data.containsKey('activities-calories')) {
      List calories = data['activities-calories'];
      if (calories.isNotEmpty) {
        return int.tryParse(calories[0]['value']);
      }
    }
    
    return null;
  }
  
  // obtiene distancia de un dia especifico
  Future<double?> GetDistanceForDate(DateTime date) async {
    String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    String endpoint = '${CsmConstants.FITBIT_ENDPOINT_DISTANCE}/$dateStr/1d.json';
    
    Map<String, dynamic>? data = await _MakeRequest(endpoint);
    if (data != null && data.containsKey('activities-distance')) {
      List distance = data['activities-distance'];
      if (distance.isNotEmpty) {
        return double.tryParse(distance[0]['value']);
      }
    }
    
    return null;
  }
  
  // obtiene datos completos de un dia
  Future<Map<String, dynamic>?> GetDailyStats(DateTime date) async {
    int? steps = await GetStepsForDate(date);
    int? calories = await GetCaloriesForDate(date);
    double? distance = await GetDistanceForDate(date);
    
    if (steps == null && calories == null && distance == null) {
      return null;
    }
    
    return {
      'date': date.toIso8601String(),
      'steps': steps ?? 0,
      'calories': calories ?? 0,
      'distance': distance ?? 0.0,
    };
  }
  
  // cierra sesion
  Future<void> Logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiresAt = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(CsmConstants.PREF_FITBIT_TOKEN);
    await prefs.remove(CsmConstants.PREF_FITBIT_REFRESH_TOKEN);
    await prefs.remove(CsmConstants.PREF_FITBIT_EXPIRES_AT);
  }
}