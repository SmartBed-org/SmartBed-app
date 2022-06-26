import 'package:smart_bed/device_uid.dart';

class FallDetection {
  final String roomNumber;
  final String bedNumber;

  // standard constructor
  const FallDetection(
      {required this.roomNumber, required this.bedNumber});

  FallDetection.fromJson(Map json)
      : this(
      roomNumber: json['room number'],
      bedNumber: json['bed number']);

  Map<String, dynamic> toJson() {
    return {
      'room number': roomNumber,
      'bed number': bedNumber,
    };
  }
}
