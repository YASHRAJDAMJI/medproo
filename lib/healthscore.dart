import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthScoreScreen extends StatefulWidget {
  @override
  _HealthScoreScreenState createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends State<HealthScoreScreen> {
  User? _user;
  String symptoms = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      setState(() {
        _user = auth.currentUser;
      });
      try {
        // Access Firestore collection for the user's symptoms
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

        // Retrieve the symptoms from the document
        setState(() {
          symptoms = userDoc['symptoms'];
          print(symptoms);
        });
      } catch (error) {
        print('Error fetching symptoms: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User Symptoms:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: symptoms.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(symptoms[index]),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HealthScoreScreen(),
  ));
}
