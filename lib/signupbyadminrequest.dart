import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupByHadminRequest extends StatelessWidget {
  final String phoneNumber = "8856887702"; // Replace with the actual phone number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'To sign up, you need to contact the Aashray Team:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Email: aashraysupport@gmail.com\nPhone: $phoneNumber',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _makePhoneCall(phoneNumber);
              },
              child: Text('Make a Call'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to make a phone call
  _makePhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

