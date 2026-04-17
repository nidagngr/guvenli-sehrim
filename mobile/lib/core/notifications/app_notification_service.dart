import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationService {
  AppNotificationService._();

  static final AppNotificationService instance = AppNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(settings: const InitializationSettings(android: android));
  }

  Future<void> showThresholdNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'guvenli_sehirim_alerts',
        'Guvenli Sehirim Alerts',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await _plugin.show(id: id, title: title, body: body, notificationDetails: details);
  }
}
