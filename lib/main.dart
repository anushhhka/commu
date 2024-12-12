import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/dark_theme.dart';
import 'package:heyoo/firebase_options.dart';
import 'package:heyoo/utils/my_custom_messages.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:heyoo/screens/splash/splash_screen.dart';
import 'package:heyoo/services/firebase/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  timeago.setLocaleMessages(
    'en',
    MyCustomMessages(),
  );
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // print(message.notification!.title);
  // print(message.data.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: dark_theme(),
      home: const SplashScreen(),
    );
  }
}
