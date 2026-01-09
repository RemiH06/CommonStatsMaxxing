import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/SettingsProvider.dart';
import 'DietView.dart';
import 'RoutineView.dart';
import 'SettingsView.dart';
import '../config/Colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // empieza en la vista del medio (rutina)
  
  final List<Widget> _views = [
    const DietView(),
    const RoutineView(),
    const SettingsView(),
  ];
  
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = settingsProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: CsmColors.GetFondo(isDark),
      body: Row(
        children: [
          // navegacion lateral (solo en pantallas grandes)
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: CsmColors.GetFondo(isDark),
              selectedIconTheme: IconThemeData(
                color: CsmColors.GetMoradoContornos(isDark),
                size: 28,
              ),
              unselectedIconTheme: IconThemeData(
                color: CsmColors.GetTexto(isDark).withOpacity(0.6),
                size: 24,
              ),
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.restaurant),
                  selectedIcon: Icon(Icons.restaurant),
                  label: Text(
                    'Dieta',
                    style: TextStyle(color: CsmColors.GetVerdeDieta(isDark)),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.fitness_center),
                  selectedIcon: Icon(Icons.fitness_center),
                  label: Text(
                    'Rutina',
                    style: TextStyle(color: CsmColors.GetAzulRutina(isDark)),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(Icons.settings),
                  label: Text(
                    'Config',
                    style: TextStyle(color: CsmColors.GetRojoImportante(isDark)),
                  ),
                ),
              ],
            ),
          
          // divisor vertical
          if (MediaQuery.of(context).size.width > 600)
            VerticalDivider(
              thickness: 2,
              width: 2,
              color: CsmColors.GetMoradoContornos(isDark),
            ),
          
          // contenido principal
          Expanded(
            child: _views[_currentIndex],
          ),
        ],
      ),
      
      // barra de navegacion inferior (solo en pantallas pequeñas)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: CsmColors.GetFondo(isDark),
              selectedItemColor: CsmColors.GetMoradoContornos(isDark),
              unselectedItemColor: CsmColors.GetTexto(isDark).withOpacity(0.6),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant),
                  label: 'Dieta',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center),
                  label: 'Rutina',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Config',
                ),
              ],
            )
          : null,
    );
  }
}