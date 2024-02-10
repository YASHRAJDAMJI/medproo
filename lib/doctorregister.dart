import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class OnboardClientPage extends StatefulWidget {
  @override
  _OnboardClientPageState createState() => _OnboardClientPageState();
}

class _OnboardClientPageState extends State<OnboardClientPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  File? pickedImage;
  double userLat = 0.0;
  double userLon = 0.0;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController licenseController = TextEditingController(); // New controller for license number
  LocationData? userLocation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  void getUserLocation() async {
    Location location = Location();
    PermissionStatus status = await location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await location.requestPermission();
      if (status == PermissionStatus.granted) {
        LocationData position = await location.getLocation();
        setState(() {
          userLocation = position;
        });
      }
    } else if (status == PermissionStatus.granted) {
      LocationData position = await location.getLocation();
      setState(() {
        userLocation = position;
      });
    }
  }

  Future<void> registerUserAndStoreData() async {
    try {
      setState(() {
        _isSaving = true;
      });

      // Validate fields
      if (_validateFields()) {
        // Create user with email and password
        await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Upload the picked image to Firebase Storage
        var imageUrl = await uploadImageToStorage();

        // Store additional data in Firestore
        await firestore.collection("doctors").doc(auth.currentUser!.uid).set({
          "email": emailController.text,
          "name": nameController.text,
          "password": passwordController.text,
          "uid": auth.currentUser!.uid,
          "phone": phoneNoController.text,
          "profileImageUrl": imageUrl,
          "role": "doctor",
          "enable": true,
          "license": licenseController.text,
          // Store license number in Firestore
        });

        // Clear text controllers and picked image after successful registration
        _clearData();
      }
    } catch (e) {
      // Handle errors
      print("Error registering user: $e");

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering user: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<String?> uploadImageToStorage() async {
    if (pickedImage == null) {
      return null;
    }

    try {
      // Create a unique filename for the image
      String fileName = "${auth.currentUser!.uid}_${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg";
      // Upload image to Firebase Storage
      await storage.ref("profile_images/$fileName").putFile(pickedImage!);

      // Get download URL
      String imageUrl = await storage.ref("profile_images/$fileName")
          .getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  bool _validateFields() {
    if (
    nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        passwordController.text.isEmpty ||
        licenseController.text.isEmpty // Validate license number
    ) {
      // Show an error message for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }

    return true;
  }

  void _clearData() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNoController.clear();
    licenseController.clear(); // Clear license number
    pickedImage = null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFECECEC), // Set the background color of the app bar
        title: Text('Sign Up'), // Set the title of the app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Set the background color of the container
                  borderRadius: BorderRadius.circular(10),
                  // Set the border radius to make the corners rounded
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Set the shadow color with opacity
                      spreadRadius: 5,
                      // Set the spread radius
                      blurRadius: 7,
                      // Set the blur radius
                      offset: Offset(0, 3), // Set the shadow offset
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0,
                            horizontal: 16.0), // Set the padding for the text field
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Add space between text fields
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0,
                            horizontal: 16.0), // Set the padding for the text field
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Add space between text fields
                    TextField(
                      controller: phoneNoController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0,
                            horizontal: 16.0), // Set the padding for the text field
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 8.0),
                    // Add space between text fields
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0,
                            horizontal: 16.0), // Set the padding for the text field
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 8.0),
                    // Add space between text fields
                    TextField(
                      controller: licenseController,
                      decoration: InputDecoration(
                        labelText: 'License Number',
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0,
                            horizontal: 16.0), // Set the padding for the text field
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Add space between text fields and buttons
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    if (pickedImage != null) ...[
                      SizedBox(height: 16),
                      // Add space between image and other elements
                      Image.file(pickedImage!, height: 100),
                    ],
                    SizedBox(height: 16.0),
                    // Add space between text fields and buttons
                    ElevatedButton(
                      onPressed: () {
                        registerUserAndStoreData();
                      },
                      child: Text('Submit'),
                    ),
                    if (_isSaving) ...[
                      SizedBox(height: 16.0),
                      // Add space for progress indicator
                      CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  void main() {
  runApp(MaterialApp(
    home: OnboardClientPage(),
  ));
}
