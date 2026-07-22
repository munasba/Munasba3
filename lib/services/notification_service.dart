import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _notifications.initialize(const InitializationSettings(android: androidSettings, iOS: iosSettings));
  }

  Future<void> showEventReminder(String title, String body) async {
    const androidDetails = AndroidNotificationDetails('event_channel', 'تذكيرات المناسبات', importance: Importance.high, priority: Priority.high);
    await _notifications.show(0, title, body, const NotificationDetails(android: androidDetails));
  }
}
