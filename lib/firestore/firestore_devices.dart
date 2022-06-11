import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:smart_bed/device.dart';

class FirestoreDevices {
  final CollectionReference _devices;

  FirestoreDevices.instance()
      : _devices = FirebaseFirestore.instance.collection('Devices');

  Future setDevices(Device device) async {
    await _devices.doc(device.uid.uid).set({'Device': device.toJson()});
  }

  Future<Device> getDevices(String deviceUID) async {
    return Device.fromJson((await _devices.doc(deviceUID).get()).get('Device'));
  }
}
