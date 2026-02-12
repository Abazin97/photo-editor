import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    const ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const settings = InitializationSettings(iOS: ios);
    await plugin.initialize(settings: settings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification() async {
    await plugin.show(
      id: 0,
      title: "Сохранено",
      body: "Изображение сохранено",
      notificationDetails: const NotificationDetails(),
    );
  }
}
