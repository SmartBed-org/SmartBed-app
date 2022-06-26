import 'package:flutter/material.dart';
import 'package:smart_bed/fall_detection.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FallDetection data = ModalRoute.of(context)!.settings.arguments as FallDetection;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Bed"),
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
                    child: Text("Room: ${data.roomNumber}",
                        style: TextStyle(fontSize: 32)),
                  ),
                  Expanded(
                    child: Text("Bed: ${data.bedNumber}",
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
