import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FirestoreServices {
  static final _random = Random();

  static String _generateSecretKey(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  static saveUser(String role, String name, email, adharNumber, uid) async {
    final secretKey = _generateSecretKey(10); // Generate a 10-character secret key
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'role': role,
      'email': email,
      'name': name,
      'enable': true,
      'adharNumber': adharNumber,
      'secretKey': secretKey, // Save the generated secret key
    });
  }
}
