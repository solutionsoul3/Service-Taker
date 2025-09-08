import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talk/Views/auth/login_screen.dart';
import 'package:talk/firebase_options.dart';

import 'Views/BottomNav/bottomnav.dart';
import 'Views/HomeScreen/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          home: FirebaseAuth.instance.currentUser != null
              ? const BottomNavBar() // User already logged in
              : const LoginScreen(), // User not logged in
        );
      },
    );
  }
}
