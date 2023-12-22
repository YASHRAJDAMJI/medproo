import 'package:aashray_veriion3/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aashray_veriion3/firebaseFunctions.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static Future<void> signupUser(String role, String email, String password, String name, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        ),
      );

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);

      try {
        await FirebaseAuth.instance.currentUser!.updatePhotoURL("https://www.google.com/url?sa=i&url=http%3A%2F%2Fdamjisb.blogspot.com%2F&psig=AOvVaw1lYi-fwcej14aIEVfXhnbj&ust=1695385874970000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCOis2Nrau4EDFQAAAAAdAAAAABAE");
        print("Photo URL updated successfully!");
      } catch (e) {
        print("Error updating photo URL: $e");
      }

      await FirestoreServices.saveUser(role, name, email, userCredential.user!.uid);

      // Function to save data to SharedPreferences
      Future<void> saveDataToSharedPreferences(String key, String value) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, value);
      }

      saveDataToSharedPreferences('role', 'user');

      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the progress indicator

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the progress indicator

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the progress indicator

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> signinUser(String role, String email, String password, BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Logging in...'),
            ],
          ),
        ),
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the progress indicator

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are Logged in')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the progress indicator

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }
}
