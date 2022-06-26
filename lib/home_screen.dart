import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_bed/fall_detection_screen.dart';
import 'package:smart_bed/device_configuration_screen.dart';
import 'package:smart_bed/device_uid.dart';
import 'package:smart_bed/fall_detection.dart';
import 'package:smart_bed/firestore/firestore_devices.dart';
import 'package:smart_bed/firestore/firestore_employee.dart';
import 'package:smart_bed/qrscanner_device.dart';

import 'device.dart';

class HomeScreen extends StatefulWidget {
  // TODO: more elegant (changed to static for 1 load from firebase)
  static bool isWorking = false;

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Smart Bed'),
          actions: [
            IconButton(
                onPressed: () async {
                  final DeviceUID? result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const QRScannerDeviceScreen()));

                  if (result != null) {
                    Device device1 = await FirestoreDevices.instance()
                        .getDevices(result.uid);

                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DeviceConfigurationScreen(title: 'Device configuration', isNewDevice: false, device: device1)));
                  }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded)),
            IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeviceConfigurationScreen(title: 'Create new barcode',
                            isNewDevice: true,
                          )));
                },
                icon: const Icon(Icons.add_circle_outline_rounded)),
            IconButton(
              icon: const Icon(
                Icons.info_rounded,
              ),
              onPressed: () => showAboutDialog(
                context: context,
                applicationIcon: const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 50,
                  width: 50,
                ),
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
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HomeScreen.isWorking ? Colors.red : Colors.green,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24)),
                  onPressed: () async {
                    setState(() => HomeScreen.isWorking = !HomeScreen.isWorking);
                    await FirestoreEmployee.instance().setWorking(
                        FirebaseAuth.instance.currentUser!.uid,
                        HomeScreen.isWorking);
                  },
                  child: HomeScreen.isWorking
                      ? const Text(
                          'End\nShift',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 57.0),
                        )
                      : const Text(
                          'Enter\nShift',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 57.0),
                        )),
            ),
            const Center(child: Text('By Smart Bed Team',
              style: TextStyle(fontSize: 16.0),))
          ],
        ),
      ),
    );
  }
}
