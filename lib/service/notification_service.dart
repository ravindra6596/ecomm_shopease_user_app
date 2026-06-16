import 'dart:convert';
import 'dart:developer';

import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
  static Map<String, dynamic>? pendingNotification;
  static const AndroidNotificationChannel channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    await requestNotificationPermission();
    await initLocalNotifications();
    await getFCMToken();
    listenNotifications();
    await checkInitialMessage();
  }

  Future<void> initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse:(NotificationResponse response) {
        log('Notification Clicked: ${response.payload}');
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          handleNotificationNavigation(data);
        }
      },
    );

    await localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: false,
    );

    log( 'Authorization Status: ${settings.authorizationStatus}');
  }

  Future<String> getFCMToken() async {
    String? token =
    await firebaseMessaging.getToken();
    log('FCM Token => $token');
    return token ?? '';
  }

  void listenNotifications() {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log( 'Foreground Message: ${message.notification?.title}');
        showNotification(message);
      },
    );

    /// User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Notification Opened: ${message.notification?.title}');
        NotificationService().handleNotificationNavigation(message.data);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;
    await localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
  void handleNotificationNavigation(
      Map<String, dynamic> data,
      ) {
    final type = data['notification_type'];
    final refId = int.tryParse(
      data['reference_id']?.toString() ?? '0',
    );

    if (type == 'order' && refId != null) {
      getIt<AppRoutes>().push(
        OrderDetailsRoute(
          orderId: refId,
          isFrom: 'notification',
        ),
      );
    }
    else if (type == 'product' && refId != null) {
      getIt<AppRoutes>().push(
        ProductDetailsRoute(
          productId: refId,
         ),
      );
    }
  }
  Future<void> checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      pendingNotification = message.data;
      // handleNotificationNavigation(pendingNotification);
    }
  }
}