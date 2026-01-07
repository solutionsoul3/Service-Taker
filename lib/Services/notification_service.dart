// lib/Services/notification_service.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Replace with your Firebase project ID (match google-services.json)
  static const String projectId = "g-plug-home-services";
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  /// If you are testing on a single physical device and want distinct tokens
  /// for "User" and "Provider" records, set this to true. Set to `false` in production.
  static bool simulateTokens = false;

  /// Initialize FCM and local notifications
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");
    } else {
      print("⚠️ Notification permission denied");
    }

    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);

    // ✅ Handle notifications when the app is in background or terminated
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // ✅ Handle notification tap when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📩 Notification clicked: ${message.notification?.title}");
    });

    // ❌ Do NOT show notifications in foreground
    FirebaseMessaging.onMessage.listen((message) {
      print("💬 Provider in foreground → skipping local notification.");
      // do nothing here to suppress foreground notifications
    });
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("📨 Background message received: ${message.notification?.title}");
    await _showLocalNotification(message); // ✅ show notification here
  }

  /// Save the current logged-in device token to Firestore under the correct collection
  /// `isProvider == true` -> Provider collection, else User collection.
  /// ✅ Save FCM token safely by role (User vs Provider)
  static Future<void> saveUserToken({
    required String uid,
    required bool isProvider,
  }) async {
    try {
      final token = await _fcm.getToken();
      if (token == null) {
        print("⚠️ No FCM token available for $uid");
        return;
      }

      final collection = isProvider ? 'Provider' : 'User';

      // ✅ Save token only in the correct collection
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));

      print("💾 FCM token saved for $collection → $uid");
    } catch (e) {
      print("❌ Error saving FCM token: $e");
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

  /// Send push notification using FCM HTTP v1 and service account credentials loaded from assets.
  /// Returns true if successfully sent, false otherwise.
  static Future<bool> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final serviceAccountJson =
          await rootBundle.loadString('assets/service-account.json');
      final creds = auth.ServiceAccountCredentials.fromJson(
        jsonDecode(serviceAccountJson),
      );

      final client = await auth.clientViaServiceAccount(creds, _scopes);

      final message = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "android": {"priority": "high"},
        }
      };

      final uri = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );

      client.close();

      if (response.statusCode == 200) {
        print("✅ Push notification sent successfully!");
        return true;
      } else {
        print("❌ Failed to send notification: ${response.statusCode}");
        print("Response: ${response.body}");

        // Parse response, if UNREGISTERED, remove token from Firestore
        try {
          final bodyJson = jsonDecode(response.body);
          final error = bodyJson['error'];
          final details = error != null ? error['details'] : null;
          if (details is List) {
            for (final d in details) {
              if (d['@type']?.toString().contains('FcmError') == true &&
                  d['errorCode'] == 'UNREGISTERED') {
                // Remove token occurrences from both collections
                await _removeTokenFromFirestore(token);
                print("🗑️ Removed UNREGISTERED token from Firestore: $token");
                break;
              }
            }
          }
        } catch (_) {
          // ignore json parse issues
        }

        return false;
      }
    } catch (e) {
      print("❌ Error sending notification: $e");
      return false;
    }
  }

  /// Search both User and Provider collections for documents with the token and delete the token field.
  static Future<void> _removeTokenFromFirestore(String token) async {
    final firestore = FirebaseFirestore.instance;

    // Search User collection
    final userQuery = await firestore
        .collection('User')
        .where('fcmToken', isEqualTo: token)
        .get();

    for (final d in userQuery.docs) {
      await d.reference.update({'fcmToken': FieldValue.delete()});
      print("🗑️ Cleared fcmToken for User/${d.id}");
    }

    // Search Provider collection
    final providerQuery = await firestore
        .collection('Provider')
        .where('fcmToken', isEqualTo: token)
        .get();

    for (final d in providerQuery.docs) {
      await d.reference.update({'fcmToken': FieldValue.delete()});
      print("🗑️ Cleared fcmToken for Provider/${d.id}");
    }
  }
}
