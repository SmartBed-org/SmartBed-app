import 'package:flutter/material.dart';
import 'package:smart_bed/fall_detection.dart';
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
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen()),
                        (route) => false);
              },
              icon: Icon(Icons.arrow_back,
                  semanticLabel: 'Back button'))
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
                        style: TextStyle(fontSize: 32)),
                  ),
                  Expanded(
                    child: Text("Bed: ${fallDetection.bedNumber}",
                        style: TextStyle(fontSize: 32)),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
            Expanded(
                child: Column(
              children: [
                Text("Was it a false alarm?", style: TextStyle(fontSize: 32)),
                Spacer(),
                Row(
                  children: [
                    // Spacer(),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                          onPressed: () => {},
                          child: Text('Yes', style: TextStyle(fontSize: 32))),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 5,
                      child: OutlinedButton(
                          onPressed: () => {},
                          child: Text('No', style: TextStyle(fontSize: 32))),
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
