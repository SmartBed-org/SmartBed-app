import 'package:flutter/material.dart';
import 'package:smart_bed/fall_detection.dart';
import 'package:smart_bed/firestore/firestore_alarms.dart';
import 'package:smart_bed/home_screen.dart';

class FallDetectionScreen extends StatelessWidget {

  final FallDetection fallDetection;

  const FallDetectionScreen({Key? key, required this.fallDetection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Bed"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen()),
                        (route) => false);
              },
              icon: const Icon(Icons.arrow_back))
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Spacer(),
                  const Expanded(
                    child: Text(
                      'Fall detected',
                      style: TextStyle(fontSize: 45),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: Text("Room: ${fallDetection.roomNumber}",
                        style: const TextStyle(fontSize: 32)),
                  ),
                  Expanded(
                    child: Text("Bed: ${fallDetection.bedNumber}",
                        style: const TextStyle(fontSize: 32)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            Expanded(
                child: Column(
              children: [
                const Text("Was it a false alarm?", style: TextStyle(fontSize: 32)),
                const Spacer(),
                Row(
                  children: [
                    // Spacer(),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                          onPressed: () {
                            // TODO: 21 is constant
                            FirestoreAlarms.instance().setAlarmCorrectness('21', true);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen()),
                                    (route) => false);
                          },
                          child: const Text('Yes', style: TextStyle(fontSize: 32))),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 5,
                      child: OutlinedButton(
                          onPressed: () {
                            // TODO: 21 is constant
                            FirestoreAlarms.instance().setAlarmCorrectness('21', false);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen()),
                                    (route) => false);
                          },
                          child: const Text('No', style: TextStyle(fontSize: 32))),
                    ),
                    // Spacer()
                  ],
                ),
              ],
            )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
