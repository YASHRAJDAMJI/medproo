import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchDataScreen extends StatefulWidget {
  final String uid;

  const FetchDataScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  List<Map<String, dynamic>> fetchedDataList = [];
  bool isLoading = false;

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Fetch documents from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('docs')
          .get();

      // Create a list to store all fetched data
      List<Map<String, dynamic>> newDataList = [];

      // Fetch data from IPFS for each document
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in snapshot.docs) {
        String hashKey = documentSnapshot['hashKey'];
        final url = Uri.parse('https://ipfs.io/ipfs/$hashKey');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          // Add fetched data to the newDataList
          newDataList.add(jsonDecode(response.body));
        } else {
          print('Failed to fetch data from IPFS: ${response.statusCode}');
        }
      }

      // Update the state of fetchedDataList with the newDataList
      setState(() {
        fetchedDataList = newDataList;
        isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Hide loading indicator in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator()) // Show circular progress indicator while loading
            else
              SizedBox(height: 0), // Placeholder when not loading
            SizedBox(height: 20),
            fetchedDataList.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: fetchedDataList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = fetchedDataList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.entries.map((entry) {
                          if (entry.key == 'image' && entry.value != null) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Image.memory(base64Decode(entry.value)),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text('${entry.key}: ${entry.value}'),
                            );
                          }
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
