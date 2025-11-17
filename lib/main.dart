import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // ✅ Initialize Notifications
  await NotificationService.initialize();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  // ✅ Check if user is logged in, and save their FCM token
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("🔑 Logged-in user detected: ${user.uid}");
    await NotificationService.saveUserToken(
      uid: user.uid,
      isProvider: false, // this is the USER app side
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            useMaterial3: true,
          ),
          home: FirebaseAuth.instance.currentUser != null
              ? const BottomNavBar()
              : const LoginScreen(),
        );
      },
    );
  }
}
