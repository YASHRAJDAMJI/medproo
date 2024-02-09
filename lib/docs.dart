import 'package:aashray_veriion3/userpage.dart';
import 'package:flutter/material.dart';

import 'OCR.dart';

class docs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Your screen content goes here',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("buttonpressed");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ocr()),
          );
        },
        icon: Icon(Icons.camera_alt),
        label: Text('Documents'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: docs(),
  ));
}
