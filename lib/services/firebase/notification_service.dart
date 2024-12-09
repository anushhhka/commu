import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyoo/config/themes/app_colors.dart';

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    const androidInitialize = AndroidInitializationSettings(
      'logo',
    );
    DarwinInitializationSettings iosInitialize =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print(message.notification!.title);
      // print(message.data.toString());

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        foregroundMessageIOS();
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("community", "community",
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            icon: 'logo',
            color: AppColors.primary,
            playSound: true);

    DarwinNotificationDetails iosPlatforrrmChannelSpecifies =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatforrrmChannelSpecifies);

    await _flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, platformChannelSpecifics);
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // When app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleMessage(context, message);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    String link = message.data['link'];
    // print('Link: $link');
    Uri uri = parseIncomingLink(link);

    // Navigate to the route specified by the path
    if (uri.queryParameters == null || uri.queryParameters.isEmpty) {
      Navigator.of(context).pushNamed(
        Uri(
          path: uri.path,
        ).toString(),
      );
    } else {
      Navigator.of(context).pushNamed(
        Uri(
          path: uri.path,
          queryParameters: uri.queryParameters,
        ).toString(),
      );
    }
  }

  static Uri parseIncomingLink(String link) {
    Uri uri = Uri.parse(link);

    // Extract the path and query parameters
    String path = uri.path;
    Map<String, String> queryParams = uri.queryParameters;

    // print('Path: $path');
    // print('Query Parameters: $queryParams');

    // Check if the path starts with '/chatrooms/chat'
    if (path.startsWith('/chatrooms/chat')) {
      // Replace '/chatrooms/chat' with '/feeds/chatrooms'
      uri = uri.replace(path: '/feeds/chatrooms');
    }

    return uri;
  }

  static Future<String?> getMobileToken() async {
    var mtoken = await FirebaseMessaging.instance.getToken();

    if (mtoken!.isNotEmpty) {
      return mtoken;
    }
    return null;
  }

  static Future<String?> listenForTokenRefreh() async {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((String mobileToken) async {});
    return null;
  }

  Future foregroundMessageIOS() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  //   static void sendPushMessage(
  //     List<String> mtokenUsers, String body, String title) async {
  //   try {
  //   var response =  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=AAAAwVdgMf4:APA91bEY7sdp1ockRVPjHsh4ofufPek6l_4Y_WSigXTCVNsRdfbnlfh9xp1xvAAq7hA4FWnihQwWhNIqULH8zzH95HAVFkyt9AdBS_lZAECqm4Wg_SOPEFDJ3msC7tzmv9j4tfVfJ2Ke'
  //         },
  //         body: jsonEncode(<String, dynamic>{
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'status': 'done',
  //             'body': body,
  //             'title': title,
  //           },
  //           "notification": <String, dynamic>{
  //             "title": title,
  //             "body": body,
  //             "android_channel_id": "heyoo",
  //             "sound": "default"
  //           },
  //           "registration_ids": mtokenUsers,
  //         }));
  //       print(response.statusCode);
  //       print(response.body);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
