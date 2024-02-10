import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loginmess.dart';

void main() {
  runApp(MaterialApp(
    home: MessProfileScreen(),
  ));
}

class MessProfileScreen extends StatefulWidget {
  @override
  _MessProfileScreenState createState() => _MessProfileScreenState();
}

class _MessProfileScreenState extends State<MessProfileScreen> {
  late User _user;
  late String _userName = '';
  late String _userEmail = '';
  late String _messName = '';
  late String _userPhone = '';
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _userName = userSnapshot.get('name') ?? '';
          _userEmail = userSnapshot.get('email') ?? '';

          _userPhone = userSnapshot.get('phone') ?? '';
          _userId = _user.uid;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginMess(),
        ),
      );

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfffff0dc), // PeachPuff color
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: CircleAvatar(
                backgroundColor: Color(0xfffff0dc),
                radius: 80.0,
                backgroundImage: AssetImage('assets/student.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Hello                                               ',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _userEmail,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      _messName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _userPhone,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {

                        _signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background color
                        onPrimary: Colors.white, // text color
                      ),
                      child: Text('Logout'),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
