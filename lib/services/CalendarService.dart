import '../models/Meal.dart';
import '../models/Routine.dart';
import '../models/UserProfile.dart';

class CalendarService {
  static final CalendarService _instance = CalendarService._internal();
  factory CalendarService() => _instance;
  CalendarService._internal();
  
  // obtiene las comidas de un dia especifico
  List<Meal> GetMealsForDate(DateTime date, List<Meal> allMeals) {
    return allMeals.where((meal) => meal.IsForDate(date)).toList();
  }
  
  // verifica si hay una rutina programada para un dia especifico
  bool HasRoutineForDate(DateTime date, Routine routine) {
    return routine.IsScheduledForToday(date);
  }
  
  // obtiene todas las rutinas programadas para un dia
  List<Routine> GetRoutinesForDate(DateTime date, List<Routine> allRoutines) {
    return allRoutines.where((routine) => routine.IsScheduledForToday(date)).toList();
  }
  
  // calcula el siguiente dia de compras segun la configuracion
  DateTime CalculateNextShoppingDay(UserProfile profile) {
    DateTime now = DateTime.now();
    DateTime nextDate = now;
    
    switch (profile.shoppingPeriod) {
      case 'weekly':
        int targetWeekday = _GetWeekdayNumber(profile.shoppingDay);
        while (nextDate.weekday != targetWeekday || _IsSameDay(nextDate, now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        break;
        
      case 'biweekly':
        int targetWeekday = _GetWeekdayNumber(profile.shoppingDay);
        while (nextDate.weekday != targetWeekday || _IsSameDay(nextDate, now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        // si encontramos uno esta semana, suma 2 semanas
        if (nextDate.difference(now).inDays < 7) {
          nextDate = nextDate.add(const Duration(days: 14));
        }
        break;
        
      case 'last_saturday':
        // encuentra el ultimo sabado del mes actual
        nextDate = DateTime(now.year, now.month + 1, 0);
        while (nextDate.weekday != DateTime.saturday) {
          nextDate = nextDate.subtract(const Duration(days: 1));
        }
        // si ya paso, busca el del siguiente mes
        if (nextDate.isBefore(now) || _IsSameDay(nextDate, now)) {
          nextDate = DateTime(now.year, now.month + 2, 0);
          while (nextDate.weekday != DateTime.saturday) {
            nextDate = nextDate.subtract(const Duration(days: 1));
          }
        }
        break;
        
      case 'first_sunday':
        // encuentra el primer domingo del mes actual
        nextDate = DateTime(now.year, now.month, 1);
        while (nextDate.weekday != DateTime.sunday) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        // si ya paso, busca el del siguiente mes
        if (nextDate.isBefore(now) || _IsSameDay(nextDate, now)) {
          nextDate = DateTime(now.year, now.month + 1, 1);
          while (nextDate.weekday != DateTime.sunday) {
            nextDate = nextDate.add(const Duration(days: 1));
          }
        }
        break;
        
      case 'last_day':
        // ultimo dia del mes
        nextDate = DateTime(now.year, now.month + 1, 0);
        if (nextDate.isBefore(now) || _IsSameDay(nextDate, now)) {
          nextDate = DateTime(now.year, now.month + 2, 0);
        }
        break;
        
      case 'first_day':
        // primer dia del mes
        nextDate = DateTime(now.year, now.month, 1);
        if (nextDate.isBefore(now) || _IsSameDay(nextDate, now)) {
          nextDate = DateTime(now.year, now.month + 1, 1);
        }
        break;
        
      default:
        // por defecto, el proximo sabado
        while (nextDate.weekday != DateTime.saturday || _IsSameDay(nextDate, now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
    }
    
    return nextDate;
  }
  
  // obtiene todas las fechas para compras en un rango
  List<DateTime> GetShoppingDatesInRange(DateTime start, DateTime end, UserProfile profile) {
    List<DateTime> dates = [];
    DateTime current = start;
    
    while (current.isBefore(end) || _IsSameDay(current, end)) {
      DateTime nextShopping = CalculateNextShoppingDay(profile);
      
      if (nextShopping.isAfter(start) && 
          (nextShopping.isBefore(end) || _IsSameDay(nextShopping, end))) {
        dates.add(nextShopping);
      }
      
      // avanza al siguiente periodo
      current = nextShopping.add(const Duration(days: 1));
    }
    
    return dates;
  }
  
  // calcula el rango de fechas para el siguiente periodo de compras
  DateRange CalculateShoppingPeriodRange(UserProfile profile) {
    DateTime nextShoppingDay = CalculateNextShoppingDay(profile);
    DateTime periodStart = DateTime.now();
    DateTime periodEnd;
    
    switch (profile.shoppingPeriod) {
      case 'weekly':
        periodEnd = periodStart.add(const Duration(days: 7));
        break;
      case 'biweekly':
        periodEnd = periodStart.add(const Duration(days: 14));
        break;
      case 'last_saturday':
      case 'first_sunday':
      case 'last_day':
      case 'first_day':
        // hasta el siguiente dia de compras
        periodEnd = nextShoppingDay;
        break;
      default:
        periodEnd = periodStart.add(const Duration(days: 7));
    }
    
    return DateRange(periodStart, periodEnd);
  }
  
  // obtiene todas las comidas en un rango de fechas
  List<Meal> GetMealsInRange(DateTime start, DateTime end, List<Meal> allMeals) {
    return allMeals.where((meal) {
      DateTime mealDate = meal.GetDateOnly();
      return (mealDate.isAfter(start) || _IsSameDay(mealDate, start)) &&
             (mealDate.isBefore(end) || _IsSameDay(mealDate, end));
    }).toList();
  }
  
  // verifica si dos fechas son el mismo dia
  bool _IsSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  // obtiene el numero del dia de la semana
  int _GetWeekdayNumber(String day) {
    Map<String, int> days = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };
    return days[day] ?? DateTime.saturday;
  }
  
  // obtiene el nombre del dia en español
  String GetDayNameInSpanish(DateTime date) {
    List<String> days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }
  
  // obtiene el nombre del mes en español
  String GetMonthNameInSpanish(int month) {
    List<String> months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
  
  // formatea una fecha de manera bonita
  String FormatDatePretty(DateTime date) {
    String day = GetDayNameInSpanish(date);
    String month = GetMonthNameInSpanish(date.month);
    return '$day, ${date.day} de $month de ${date.year}';
  }
}

// clase auxiliar para representar un rango de fechas
class DateRange {
  final DateTime start;
  final DateTime end;
  
  DateRange(this.start, this.end);
  
  int GetDaysCount() {
    return end.difference(start).inDays + 1;
  }
  
  bool Contains(DateTime date) {
    return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
           (date.isBefore(end) || date.isAtSameMomentAs(end));
  }
}