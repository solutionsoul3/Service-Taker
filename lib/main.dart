import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Services/notification_service.dart';
import 'Views/BottomNav/bottomnav.dart';
import 'Views/ChatScreen/chat_with_provider.dart';
import 'Views/auth/login_screen.dart';
import 'Models/ProviderModel.dart';
import 'firebase_options.dart';

/// 🔥 REQUIRED FOR NOTIFICATION NAVIGATION
final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

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
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'App',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const AppEntry(),

            '/chat-with-provider': (context) {
              final args =
                  ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

              final providerArg = args['provider'] as ProviderModel?;

              if (providerArg == null) {
                return Scaffold(
                  body: Center(child: Text("❌ Provider data missing")),
                );
              }

              return ChatWithProvider(
                provider: providerArg,
                chatRoomId: args['chatRoomId'],
                receiverId: providerArg.id,
              );
            },

          },
        );

      },
    );
  }
}

/// 🔑 SINGLE ENTRY POINT
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  bool _handledInitialNav = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_handledInitialNav) return;
      _handledInitialNav = true;

      await NotificationService.checkInitialMessage();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await NotificationService.saveUserToken(
          uid: user.uid,
          isProvider: false,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? const BottomNavBar()
        : const LoginScreen();
  }
}
