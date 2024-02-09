import 'package:aashray_veriion3/patientscreendoc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class patientcheckup extends StatefulWidget {
  @override
  _patientcheckupState createState() => _patientcheckupState();
}

class _patientcheckupState extends State<patientcheckup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _secretKeyController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff0dc),
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _aadharController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Aadhar Number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Aadhar number is required';
                } else if (value.length != 12 || int.tryParse(value) == null) {
                  return 'Aadhar number must be a 12-digit numeric value';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _secretKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter Secret Key',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Secret key is required';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkCredentials();
              },
              child: Text('Check History'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkCredentials() {
    String aadharNumber = _aadharController.text.trim();
    String secretKey = _secretKeyController.text.trim();

    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      String? matchedUid;
      querySnapshot.docs.forEach((doc) {
        // For each document, check if Aadhar number and secret key match
        if (doc['adharNumber'].toString().trim() == aadharNumber && doc['secretKey'].toString().trim() == secretKey) {
          // If both Aadhar number and secret key match, set matchedUid to the document's UID
          matchedUid = doc.id;
        }
      });

      if (matchedUid != null) {
        // Navigate to the ptscdoc screen and pass the matched UID
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ptscdoc(uid: matchedUid!)),
        );
      } else {
        // Show an error if no match is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect Aadhar number or secret key'),
          ),
        );
      }
    }).catchError((error) {
      print("Failed to get users: $error");
      // Show a snackbar or dialog indicating the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check credentials. Please try again later.'),
        ),
      );
    });
  }


}


// Define your NewScreen widget here
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is the new screen that will be shown after successful authentication
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: Center(
        child: Text('Welcome to the new screen!'),
      ),
    );
  }
}
