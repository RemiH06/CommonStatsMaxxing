import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../config/Constants.dart';
import '../models/Exercise.dart';
import '../models/Routine.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  // inicializa el servicio de notificaciones
  Future<void> Initialize() async {
    if (_initialized) return;
    
    // inicializa zonas horarias
    tz.initializeTimeZones();
    
    // configuracion para android
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // configuracion para iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _OnNotificationTapped,
    );
    
    // crea el canal de notificaciones para android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      CsmConstants.NOTIFICATION_CHANNEL_ID,
      CsmConstants.NOTIFICATION_CHANNEL_NAME,
      description: CsmConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
      importance: Importance.high,
    );
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    _initialized = true;
  }
  
  // maneja cuando el usuario toca una notificacion
  void _OnNotificationTapped(NotificationResponse response) {
    // aqui puedes navegar a la pantalla correspondiente
    // dependiendo del payload de la notificacion
    print('Notificacion tocada: ${response.payload}');
  }
  
  // solicita permisos (principalmente para iOS)
  Future<bool> RequestPermissions() async {
    final bool? granted = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    return granted ?? true; // android no necesita permisos explicitos
  }
  
  // programa notificacion diaria para ejercicios
  Future<void> ScheduleDailyExerciseNotification(String time, Routine routine) async {
    await Initialize();
    
    // parsea la hora (formato "HH:mm")
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    
    // programa para cada dia de la semana que tiene la rutina
    for (int i = 0; i < routine.daysOfWeek.length; i++) {
      String day = routine.daysOfWeek[i];
      int weekday = _GetWeekdayNumber(day);
      
      await _notifications.zonedSchedule(
        CsmConstants.NOTIFICATION_ID_EXERCISE + i, // id unico
        'Hora de hacer ejercicio! 💪',
        'Hoy toca: ${routine.name} (${routine.GetFormattedDuration()})',
        _GetNextInstanceOfDayAndTime(weekday, hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(
            CsmConstants.NOTIFICATION_CHANNEL_ID,
            CsmConstants.NOTIFICATION_CHANNEL_NAME,
            channelDescription: CsmConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'exercise_${routine.id}',
      );
    }
  }
  
  // obtiene el numero del dia de la semana (1 = lunes, 7 = domingo)
  int _GetWeekdayNumber(String day) {
    Map<String, int> days = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return days[day] ?? 1;
  }
  
  // obtiene la siguiente instancia de un dia y hora especificos
  tz.TZDateTime _GetNextInstanceOfDayAndTime(int weekday, int hour, int minute) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // ajusta al dia de la semana correcto
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    // si ya paso ese dia y hora esta semana, programa para la proxima
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    
    return scheduledDate;
  }
  
  // cancela todas las notificaciones de ejercicio
  Future<void> CancelExerciseNotifications() async {
    await Initialize();
    
    // cancela las primeras 10 notificaciones (suficiente para 7 dias + margen)
    for (int i = 0; i < 10; i++) {
      await _notifications.cancel(CsmConstants.NOTIFICATION_ID_EXERCISE + i);
    }
  }
  
  // muestra notificacion inmediata (para testing)
  Future<void> ShowImmediateNotification(String title, String body) async {
    await Initialize();
    
    await _notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          CsmConstants.NOTIFICATION_CHANNEL_ID,
          CsmConstants.NOTIFICATION_CHANNEL_NAME,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
  
  // programa notificacion para dia de compras
  Future<void> ScheduleShoppingNotification(String period, String day) async {
    await Initialize();
    
    tz.TZDateTime scheduledDate = _CalculateNextShoppingDate(period, day);
    
    await _notifications.zonedSchedule(
      CsmConstants.NOTIFICATION_ID_SHOPPING,
      'Dia de compras! 🛒',
      'Revisa tu lista de compras para la siguiente semana',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          CsmConstants.NOTIFICATION_CHANNEL_ID,
          CsmConstants.NOTIFICATION_CHANNEL_NAME,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  // calcula la proxima fecha de compras segun el periodo
  tz.TZDateTime _CalculateNextShoppingDate(String period, String day) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime nextDate = now;
    
    switch (period) {
      case 'weekly':
        int targetWeekday = _GetWeekdayNumber(day);
        while (nextDate.weekday != targetWeekday || nextDate.isBefore(now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        break;
        
      case 'biweekly':
        int targetWeekday = _GetWeekdayNumber(day);
        while (nextDate.weekday != targetWeekday || nextDate.isBefore(now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        // suma 2 semanas si ya paso
        if (nextDate.isBefore(now)) {
          nextDate = nextDate.add(const Duration(days: 14));
        }
        break;
        
      case 'last_saturday':
        // encuentra el ultimo sabado del mes
        nextDate = tz.TZDateTime(tz.local, now.year, now.month + 1, 0);
        while (nextDate.weekday != DateTime.saturday) {
          nextDate = nextDate.subtract(const Duration(days: 1));
        }
        if (nextDate.isBefore(now)) {
          nextDate = tz.TZDateTime(tz.local, now.year, now.month + 2, 0);
          while (nextDate.weekday != DateTime.saturday) {
            nextDate = nextDate.subtract(const Duration(days: 1));
          }
        }
        break;
        
      case 'first_sunday':
        // encuentra el primer domingo del mes
        nextDate = tz.TZDateTime(tz.local, now.year, now.month, 1);
        while (nextDate.weekday != DateTime.sunday) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        if (nextDate.isBefore(now)) {
          nextDate = tz.TZDateTime(tz.local, now.year, now.month + 1, 1);
          while (nextDate.weekday != DateTime.sunday) {
            nextDate = nextDate.add(const Duration(days: 1));
          }
        }
        break;
        
      default:
        nextDate = now.add(const Duration(days: 7));
    }
    
    // establece la hora a las 9:00 AM
    return tz.TZDateTime(
      tz.local,
      nextDate.year,
      nextDate.month,
      nextDate.day,
      9,
      0,
    );
  }
  
  // cancela notificaciones de compras
  Future<void> CancelShoppingNotifications() async {
    await Initialize();
    await _notifications.cancel(CsmConstants.NOTIFICATION_ID_SHOPPING);
  }
  
  // cancela todas las notificaciones
  Future<void> CancelAllNotifications() async {
    await Initialize();
    await _notifications.cancelAll();
  }
}