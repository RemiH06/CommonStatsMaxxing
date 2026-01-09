import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/RoutineProvider.dart';
import '../providers/SettingsProvider.dart';
import '../models/Routine.dart';
import '../models/Exercise.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class RoutineView extends StatefulWidget {
  const RoutineView({Key? key}) : super(key: key);

  @override
  State<RoutineView> createState() => _RoutineViewState();
}

class _RoutineViewState extends State<RoutineView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    // carga las rutinas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoutineProvider>(context, listen: false).LoadRoutines();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = settingsProvider.isDarkMode;
    
    // obtiene las rutinas del dia seleccionado
    List<Routine> routinesForDay = routineProvider.GetRoutinesForDate(_selectedDay);
    
    return Scaffold(
      backgroundColor: CsmColors.GetFondo(isDark),
      appBar: AppBar(
        title: Text(
          'Rutina de Ejercicio',
          style: TextStyle(
            color: CsmColors.GetAzulRutina(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CsmColors.GetFondo(isDark),
        elevation: 0,
      ),
      body: Column(
        children: [
          // calendario
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: CsmColors.GetAzulRutina(isDark),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: CsmColors.GetAzulRutina(isDark),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: CsmColors.GetVerdeDieta(isDark).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: CsmColors.GetTexto(isDark)),
                weekendTextStyle: TextStyle(color: CsmColors.GetTexto(isDark)),
                outsideTextStyle: TextStyle(
                  color: CsmColors.GetTexto(isDark).withOpacity(0.3),
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  color: CsmColors.GetAzulRutina(isDark),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonVisible: false,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: CsmColors.GetAzulRutina(isDark),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: CsmColors.GetAzulRutina(isDark),
                ),
              ),
              // marca los dias con rutinas programadas
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (routineProvider.GetRoutinesForDate(date).isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: CsmColors.GetAzulRutina(isDark),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          
          // titulo de rutinas del dia
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ejercicios del día',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CsmColors.GetAzulRutina(isDark),
                  ),
                ),
                if (routinesForDay.isNotEmpty)
                  Text(
                    'Duración: ${routinesForDay.first.GetFormattedDuration()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
          
          // lista de ejercicios
          Expanded(
            child: routinesForDay.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.self_improvement,
                          size: 64,
                          color: CsmColors.GetTexto(isDark).withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Día de descanso',
                          style: TextStyle(
                            color: CsmColors.GetTexto(isDark).withOpacity(0.6),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No hay rutina programada para este día',
                          style: TextStyle(
                            color: CsmColors.GetTexto(isDark).withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: routinesForDay.first.exercises.length,
                    itemBuilder: (context, index) {
                      return _BuildExerciseCard(
                        routinesForDay.first.exercises[index],
                        index + 1,
                        isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // boton para ver todas las rutinas
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _ShowAllRoutinesDialog(context, routineProvider, isDark);
        },
        backgroundColor: CsmColors.GetAzulRutina(isDark),
        icon: Icon(Icons.list, color: CsmColors.GetFondo(isDark)),
        label: Text(
          'Ver Rutinas',
          style: TextStyle(color: CsmColors.GetFondo(isDark)),
        ),
      ),
    );
  }
  
  // construye una tarjeta de ejercicio
  Widget _BuildExerciseCard(Exercise exercise, int number, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetAzulRutina(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: CsmColors.GetAzulRutina(isDark),
          child: Text(
            '$number',
            style: TextStyle(
              color: CsmColors.GetFondo(isDark),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: TextStyle(
            color: CsmColors.GetAzulRutina(isDark),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          exercise.GetShortDescription(),
          style: TextStyle(
            color: CsmColors.GetTexto(isDark),
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // descripcion
                Text(
                  exercise.description,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                
                // detalles del ejercicio
                _BuildExerciseDetail(
                  'Área objetivo',
                  exercise.targetArea,
                  Icons.my_location,
                  isDark,
                ),
                _BuildExerciseDetail(
                  'Dificultad',
                  exercise.difficulty,
                  Icons.signal_cellular_alt,
                  isDark,
                ),
                _BuildExerciseDetail(
                  'Tiempo total',
                  exercise.GetFormattedTime(),
                  Icons.timer,
                  isDark,
                ),
                
                // equipo necesario
                if (exercise.equipment.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Equipo necesario:',
                    style: TextStyle(
                      color: CsmColors.GetAzulRutina(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: exercise.equipment.map((item) => Chip(
                      label: Text(
                        item,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: CsmColors.GetAzulRutina(isDark).withOpacity(0.2),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // construye un detalle del ejercicio
  Widget _BuildExerciseDetail(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: CsmColors.GetAzulRutina(isDark),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: CsmColors.GetTexto(isDark).withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: CsmColors.GetTexto(isDark),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  // muestra dialogo con todas las rutinas
  void _ShowAllRoutinesDialog(BuildContext context, RoutineProvider provider, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CsmColors.GetFondo(isDark),
        title: Text(
          'Todas las Rutinas',
          style: TextStyle(color: CsmColors.GetAzulRutina(isDark)),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: provider.routines.length,
            itemBuilder: (context, index) {
              Routine routine = provider.routines[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: CsmColors.GetFondo(isDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: CsmColors.GetAzulRutina(isDark),
                    width: 2,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    routine.name,
                    style: TextStyle(
                      color: CsmColors.GetAzulRutina(isDark),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${routine.GetDaysInSpanish()} - ${routine.exercises.length} ejercicios',
                    style: TextStyle(color: CsmColors.GetTexto(isDark)),
                  ),
                  trailing: Icon(
                    routine.isCustom ? Icons.edit : Icons.lock,
                    color: CsmColors.GetAzulRutina(isDark),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(color: CsmColors.GetAzulRutina(isDark)),
            ),
          ),
        ],
      ),
    );
  }
}