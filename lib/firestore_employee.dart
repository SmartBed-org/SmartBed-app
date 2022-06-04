import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreEmployee {
  CollectionReference _employees;

  FirestoreEmployee.instance()
      : _employees = FirebaseFirestore.instance.collection('Employees');

  Future setRegistrationToken(String userUid, bool working) async {
    await _employees.doc(userUid).set({'working' : working});
  }

  Future<bool> isWorking(String userUid) async {
    var a = await _employees.doc(userUid).get();
    return a.get('working');
  }
}
