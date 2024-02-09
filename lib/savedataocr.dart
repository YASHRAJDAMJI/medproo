import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.text),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectImage(),
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitData(),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (_image == null) {
      return;
    }

    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images').child('image.jpg');
    final uploadTask = storageRef.putFile(_image);
    await uploadTask.whenComplete(() => null);

    // Get download URL
    final imageUrl = await storageRef.getDownloadURL();

    // Save data to Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docRef = userRef.collection('docs').doc(); // Create a new document in the 'docs' subcollection

      await docRef.set({
        'text': widget.text,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
      });

      // Show alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Data saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
                Navigator.of(context).pop(); // Close the ResultScreen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
