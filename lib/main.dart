import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_bed/firestore/firestore_employee.dart';
import 'package:smart_bed/home_screen.dart';
import 'package:smart_bed/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:smart_bed/firestore/firestore_registration_token.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: FutureBuilder(
          future: initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Text(snapshot.error.toString(),
                          textDirection: TextDirection.ltr)));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return HomeScreen(is_working: snapshot.requireData);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<bool> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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

    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirestoreRegistrationToken.instance().setRegistrationToken(
        FirebaseAuth.instance.currentUser!.uid, fcmToken!);

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      FirestoreRegistrationToken.instance().setRegistrationToken(
          FirebaseAuth.instance.currentUser!.uid, fcmToken);
    }).onError((err) {
      // Error getting token.
    });

    return await FirestoreEmployee.instance()
        .isWorking(FirebaseAuth.instance.currentUser!.uid);
  }
}
