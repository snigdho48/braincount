import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get_storage/get_storage.dart';

// Initialize notifications
Future<void> initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Make sure to use the correct icon name

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the notification plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        onDidReceiveNotificationResponse, // Handle foreground notification tap
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse, // Handle background notification tap
  );
}

// Notification response when tapped (foreground)
Future<void> onDidReceiveNotificationResponse(
    NotificationResponse response) async {
  Get.toNamed(Routes.NOTIFICATIONS); // Navigate to WificonnectView

}

// Notification response when tapped (background)
Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response) async {
  Get.toNamed(Routes.NOTIFICATIONS); // Navigate to WificonnectView
}

// Show a notification
void showNotification(String title, String body) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '10', // Channel ID
    'BrainCount', // Channel Name
    channelDescription: 'Channel for notifications',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/launcher_icon', 
    ticker: 'ticker',
    enableVibration: true,
  );
  
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    10, // Notification ID
    title,
    body,
    platformChannelSpecifics,
    payload:
        'Optional Payload', // This is the payload data passed to the callback
  );
}

/// Top-level background task for Workmanager

/// Entry point for the background service (Android only)
void notificationServiceOnStart(ServiceInstance service) async {
  // Optionally set as foreground
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  final storage = GetStorage();
  // Connect to your WebSocket
  final token = storage.read('token');
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://bc.reachableads.com/ws/notifications/?token=$token'),
  );

  channel.stream.listen((message) {
    try {
      final decoded = jsonDecode(message);
      // Show a notification for each incoming message
      showNotification(
        decoded['title']?.toString() ?? 'New Notification',
        decoded['body']?.toString() ?? 'You have a new notification',
      );
    } catch (e) {
      // Optionally handle error
    }
  });
}

/// Call this to start the background service (Android only)
Future<void> startNotificationBackgroundService() async {
  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: notificationServiceOnStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'braincount_notification_channel',
      initialNotificationTitle: 'BrainCount',
      initialNotificationContent: 'Listening for notifications...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: notificationServiceOnStart,
      onBackground: (service) => false,
    ),
  );
  await FlutterBackgroundService().startService();
}

// Somewhere in your app startup (e.g., after login or in main)




