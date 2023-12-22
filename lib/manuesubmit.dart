import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_notifications.dart';


//update poll

class Mess_Home extends StatefulWidget {
  final currentUser = FirebaseAuth.instance;

  @override
  _Mess_HomeState createState() => _Mess_HomeState();
}

class _Mess_HomeState extends State<Mess_Home> {
  String? selectedDropdown1;
  String? selectedDropdown2;
  String? selectedDropdown3;
  String? selectedDropdown4;


  void _handleNotificationButtonClick() {
    // Get the current time
    DateTime now = DateTime.now();

    // Check if the current time is within the specified time ranges (9 to 10 am or 7 to 8 pm)
    bool isWithinMorningRange =
        now.hour >= 9 && now.hour < 10 && now.minute >= 0 && now.minute < 60;
    bool isWithinEveningRange =
        now.hour >= 19 && now.hour < 20 && now.minute >= 0 && now.minute < 60;

    if (isWithinMorningRange || isWithinEveningRange) {
      // Cancel the periodic notifications for the current day
      LocalNotifications.cancel(1);
    } else {
      // Schedule the periodic notifications for the morning and evening
      // LocalNotifications.showPeriodicNotifications(
      //   title: "Ashray",
      //   body: "Hey , user  update MessMenu",
      //   payload: "Your Payload",
      // );
    }
  }

  Widget buildDropdown(List<String> dropdownData, {
    String? selectedValue,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    selectedValue ??= dropdownData.isNotEmpty ? dropdownData[0] : null;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(hint),
          ),
          ...dropdownData.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ],
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  Future<void> storeSelectedValues(DocumentReference userRef,
      String? dropdown1,
      String? dropdown2,
      String? dropdown3,
      String? dropdown4,) async {
    try {
      // Check if a document already exists
      // var myDataCollection = FirebaseFirestore.instance
      //     .collection('messvala')
      //     .doc('messfooddetails')
      //     .collection('messfoods')
      //     .doc(widget.currentUser.currentUser!.uid)
      //     .get();

      try {
        // Check if a document already exists
        var myDataCollection = FirebaseFirestore.instance
            .collection('messvala')
            .doc('messfooddetails')
            .collection('messfoods')
            .doc(widget.currentUser.currentUser!.uid);

        // Set data on the existing document
        await myDataCollection.set({
          'dropdown1': dropdown1,
          'dropdown2': dropdown2,
          'dropdown3': dropdown3,
          'dropdown4': dropdown4,
          'pollcount1': 0,
          'pollcount2': 0,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Selected values stored successfully');
      } catch (e) {
        print('Error storing selected values: $e');
      }
    }catch(e)
    {

    }
  }

  Future<void> showConfirmationDialog(BuildContext context,
      String? dropdown1,
      String? dropdown2,
      String? dropdown3,
      String? dropdown4,
      DocumentReference userRef,) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to Confirm ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Selected Dropdown 1: $dropdown1'),
                Text('Selected Dropdown 2: $dropdown2'),
                Text('Selected Dropdown 3: $dropdown3'),
                Text('Selected Dropdown 4: $dropdown4'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                // LocalNotifications.showPeriodicNotifications(title:"rbgjbr", body: "jsbfhb", payload: "fbdshbf");
                print("triggesfred");
                _handleNotificationButtonClick();
                Navigator.of(context).pop();
                await storeSelectedValues(
                  userRef,
                  dropdown1,
                  dropdown2,
                  dropdown3,
                  dropdown4,
                );
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("user")
          .where("uid", isEqualTo: widget.currentUser.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          var data = snapshot.data!.docs[0];
          List<String> dropdown1Data = List.from(data['dropdown1'] ?? []);
          List<String> dropdown2Data = List.from(data['dropdown2'] ?? []);
          List<String> dropdown3Data = List.from(data['dropdown3'] ?? []);
          List<String> dropdown4Data = List.from(data['dropdown4'] ?? []);

          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 20),
                  Text(
                    data['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['messname'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "UpDatePoll 1" ,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('OLI BHAJI 1:'),  // <-- Add this line
                  buildDropdown(
                    dropdown1Data,
                    selectedValue: selectedDropdown1,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown1 = newValue;
                      });
                    },
                    hint: 'Select Dropdown 1',
                  ),
                  Text('OLI BHaji2:'),  // <-- Add this line
                  buildDropdown(
                    dropdown2Data,
                    selectedValue: selectedDropdown2,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown2 = newValue;
                      });
                    },
                    hint: 'Select Dropdown 2',
                  ),
                  Text(
                    "UpDatePoll 2" ,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Sukhi Bhaji 1:'),  // <-- Add this line
                  buildDropdown(
                    dropdown3Data,
                    selectedValue: selectedDropdown3,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown3 = newValue;
                      });
                    },
                    hint: 'Select Dropdown 3',
                  ),
                  Text('Sukhi Bhaji 2 :'),  // <-- Add this line
                  buildDropdown(
                    dropdown4Data,
                    selectedValue: selectedDropdown4,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDropdown4 = newValue;
                      });
                    },
                    hint: 'Select Dropdown 4',
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {

                        showConfirmationDialog(
                          context,
                          selectedDropdown1,
                          selectedDropdown2,
                          selectedDropdown3,
                          selectedDropdown4,
                          data.reference,
                        );
                      },
                      child: Text("Submit"),
                    ),
                  ),
                ],
              ),


            ],
          );
        }
      },
    );
  }
}