import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/RoutineProvider.dart';
import 'providers/DietProvider.dart';
import 'providers/SettingsProvider.dart';
import 'screens/MainScreen.dart';
import 'config/Theme.dart';
import 'config/Constants.dart';

void main() async {
  // asegura que los bindings de flutter esten inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // aqui puedes inicializar servicios si es necesario
  // por ejemplo, inicializar la base de datos o notificaciones
  
  runApp(const CommonStatsMaxxingApp());
}

class CommonStatsMaxxingApp extends StatelessWidget {
  const CommonStatsMaxxingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // configura los providers para manejo de estado
    return MultiProvider(
      providers: [
        // provider de configuracion (debe ir primero porque otros dependen de el)
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..Initialize(),
        ),
        
        // provider de rutinas
        ChangeNotifierProvider(
          create: (_) => RoutineProvider()..LoadRoutines(),
        ),
        
        // provider de dieta
        ChangeNotifierProvider(
          create: (_) => DietProvider()
            ..LoadRecipes()
            ..LoadMeals(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: CsmConstants.APP_NAME,
            debugShowCheckedModeBanner: false,
            
            // tema claro
            theme: CsmTheme.GetLightTheme(),
            
            // tema oscuro
            darkTheme: CsmTheme.GetDarkTheme(),
            
            // modo de tema segun preferencia del usuario
            themeMode: settingsProvider.isDarkMode 
                ? ThemeMode.dark 
                : ThemeMode.light,
            
            // pantalla inicial
            home: settingsProvider.isLoading
                ? const LoadingScreen()
                : const MainScreen(),
          );
        },
      ),
    );
  }
}

// pantalla de carga mientras se inicializa la app
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo o icono de la app
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            
            // nombre de la app
            Text(
              CsmConstants.APP_NAME,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            
            // abreviacion
            Text(
              CsmConstants.APP_ABBREVIATION,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 48),
            
            // indicador de carga
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}