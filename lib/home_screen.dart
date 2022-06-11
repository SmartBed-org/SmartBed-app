import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_bed/device_screens.dart';
import 'package:smart_bed/device_uid.dart';
import 'package:smart_bed/firestore/firestore_employee.dart';
import 'package:smart_bed/qrscanner_device.dart';

import 'device.dart';

class HomeScreen extends StatefulWidget {
  bool is_working = false;

  HomeScreen({Key? key, required this.is_working}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  // final DeviceUID? result = await Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //         builder: (context) => const QRScannerDeviceScreen()));

                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QRScannerDeviceScreen()));

                  // if (result != null) {
                  //   Device device1 = await FirestoreDevices.instance()
                  //       .getDevices(result.uid);
                  //
                  //   await Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) =>
                  //           DeviceScreen(isNewDevice: false, device: device1)));
                  //
                  //   // final prescription = PatientServices
                  //   //     .instance.currentPatient!
                  //   //     .tryFindPrescriptionByName(
                  //   //     result.medicine.name);
                  //   // if (prescription != null) {
                  //   //   await Navigator.of(context)
                  //   //       .push(MaterialPageRoute(
                  //   //       builder: (context) => PrescriptionScreen(
                  //   //         prescription: prescription,
                  //   //       )));
                  // }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded)),
            IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeviceScreen(
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
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24)),
                  onPressed: () async {
                    setState(() => widget.is_working = !widget.is_working);
                    await FirestoreEmployee.instance().setWorking(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.is_working);
                  },
                  child: widget.is_working
                      ? const Text(
                          'End\nShift',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50.0),
                        )
                      : const Text(
                          'Enter\nShift',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50.0),
                        )),
            ),
            const Center(child: const Text('By Smart Bed team'))
          ],
        ),
      ),
    );
  }
}
