import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/string.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  late final GlobalKey<NavigatorState> navigatorKey;

  /// Call this from main.dart
  Future<void> initialize(GlobalKey<NavigatorState> navKey) async {
    navigatorKey = navKey;

    // Initialize Firebase
    await Firebase.initializeApp();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine initialization settings
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    // Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped: ${response.payload}');
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final payloadMap = jsonDecode(response.payload!);
            // Handle payload if needed
          } catch (e) {
            debugPrint('Payload decode error: $e');
          }
        }
      },
    );

    // Create default sound channel (Android)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_sound_channel', // NEW ID
        'Default Sound Notifications',
        description: 'Plays default notification sound',
        importance: Importance.max,
        playSound: true,
      ),
    );

    // // Request notification permission via Firebase (iOS + Android 13+)
    // await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground handler
    FirebaseMessaging.onMessage.listen(_onMessage);

    // App opened from terminated state via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.data}');
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      debugPrint('Initial message data: ${initialMessage.data}');
    }
  }

  // Background handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('Background message: ${message.messageId}');
  }

  // Foreground handler
  void _onMessage(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'];
    final body = notification?.body ?? message.data['body'];
    final type = message.data['type'];

    debugPrint('Foreground message received: $title / $body');
    if (message.notification != null && !Platform.isIOS) {
      _showLocalNotification(title, body, message.data);
    }

    if (type == "Subscription_Expired") {
      _handleSubscriptionExpired();
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(
      String? title, String? body, Map<String, dynamic> payload) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_sound_channel', // must match created channel
      'Default Sound Notifications',
      channelDescription: 'Plays default notification sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // default sound
      enableVibration: true
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      title,
      body,
      notificationDetails,
      payload: jsonEncode(payload),
    );
  }
}
void _handleSubscriptionExpired() async {
  successToast("Your subscription has expired.");

  // Wait 2 seconds before logout (so user sees message)
  await Future.delayed(const Duration(seconds: 2));
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(AppString.authToken);
  await prefs.remove(AppString.uid);
  await prefs.remove(AppString.playerLimit);
  Get.offAllNamed(AppRouter.login);
}