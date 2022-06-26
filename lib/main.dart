import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_bed/fall_detection.dart';
import 'package:smart_bed/firestore/firestore_employee.dart';
import 'package:smart_bed/home_screen.dart';
import 'package:smart_bed/firebase_options.dart';
import 'fall_detection_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:smart_bed/firestore/firestore_registration_token.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Bed',
      theme: FlexThemeData.light(
        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
        scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
        scheme: FlexScheme.blue,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/FallDetectionScreen') {
          final payload = settings.arguments as String?;

          if (payload != null) {
            return MaterialPageRoute(
                builder: (BuildContext context) => FallDetectionScreen(
                    fallDetection:
                        FallDetection.fromJson(json.decode(payload))));
          }
        }
      },
      home: FutureBuilder(
          future: initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Text(snapshot.error.toString(),
                          textDirection: TextDirection.ltr)));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.requireData;
            } else {
              return Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Image(height: 250, width: 250,
                    image: AssetImage(
                        'assets/logo.png'),
                  ),
                  CircularProgressIndicator(),
                ],
              ));
            }
          }),
    );
  }

  Future<Widget> initializeApp() async {
    Widget startScreen;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await signInAnonymously();
    await manageToken();

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await navigatorKey.currentState!.pushNamed('/FallDetectionScreen',
          arguments: jsonEncode(FallDetection(
              roomNumber: message.data["room"],
              bedNumber: message.data["bed"])));
    });

    await initLocalNotifications();

    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    HomeScreen.isWorking = await FirestoreEmployee.instance()
        .isWorking(FirebaseAuth.instance.currentUser!.uid);

    if (remoteMessage != null) {
      startScreen = FallDetectionScreen(
          fallDetection: FallDetection(
              roomNumber: remoteMessage.data["room"],
              bedNumber: remoteMessage.data["bed"]));
    } else {
      startScreen = HomeScreen();
    }

    return startScreen;
  }

  Future<void> initLocalNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description: "This channel is used for important notifications.", // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher")),
        onSelectNotification: ((payload) async {
      // if (payload != null) {
      await navigatorKey.currentState!
          .pushNamed('/FallDetectionScreen', arguments: payload);
      // }
    }));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'default_notification_channel_id', 'your channel name',
                  channelDescription: 'your channel description',
                  fullScreenIntent: true,
                  icon: "@mipmap/ic_launcher",
                  priority: Priority.max,
                  importance: Importance.max),
            ),
            payload: jsonEncode(FallDetection(
                roomNumber: message.data["room"],
                bedNumber: message.data["bed"])));
      }
    });
  }

  Future<void> manageToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirestoreRegistrationToken.instance().setRegistrationToken(
        FirebaseAuth.instance.currentUser!.uid, fcmToken!);

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      FirestoreRegistrationToken.instance().setRegistrationToken(
          FirebaseAuth.instance.currentUser!.uid, fcmToken);
    }).onError((err) {
      // Error getting token.
    });
  }

  Future<void> signInAnonymously() async {
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        await FirestoreEmployee.instance()
            .setWorking(FirebaseAuth.instance.currentUser!.uid, false);
        print("Signed in with temporary account.");
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
      }
    }
  }
}
