import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static const String projectId = "g-plug-home-services";
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // 🔔 Ask for notification permissions
    final settings = await _fcm.requestPermission(alert: true, badge: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");
    } else {
      print("⚠️ Notification permission denied");
    }

    // 🧩 Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);

    // ⚙️ Handle background and terminated notifications
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // ⚙️ Handle when user taps on notification (app opened from background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📩 Notification clicked: ${message.notification?.title}");
    });

    // ⚙️ Foreground messages — don't show local notifications here
    FirebaseMessaging.onMessage.listen((message) {
      print("💬 Message received in foreground → skipping notification");
      // ❌ Do not call _showLocalNotification() here
    });
  }


  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("📨 Background message: ${message.notification?.title}");
    await _showLocalNotification(message); // ✅ Keep this so notification shows
  }


  /// ✅ Save real FCM token (no prefixes)
  static Future<void> saveUserToken({
    required String uid,
    required bool isProvider,
  }) async {
    try {
      final token = await _fcm.getToken();
      if (token == null) {
        print("⚠️ Failed to get FCM token");
        return;
      }

      final collection = isProvider ? 'Provider' : 'User';
      await FirebaseFirestore.instance.collection(collection).doc(uid).set({
        'fcmToken': token,
        'lastUpdated': DateTime.now(),
      }, SetOptions(merge: true));

      print("💾 Saved FCM token for $collection: $token");
    } catch (e) {
      print("❌ Error saving token: $e");
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

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
    );
  }

  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final serviceAccountJson = await rootBundle.loadString('assets/service-account.json');
      final creds = auth.ServiceAccountCredentials.fromJson(jsonDecode(serviceAccountJson));
      final client = await auth.clientViaServiceAccount(creds, _scopes);

      final message = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "android": {"priority": "high"},
        }
      };


      final response = await client.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print("✅ Push notification sent successfully!");
      } else {
        print("❌ Failed to send notification: ${response.statusCode}");
        print("Response: ${response.body}");
      }

      client.close();
    } catch (e) {
      print("❌ Error sending notification: $e");
    }
  }
}
