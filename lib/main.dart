import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Services/notification_service.dart';
import 'Views/BottomNav/bottomnav.dart';
import 'Views/auth/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize notifications (NO navigation here)
  await NotificationService.initialize();

  // ✅ App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) {
        return MaterialApp(
          // navigatorKey: navigatorKey, // 🔥 REQUIRED
          debugShowCheckedModeBanner: false,
          title: 'App',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const AppEntry(), // 🔥 DO NOT put BottomNav directly
        );
      },
    );
  }
}

/// 🔑 SINGLE ENTRY POINT (THIS FIXES YOUR ISSUE)
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();

    /// 🔥 Handle notification navigation AFTER UI is ready
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await NotificationService.checkInitialMessage();
    //
    //   // ✅ Save FCM token AFTER login
    //   final user = FirebaseAuth.instance.currentUser;
    //   if (user != null) {
    //     await NotificationService.saveUserToken(
    //       uid: user.uid,
    //       isProvider: false, // USER app side
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? const BottomNavBar()
        : const LoginScreen();
  }
}
