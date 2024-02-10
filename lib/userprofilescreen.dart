import 'package:aashray_veriion3/LoginForm.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: UserProfileScreen(),
  ));
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _user;
  late String _userName = ''; // Initialize to an empty string

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _userName = userSnapshot.get('name');
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
          builder: (context) => LoginForm(),
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
        color: Color(0xFFECECEC), // Background color
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),
                CircleAvatar(
                  backgroundColor: Color(0xFFECECEC),
                  radius: 80.0,
                  backgroundImage: AssetImage('assets/student.png'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2A4C),
                  ),
                ),
                SizedBox(height: 16.0),
                _buildLabel('Name', _userName),
                SizedBox(height: 16.0),
                _buildLabel('User ID', _user.uid),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFB31312), // Button background color
                    onPrimary: Colors.white, // Button text color
                    shadowColor: Colors.black,
                    elevation: 5,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color(0xFFB31312), // Border color
          width: 2.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xFFB31312),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2A4C),
            ),
          ),
        ],
      ),
    );
  }
}
