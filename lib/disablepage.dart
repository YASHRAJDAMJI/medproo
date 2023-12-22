import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'askuser.dart';
import 'login.dart';

class DisabledPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Disabled'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Your account is disabled.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please contact the administrator for assistance.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(

                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => askuser(),
                    ),
                  );

                  await FirebaseAuth.instance.signOut();

              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
