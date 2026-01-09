import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/DietProvider.dart';
import '../providers/SettingsProvider.dart';
import '../models/Meal.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class DietView extends StatefulWidget {
  const DietView({Key? key}) : super(key: key);

  @override
  State<DietView> createState() => _DietViewState();
}

class _DietViewState extends State<DietView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    // carga las recetas y comidas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).LoadRecipes();
      Provider.of<DietProvider>(context, listen: false).LoadMeals();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final dietProvider = Provider.of<DietProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = settingsProvider.isDarkMode;
    
    // obtiene las comidas del dia seleccionado
    List<Meal> mealsForDay = dietProvider.meals
        .where((meal) => meal.IsForDate(_selectedDay))
        .toList();
    
    return Scaffold(
      backgroundColor: CsmColors.GetFondo(isDark),
      appBar: AppBar(
        title: Text(
          'Dieta',
          style: TextStyle(
            color: CsmColors.GetVerdeDieta(isDark),
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
                color: CsmColors.GetVerdeDieta(isDark),
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
                dietProvider.SetSelectedDate(selectedDay);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: CsmColors.GetVerdeDieta(isDark),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: CsmColors.GetAzulRutina(isDark).withOpacity(0.5),
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
                  color: CsmColors.GetVerdeDieta(isDark),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonVisible: false,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: CsmColors.GetVerdeDieta(isDark),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: CsmColors.GetVerdeDieta(isDark),
                ),
              ),
            ),
          ),
          
          // titulo de las comidas del dia
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Comidas del día',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CsmColors.GetVerdeDieta(isDark),
              ),
            ),
          ),
          
          // lista de comidas
          Expanded(
            child: mealsForDay.isEmpty
                ? Center(
                    child: Text(
                      'No hay comidas planificadas para este día',
                      style: TextStyle(
                        color: CsmColors.GetTexto(isDark).withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: mealsForDay.length,
                    itemBuilder: (context, index) {
                      return _BuildMealCard(mealsForDay[index], isDark);
                    },
                  ),
          ),
        ],
      ),
      
      // boton para agregar comida
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: abrir dialogo para agregar comida
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Funcionalidad de agregar comida pendiente'),
              backgroundColor: CsmColors.GetVerdeDieta(isDark),
            ),
          );
        },
        backgroundColor: CsmColors.GetVerdeDieta(isDark),
        child: Icon(Icons.add, color: CsmColors.GetFondo(isDark)),
      ),
    );
  }
  
  // construye una tarjeta de comida
  Widget _BuildMealCard(Meal meal, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetRosaRecetas(isDark),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Icon(
          _GetMealIcon(meal.mealType),
          color: CsmColors.GetRosaRecetas(isDark),
          size: 32,
        ),
        title: Text(
          meal.mealType.toUpperCase(),
          style: TextStyle(
            color: CsmColors.GetRosaRecetas(isDark),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          meal.recipe.name,
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
                  meal.recipe.description,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                
                // info de la receta
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: CsmColors.GetNaranjaIngredientes(isDark),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      meal.recipe.GetFormattedTime(),
                      style: TextStyle(
                        color: CsmColors.GetNaranjaIngredientes(isDark),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: CsmColors.GetAmarilloCompras(isDark),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      meal.recipe.GetFormattedCostPerServing(),
                      style: TextStyle(
                        color: CsmColors.GetAmarilloCompras(isDark),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // ingredientes
                Text(
                  'Ingredientes:',
                  style: TextStyle(
                    color: CsmColors.GetNaranjaIngredientes(isDark),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...meal.recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    '• ${ingredient.GetFullDescription()}',
                    style: TextStyle(
                      color: CsmColors.GetTexto(isDark),
                      fontSize: 12,
                    ),
                  ),
                )).toList(),
                const SizedBox(height: 12),
                
                // pasos
                Text(
                  'Preparación:',
                  style: TextStyle(
                    color: CsmColors.GetRosaRecetas(isDark),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...meal.recipe.steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    '${entry.key + 1}. ${entry.value}',
                    style: TextStyle(
                      color: CsmColors.GetTexto(isDark),
                      fontSize: 12,
                    ),
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // obtiene el icono segun el tipo de comida
  IconData _GetMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'desayuno':
        return Icons.wb_sunny;
      case 'comida':
        return Icons.lunch_dining;
      case 'cena':
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }
}