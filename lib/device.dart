import 'package:smart_bed/device_uid.dart';

class Device {
  final DeviceUID uid;
  final String roomNumber;
  final String bedNumber;

  // standard constructor
  const Device(
      {required this.uid, required this.roomNumber, required this.bedNumber});

  Device.fromJson(Map json)
      : this(
            uid: DeviceUID.fromJson(json['uid']),
            roomNumber: json['room number'],
            bedNumber: json['bed number']);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid.toJson(),
      'room number': roomNumber,
      'bed number': bedNumber,
    };
  }
}
