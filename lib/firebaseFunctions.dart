import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String role,String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'role':role,'email': email, 'name': name});

  }
}
