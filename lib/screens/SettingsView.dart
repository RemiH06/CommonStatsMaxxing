import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/SettingsProvider.dart';
import '../models/UserProfile.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    // carga el perfil al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).Initialize();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = settingsProvider.isDarkMode;
    final profile = settingsProvider.userProfile;
    
    return Scaffold(
      backgroundColor: CsmColors.GetFondo(isDark),
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: TextStyle(
            color: CsmColors.GetRojoImportante(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CsmColors.GetFondo(isDark),
        elevation: 0,
        actions: [
          // boton para modo oscuro/claro
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: CsmColors.GetRojoImportante(isDark),
            ),
            onPressed: () {
              settingsProvider.ToggleDarkMode();
            },
          ),
        ],
      ),
      body: profile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 64,
                    color: CsmColors.GetRojoImportante(isDark).withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Crea tu perfil para comenzar',
                    style: TextStyle(
                      fontSize: 18,
                      color: CsmColors.GetTexto(isDark),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: abrir formulario de creacion de perfil
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Formulario de perfil pendiente'),
                          backgroundColor: CsmColors.GetRojoImportante(isDark),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CsmColors.GetRojoImportante(isDark),
                    ),
                    child: Text('Crear Perfil'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // informacion personal
                  _BuildSectionTitle('Información Personal', isDark),
                  _BuildInfoCard(profile, isDark),
                  const SizedBox(height: 24),
                  
                  // informacion de genero
                  _BuildSectionTitle('Identidad de Género', isDark),
                  _BuildGenderCard(profile, isDark),
                  const SizedBox(height: 24),
                  
                  // preferencias de dieta
                  _BuildSectionTitle('Preferencias de Dieta', isDark),
                  _BuildDietCard(profile, isDark),
                  const SizedBox(height: 24),
                  
                  // configuracion de ejercicio
                  _BuildSectionTitle('Configuración de Ejercicio', isDark),
                  _BuildExerciseCard(profile, isDark),
                  const SizedBox(height: 24),
                  
                  // configuracion de compras
                  _BuildSectionTitle('Configuración de Compras', isDark),
                  _BuildShoppingCard(profile, isDark),
                  const SizedBox(height: 24),
                  
                  // integraciones
                  _BuildSectionTitle('Integraciones', isDark),
                  _BuildIntegrationsCard(settingsProvider, isDark),
                ],
              ),
            ),
    );
  }
  
  // titulo de seccion
  Widget _BuildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: CsmColors.GetRojoImportante(isDark),
        ),
      ),
    );
  }
  
  // tarjeta de informacion personal
  Widget _BuildInfoCard(UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetMoradoContornos(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildInfoRow('Nombre', profile.name, Icons.person, isDark),
          _BuildInfoRow('Edad', '${profile.GetAge()} años', Icons.cake, isDark),
          _BuildInfoRow('Peso', '${profile.weight} kg', Icons.monitor_weight, isDark),
          _BuildInfoRow('Altura', '${profile.height} cm', Icons.height, isDark),
          _BuildInfoRow('IMC', '${profile.CalculateBMI().toStringAsFixed(1)} - ${profile.GetBMICategory()}', Icons.analytics, isDark),
        ],
      ),
    );
  }
  
  // tarjeta de genero
  Widget _BuildGenderCard(UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetMoradoContornos(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildInfoRow('Género asignado', profile.assignedGender, Icons.assignment, isDark),
          _BuildInfoRow('Identidad de género', profile.genderIdentity, Icons.person_outline, isDark),
          if (profile.onHormoneTherapy) ...[
            _BuildInfoRow('Terapia hormonal', profile.hormoneType ?? 'No especificado', Icons.medication, isDark),
            if (profile.GetHormoneTherapyDuration() != null)
              _BuildInfoRow('Duración', profile.GetHormoneTherapyDuration()!, Icons.timer, isDark),
          ] else
            _BuildInfoRow('Terapia hormonal', 'No activa', Icons.medication_liquid, isDark),
        ],
      ),
    );
  }
  
  // tarjeta de dieta
  Widget _BuildDietCard(UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetVerdeDieta(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildInfoRow('Presupuesto semanal', '\$${profile.budgetPerWeek.toStringAsFixed(2)} MXN', Icons.attach_money, isDark),
          if (profile.allergies.isNotEmpty)
            _BuildListRow('Alergias', profile.allergies, Icons.warning, isDark),
          if (profile.dietaryRestrictions.isNotEmpty)
            _BuildListRow('Restricciones', profile.dietaryRestrictions, Icons.restaurant_menu, isDark),
        ],
      ),
    );
  }
  
  // tarjeta de ejercicio
  Widget _BuildExerciseCard(UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetAzulRutina(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildInfoRow('Tipo de rutina', _GetRoutineName(profile.routineType), Icons.fitness_center, isDark),
          _BuildInfoRow('Hora de notificación', profile.notificationTime, Icons.notifications, isDark),
        ],
      ),
    );
  }
  
  // tarjeta de compras
  Widget _BuildShoppingCard(UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetAmarilloCompras(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildInfoRow('Periodo de compras', _GetShoppingPeriodName(profile.shoppingPeriod), Icons.calendar_today, isDark),
          _BuildInfoRow('Día de compras', profile.shoppingDay, Icons.shopping_cart, isDark),
        ],
      ),
    );
  }
  
  // tarjeta de integraciones
  Widget _BuildIntegrationsCard(SettingsProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetMoradoContornos(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: provider.isFitbitConnected 
                    ? CsmColors.GetVerdeDieta(isDark)
                    : CsmColors.GetTexto(isDark).withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Fitbit',
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark),
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (provider.isFitbitConnected) {
                    provider.DisconnectFitbit();
                  } else {
                    provider.ConnectFitbit();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: provider.isFitbitConnected
                      ? CsmColors.GetRojoImportante(isDark)
                      : CsmColors.GetVerdeDieta(isDark),
                ),
                child: Text(
                  provider.isFitbitConnected ? 'Desconectar' : 'Conectar',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // fila de informacion
  Widget _BuildInfoRow(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: CsmColors.GetTexto(isDark).withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // fila con lista de items
  Widget _BuildListRow(String label, List<String> items, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: CsmColors.GetTexto(isDark).withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) => Chip(
                    label: Text(
                      item,
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: CsmColors.GetTexto(isDark).withOpacity(0.1),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // obtiene el nombre de la rutina
  String _GetRoutineName(String type) {
    switch (type) {
      case 'feminine_sculpting':
        return 'Esculpido Femenino';
      case 'general_fitness':
        return 'Fitness General';
      case 'strength_building':
        return 'Construcción de Fuerza';
      default:
        return type;
    }
  }
  
  // obtiene el nombre del periodo de compras
  String _GetShoppingPeriodName(String period) {
    switch (period) {
      case 'weekly':
        return 'Semanal';
      case 'biweekly':
        return 'Quincenal';
      case 'last_saturday':
        return 'Último sábado del mes';
      case 'first_sunday':
        return 'Primer domingo del mes';
      case 'last_day':
        return 'Último día del mes';
      case 'first_day':
        return 'Primer día del mes';
      default:
        return period;
    }
  }
}