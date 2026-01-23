import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../Models/ProviderModel.dart';
import '../main.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  static const String projectId = "g-plug-home-services";
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) {
          debugPrint("❌ Notification tapped with NULL payload");
          return;
        }

        final data = jsonDecode(response.payload!);
        debugPrint("👆 Local notification tapped: $data");

        _handleNavigation(data);
      },
    );

    /// Background / terminated
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    /// App opened from background (system notification)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("📲 System notification tapped: ${message.data}");
      _handleNavigation(message.data);
    });

    /// Foreground (do nothing – avoid duplicate notifications)
    FirebaseMessaging.onMessage.listen((_) {});
  }

  /// TERMINATED STATE
  static Future<void> checkInitialMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      debugPrint("🚀 App opened from terminated: ${message.data}");
      _handleNavigation(message.data);
    }
  }

  /// BACKGROUND HANDLER
  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await _showLocalNotification(message);
  }

  /// SHOW LOCAL NOTIFICATION
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    debugPrint("📩 Local notification DATA: ${message.data}");

    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data), // 🔥 REQUIRED
    );
  }

  /// NAVIGATION HANDLER (SAFE)
  static void _handleNavigation(Map<String, dynamic> data) async {
    if (data['type'] != 'chat') return;

    final providerId = data['providerId'];
    final chatRoomId = data['chatRoomId'];

    if (providerId == null || providerId.toString().isEmpty) {
      debugPrint("❌ providerId missing in notification");
      return;
    }

    if (chatRoomId == null || chatRoomId.toString().isEmpty) {
      debugPrint("❌ chatRoomId missing");
      return;
    }

    try {
      // 🔹 Fetch provider details from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('Provider')
          .doc(providerId)
          .get();

      if (!doc.exists) {
        debugPrint("❌ Provider not found in Firestore: $providerId");
        return;
      }

      final provider = ProviderModel.fromMap(doc.data()!, doc.id);

      // 🔹 Navigate to ChatWithProvider with full ProviderModel
      navigatorKey.currentState?.pushNamed(
        '/chat-with-provider',
        arguments: {
          'provider': provider,
          'chatRoomId': chatRoomId,
        },
      );
    } catch (e) {
      debugPrint("❌ Error fetching provider for notification: $e");
    }
  }



  /// SAVE FCM TOKEN
  static Future<void> saveUserToken({
    required String uid,
    required bool isProvider,
  }) async {
    final token = await _fcm.getToken();
    if (token == null) return;

    final collection = isProvider ? 'Provider' : 'User';

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .set({'fcmToken': token}, SetOptions(merge: true));

    debugPrint("💾 Token saved for $collection/$uid");
  }

  /// SEND PUSH (HTTP v1)
  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
    required String receiverId,
    required String chatRoomId,
  }) async {
    debugPrint("📤 Sending notification → $receiverId / $chatRoomId");

    final serviceAccount =
    await rootBundle.loadString('assets/service-account.json');

    final creds = auth.ServiceAccountCredentials.fromJson(
      jsonDecode(serviceAccount),
    );

    final client = await auth.clientViaServiceAccount(creds, _scopes);

    final message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "type": "chat",
          "receiverId": receiverId,
          "chatRoomId": chatRoomId,
        },
        "android": {
          "priority": "high"
        }
      }
    };

    final uri = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

    await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );

    client.close();
  }
}
