import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRegistrationToken {
  CollectionReference _registrationToken;

  FirestoreRegistrationToken.instance()
      : _registrationToken = FirebaseFirestore.instance.collection('Registration Token');

  Future setRegistrationToken(String userUid, String registrationToken) async {
    await _registrationToken.doc(userUid).set({'registrationToken' : registrationToken});
  }
}
