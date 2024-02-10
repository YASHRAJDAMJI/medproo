import 'package:aashray_veriion3/userpage.dart';
import 'package:aashray_veriion3/userprofilescreen.dart';
import 'package:aashray_veriion3/docs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginForm.dart';
import 'healthscore.dart';

void main() {
  runApp(MaterialApp(
    home: UserScreen(),
  ));
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E8D8),
        //title: Text('Aahar '),
        title: Text('MedPro',
          style: TextStyle(
              color: Color(0xFF9F5D06)
          ),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginForm(),
                ),
              );
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.leave_bags_at_home),
            color: Color(0xFF2B2A4C),
          )
        ],
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2B2A4C),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor:  Color(0xFFFFFFFF),
            label: 'HealthScore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Docs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFF8F0E2),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return HealthScoreScreen();
      case 1:
        return docs();
      case 2:
        return UserProfileScreen();
      default:
        return Container(); // Return a default screen or throw an error
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}



class ImpressionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Aashray WEB page here'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}
