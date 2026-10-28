import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../config/app_routes.dart';
import '../config/app_shared_pref.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling background message: ${message.messageId}");
  debugPrint("Message data: ${message.data}");
  if (message.notification != null) {
    debugPrint("Message notification: ${message.notification?.title} - ${message.notification?.body}");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> initNotification() async {
    // 1. Request notification permissions
    await _requestPermission();

    // 2. Setup local notification channel & settings
    await _initLocalNotifications();

    // 3. Get FCM token
    await _getFcmToken();

    // 4. Handle foreground notifications
    _listenForegroundMessages();

    // 5. Handle app opened from notification
    _setupNotificationTapHandlers();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User notification permission status: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings, iOS: iosInitSettings);

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload!);
            handleNotificationTap(data);
          } catch (e) {
            debugPrint("Error parsing notification payload: $e");
            _navigateToNotificationScreen();
          }
        } else {
          _navigateToNotificationScreen();
        }
      },
    );

    // Create Android notification channel
    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      _androidChannel,
    );
  }

  Future<String?> _getFcmToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        debugPrint("FCM Token: $token");
        await Pref.setFcmToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((String newToken) async {
        debugPrint("FCM Token Refreshed: $newToken");
        await Pref.setFcmToken(newToken);
      });

      return token;
    } catch (e) {
      debugPrint("Error getting FCM Token: $e");
      return null;
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.messageId}");
      debugPrint("Notification title: ${message.notification?.title}");
      debugPrint("Notification body: ${message.notification?.body}");
      debugPrint("Data: ${message.data}");

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        _localNotificationsPlugin.show(
          id: 101,
          body: notification.body,
          title: notification.title,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/launcher_icon',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  void _setupNotificationTapHandlers() {
    // When app is in background and user clicks on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification opened app from background: ${message.data}");
      handleNotificationTap(message.data);
    });

    // When app was terminated and launched via notification tap
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App launched from terminated state via notification: ${message.data}");
        handleNotificationTap(message.data);
      }
    });
  }

  void handleNotificationTap(Map<String, dynamic> data) {
    debugPrint("Handling notification tap with data: $data");
    if (data.containsKey('route') && data['route'] != null) {
      Get.toNamed(data['route'].toString(), arguments: data);
    } else {
      _navigateToNotificationScreen();
    }
  }

  void _navigateToNotificationScreen() {
    Get.toNamed(AppRoutes.notificationScreen);
  }

  Future<String?> getToken() async {
    return await _getFcmToken();
  }
}
