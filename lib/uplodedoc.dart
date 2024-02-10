import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Uplodedoc(uid: 'user_uid_here')); // Provide the user UID here
}

class Uplodedoc extends StatelessWidget {
  final String uid; // Add UID as a parameter

  Uplodedoc({required this.uid}); // Constructor with UID parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: UplodedocScreen(uid: uid),
        backgroundColor: Color(0xFFF5F5F5), // Set background color
      ),
    );
  }
}

class UplodedocScreen extends StatefulWidget {
  final String uid;

  UplodedocScreen({required this.uid});

  @override
  _UplodedocScreenState createState() => _UplodedocScreenState();
}

class _UplodedocScreenState extends State<UplodedocScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController symptomsController = TextEditingController(); // Added symptoms controller
  List<Map<String, dynamic>> dynamicFields = [];
  File? image;

  bool _uploading = false;
  bool _uploadSuccess = false;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Name',
                          hintText: 'Enter Name', // Add placeholder text
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: diseaseController,
                        decoration: InputDecoration(
                          labelText: 'Enter Disease',
                          hintText: 'Enter Disease', // Add placeholder text
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: symptomsController,
                        decoration: InputDecoration(
                          labelText: 'Enter Symptoms',
                          hintText: 'Enter Symptoms', // Add placeholder text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Dynamic Fields:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: dynamicFields.map((field) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(labelText: 'Enter Medicine Name'),
                                  onChanged: (value) {
                                    field['label'] = value;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButton<String>(
                                  items: ['Morning', 'Afternoon', 'Night']
                                      .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    field['time'] = value;
                                  },
                                  hint: Text('Select Time'),
                                  value: field['time'] ?? null,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                dynamicFields.add({'label': '', 'time': null});
                              });
                            },
                            child: Text('Add Field'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (dynamicFields.isNotEmpty) {
                                  dynamicFields.removeLast();
                                }
                              });
                            },
                            child: Text('Delete Field'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _uploading
                  ? CircularProgressIndicator()
                  : _uploadSuccess
                  ? Text('Data successfully uploaded to Pinata')
                  : ElevatedButton(
                onPressed: () async {
                  await _saveAndUploadData();
                },
                child: Text('Save Data and Upload to Pinata'),
              ),
              SizedBox(height: 20),
              image != null
                  ? Image.file(image!)
                  : ElevatedButton(
                onPressed: _getImage,
                child: Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndUploadData() async {
    String name = nameController.text;
    String disease = diseaseController.text;
    String symptoms = symptomsController.text; // Get symptoms value

    Map<String, dynamic> jsonData = {
      'name': name,
      'disease': disease,
      'symptoms': symptoms, // Add symptoms to JSON data
    };

    dynamicFields.forEach((field) {
      jsonData[field['label']] = field['time'];
    });

    if (image != null) {
      // Convert image to base64 string
      List<int> imageBytes = await image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      jsonData['image'] = base64Image;
    }

    String jsonString = jsonEncode(jsonData);

    final pinataUrl = Uri.parse('https://api.pinata.cloud/pinning/pinJSONToIPFS');
    final apiKey = 'fdbd39f33988c3575508'; // Replace with your actual Pinata API key
    final apiSecret = 'e4f4368b2a9ac8cbf07f3c5ab94f15e1e0bf7f347256e114b2b25c4ef2dd7af3'; // Replace with your actual Pinata API secret

    setState(() {
      _uploading = true;
    });

    final response = await http.post(
      pinataUrl,
      headers: {
        'Content-Type': 'application/json',
        'pinata_api_key': apiKey,
        'pinata_secret_api_key': apiSecret,
      },
      body: jsonString,
    );

    setState(() {
      _uploading = false;
      if (response.statusCode == 200) {
        _uploadSuccess = true;
        // Clear text fields and reset image
        nameController.clear();
        diseaseController.clear();
        symptomsController.clear(); // Clear symptoms field
        dynamicFields.clear();
        image = null;

        // Store the hash key in Firestore
        final hashKey = jsonDecode(response.body)['IpfsHash'];
        _storeHashKey(hashKey);
      } else {
        _uploadSuccess = false;
      }
    });
  }

  Future<void> _storeHashKey(String hashKey) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid) // Use the UID passed to the widget
          .collection('docs') // Subcollection named "docs"
          .add({'hashKey': hashKey}); // Store the hash key
    } catch (error) {
      print('Error storing hash key: $error');
    }
  }
}
