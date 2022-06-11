
class DeviceUID {
  final String uid;

  // standard constructor
  const DeviceUID({required this.uid});

  DeviceUID.fromJson(Map json)
      : this(uid: json['uid']);

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
    };
  }
}
