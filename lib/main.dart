import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_bed/device.dart';
import 'package:smart_bed/qrscanner_device.dart';
import 'device_screens.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_employee.dart';
import 'firestore_registration_token.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

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
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
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
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
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
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
      home: FutureBuilder(
          future: initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Text(snapshot.error.toString(),
                          textDirection: TextDirection.ltr)));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return MyHomePage(is_working: snapshot.requireData);
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

class MyHomePage extends StatefulWidget {
  bool is_working = false;

  MyHomePage({Key? key, required this.is_working}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Smart Bed'),
          actions: [
            IconButton(
                onPressed: () async {
                  final Device? result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const QRScannerDeviceScreen()));

                  // if (result != null) {
                  //   final prescription = PatientServices
                  //       .instance.currentPatient!
                  //       .tryFindPrescriptionByName(
                  //       result.medicine.name);
                  //   if (prescription != null) {
                  //     await Navigator.of(context)
                  //         .push(MaterialPageRoute(
                  //         builder: (context) => PrescriptionScreen(
                  //           prescription: prescription,
                  //         )));
                  //   } else {
                  //     await PatientServices.instance.currentPatient!
                  //         .addNewPrescriptions(result);
                  //     if (MediaQuery.of(context).accessibleNavigation) {
                  //       await SemanticsService.announce(
                  //           result.medicine.name +
                  //               " has been added to the list of prescriptions.",
                  //           TextDirection.ltr);
                  //     }
                  //   }
                  // }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded)),
            IconButton(
                onPressed: () async {
                  final Device? result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => DeviceScreen(is_new_device: true,)));
                },
                icon: const Icon(Icons.add_circle_outline_rounded)),
            IconButton(
              icon: const Icon(
                Icons.info_rounded,
              ),
              onPressed: () => showAboutDialog(
                context: context,
                // applicationIcon: Image(
                //   image: AssetImage('graphics/icon/icon.png'),
                //   height: 50,
                //   width: 50,
                // ),
                applicationName: 'Smart Bed',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2022 Smart Bed team',
              ),
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: widget.is_working ? Colors.red : Colors.green,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24)),
                  onPressed: () async {
                    setState(() => widget.is_working = !widget.is_working);
                    await FirestoreEmployee.instance().setRegistrationToken(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.is_working);
                  },
                  child: widget.is_working
                      ? const Text(
                          'Stop',
                          style: TextStyle(fontSize: 50.0),
                        )
                      : const Text(
                          'Start',
                          style: TextStyle(fontSize: 50.0),
                        )),
            ),
            Center(child: Text('By Smart Bed team'))
          ],
        ),
      ),
    );
  }
}
