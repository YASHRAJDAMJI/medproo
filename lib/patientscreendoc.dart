import 'package:aashray_veriion3/uplodedoc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'featchdoc.dart';
import 'loginmess.dart';

class ptscdoc extends StatefulWidget {
  final String uid; // Add UID as a parameter

  ptscdoc({required this.uid}); // Constructor with UID parameter

  @override
  _ptscdoc createState() => _ptscdoc();
}

class _ptscdoc extends State<ptscdoc> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 171, 0),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Handle the refresh action
              // fetchFirebaseCounts();
            },
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginMess(),
                ),
              );

              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.leave_bags_at_home),
          )
        ],
        title: Text('Add Record'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2B2A4C),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dock),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return Uplodedoc(uid: widget.uid);
      case 1:
        return FetchDataScreen(uid:widget.uid);
      default:
        return Container();
    }
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter Name',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter Diseases',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter Symptoms',
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Save data
                },
                child: Text('Save Data'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Upload file
                },
                child: Text('Upload File'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Select Image
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFB31312),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Select Image',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
