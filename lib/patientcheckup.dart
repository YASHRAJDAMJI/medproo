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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEEE2DE), // Set the background color of the app bar
        title: Text('Patient Checkup'), // Set the title of the app bar
      ),
      backgroundColor: Color(0xFFEEE2DE), // Set the background color of the scaffold
      key: _scaffoldKey,
      body: Container(
        color: Color(0xFFF3EEEA), // Set the background color of the container
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20.0), // Add padding to the container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Set the border radius to make the corners rounded
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Add shadow color with opacity
                        spreadRadius: 5, // Set the spread radius
                        blurRadius: 7, // Set the blur radius
                        offset: Offset(0, 3), // Set the shadow offset
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _aadharController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Aadhar Number',
                          hintText: 'Enter Aadhar Number', // Add placeholder text
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Set the padding for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set the border radius for the text field
                          ),
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
                          hintText: 'Enter Secret Key', // Add placeholder text
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Set the padding for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set the border radius for the text field
                          ),
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
                          if (_formKey.currentState!.validate()) {
                            _checkCredentials();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFEA906C), // Set the background color of the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Set the border radius to make the corners rounded
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          child: Text(
                            'Check History',
                            style: TextStyle(
                              color: Colors.black, // Set the text color of the button
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
