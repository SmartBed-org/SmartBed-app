import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_employee.dart';
import 'firestore_registration_token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Smart Bed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool is_working = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        } else if (snapshot.connectionState == ConnectionState.done) {
          is_working = snapshot.requireData;

          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  onPressed: () async {
                    setState(() => is_working = !is_working);
                    await FirestoreEmployee.instance().setRegistrationToken(
                        FirebaseAuth.instance.currentUser!.uid, is_working);
                  },
                  child: is_working
                      ? const Text(
                          'Stop',
                        )
                      : const Text(
                          'Start',
                        )),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<bool> initializeApp() async {
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
