import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:smart_bed/device.dart';

class FirestoreAlarms {
  final CollectionReference _alarms;

  FirestoreAlarms.instance()
      : _alarms = FirebaseFirestore.instance.collection('Alarms');

  Future setAlarmCorrectness(String deviceUID, bool isFalseAlarm) async {
    String fieldName;

    if (isFalseAlarm) {
      fieldName = 'False Alarms';
    } else {
      fieldName = 'True Alarms';
    }

    _alarms.doc(deviceUID).update({
      fieldName: FieldValue.arrayUnion([Timestamp.now()])
    });
  }
}
