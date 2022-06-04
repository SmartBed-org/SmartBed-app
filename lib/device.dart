
class Device {
  String uid;

  // standard constructor
  Device({required this.uid});

  Device.fromJson(Map json)
      : this(uid: json['uid']);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
    };
  }
}
