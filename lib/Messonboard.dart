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
  File? pickedImage2;
  double userLat = 0.0;
  double userLon = 0.0;
  TextEditingController nameController = TextEditingController();
  TextEditingController messNameController = TextEditingController();
  TextEditingController upidcontrol = TextEditingController();
  TextEditingController rcnmcontrol = TextEditingController();
  TextEditingController vegnonvegcontrol = TextEditingController();



  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController field1Controller = TextEditingController();
  TextEditingController field2Controller = TextEditingController();
  TextEditingController additionalField1Controller = TextEditingController();
  TextEditingController additionalField2Controller = TextEditingController();
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

      // Fetch user location
    //  await getUserLocation();

      // Validate fields
      if (_validateFields()) {
        // Create user with email and password
        await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        print("User is registered");
        //getUserLocation();
        // Upload the picked image to Firebase Storage
        var imageUrl = await uploadImageToStorage();
        var imageUrl2 = await uploadImageToStorage2();

        // Use the user's location data
        getUserLocation();
        // Perform any other actions with the location data or leave it empty

        // Example: Show a snackbar with the location data
        if (userLocation != null) {
          userLat=userLocation!.latitude!;
          userLon=userLocation!.longitude!;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location: ${userLocation!.latitude}, ${userLocation!.longitude}'),
            ),
          );
        }
        GeoPoint geoPoint = GeoPoint(userLat, userLon);

        // Store additional data in Firestore
        await firestore.collection("messvala").doc(auth.currentUser!.uid).set({
          "email": emailController.text,
          "name": nameController.text,
          "password": passwordController.text,
          "uid": auth.currentUser!.uid,
          "mess_name": messNameController.text,
          "phone": phoneNoController.text,
          "address": addressController.text,
          "dropdown1": field1Controller.text.split(',').map((e) => e.trim()).toList(),
          "dropdown2": field2Controller.text.split(',').map((e) => e.trim()).toList(),
          "dropdown3": additionalField1Controller.text.split(',').map((e) => e.trim()).toList(),
          "dropdown4": additionalField2Controller.text.split(',').map((e) => e.trim()).toList(),
          "profileImageUrl": imageUrl,
          "profileImageUrl2": imageUrl2,
          "role": "mess",
          "enable": true,
          "bhaji1": 0,
          "bhaji2": 0,
          "bhaji3": 0,
          "bhaji4": 0,
          "location": geoPoint,
          "rcnm":rcnmcontrol.text,
          "upid":upidcontrol.text,
          "vegNonveg":vegnonvegcontrol.text,
          "messon":true,


        });

        await firestore.collection("messvala").doc("messlist").collection("messlistcol").doc(auth.currentUser!.uid).set({

           "uid": auth.currentUser!.uid,
           "name": messNameController.text,

        //   "address": addressController.text,

         "messpic": imageUrl,
           "url": imageUrl2,

         "location": geoPoint,
         "recnm":rcnmcontrol.text,
           "upid":upidcontrol.text,
           "vegnonveg":vegnonvegcontrol.text,
          "messon":true,
          "special":"",
          "food":"food",
        //
        //
         });

        print("data stored");

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
      String fileName = "${auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      // Upload image to Firebase Storage
      await storage.ref("profile_images/$fileName").putFile(pickedImage!);

      // Get download URL
      String imageUrl = await storage.ref("profile_images/$fileName").getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<String?> uploadImageToStorage2() async {
    if (pickedImage2 == null) {
      return null;
    }

    try {
      // Create a unique filename for the image
      String fileName2 = "${auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      // Upload image to Firebase Storage
      await storage.ref("logimg/$fileName2").putFile(pickedImage2!);

      // Get download URL
      String imageUrl2 = await storage.ref("logimg/$fileName2").getDownloadURL();

      return imageUrl2;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  bool _validateFields() {
    if (messNameController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        field1Controller.text.isEmpty ||
        field2Controller.text.isEmpty ||
        additionalField1Controller.text.isEmpty ||
        additionalField2Controller.text.isEmpty|| vegnonvegcontrol.text.isEmpty||upidcontrol.text.isEmpty || rcnmcontrol.text.isEmpty) {
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
    addressController.clear();
    messNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNoController.clear();
    field1Controller.clear();
    field2Controller.clear();
    additionalField1Controller.clear();
    additionalField2Controller.clear();
    rcnmcontrol.clear();
    upidcontrol.clear();
    vegnonvegcontrol.clear();
    pickedImage = null;
    pickedImage2 = null;
    addressController.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage2 = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: messNameController,
                decoration: InputDecoration(labelText: 'Mess Name'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneNoController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                obscureText: false,
              ),
              TextField(
                controller: field1Controller,
                decoration: InputDecoration(labelText: 'Bhaji (comma-separated)'),
              ),
              TextField(
                controller: field2Controller,
                decoration: InputDecoration(labelText: 'Sukhi Bhaji (comma-separated)'),
              ),
              TextField(
                controller: additionalField1Controller,
                decoration: InputDecoration(labelText: 'Rice (comma-separated)'),
              ),
              TextField(
                controller: additionalField2Controller,
                decoration: InputDecoration(labelText: 'Extra Beverage (comma-separated)'),
              ),
              TextField(
                controller: vegnonvegcontrol,
                decoration: InputDecoration(labelText: 'Veg/Non Veg (type only Veg or Nonveg)'),
              ),
              TextField(
                controller: rcnmcontrol,
                decoration: InputDecoration(labelText: 'Banking Name'),
              ),
              TextField(
                controller: upidcontrol,
                decoration: InputDecoration(labelText: 'UPI ID (Merchant Id only)'),
              ),
              SizedBox(height: 16),
              // Image picker button
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: _pickImage2,
                child: Text('Pick Logo'),
              ),
              // Display picked image (optional)
              if (pickedImage != null) ...[
                SizedBox(height: 16),
                Image.file(pickedImage!, height: 100),
              ],
              if (pickedImage2 != null) ...[
                SizedBox(height: 16),
                Image.file(pickedImage2!, height: 100),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  getUserLocation();
                  // Perform any other actions with the location data or leave it empty

                  // Example: Show a snackbar with the location data
                  if (userLocation != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location: ${userLocation!.latitude}, ${userLocation!.longitude}'),
                      ),
                    );
                  }
                },
                child: Text('Get Location'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  registerUserAndStoreData();
                },
                child: Text('Submit'),
              ),
              if (_isSaving) ...[
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
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
