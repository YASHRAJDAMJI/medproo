import 'package:aashray_veriion3/polluplode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notifications.dart';

class PollUpdate extends StatefulWidget {
  @override
  _PollUpdateState createState() => _PollUpdateState();
}

class _PollUpdateState extends State<PollUpdate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  String? selectedDropdown1;
  String? selectedDropdown2;
  String? selectedDropdown3;
  String? selectedDropdown4;
  var uid1 = '';
  TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  Widget buildDropdown(List<String> dropdownData,
      {String? selectedValue, required ValueChanged<String?> onChanged, required String hint, required Color dropdownColor}) {
    selectedValue ??= dropdownData.isNotEmpty ? dropdownData[0] : null;

    return Container(

      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromARGB(255, 171, 99, 0)),
        color: Color.fromARGB( 255, 255, 240, 220),
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
        isExpanded: false,
        dropdownColor: dropdownColor,
      ),
    );
  }

  Future<void> storeSelectedValues(String? dropdown1, String? dropdown2, String? dropdown3,
      String? dropdown4, String? textFieldValue) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("messvala")
          .where("uid", isEqualTo: currentUser?.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs[0];
        var address = userData['address'];
        var location = userData['location'];
        var messon = userData['messon'];
        var profileImageUrl = userData['profileImageUrl'];
        var messnm = userData['mess_name'];
        var rcnm = userData['rcnm'];
        var upid = userData['upid'];
        var vegNonveg = userData['vegNonveg'];
        var uid = userData['uid'];
        uid1 = uid;

        var myDataCollection = FirebaseFirestore.instance.collection("messvala").doc('messfooddetails').collection('messfoods');

        await myDataCollection.doc(uid).set({
          'SukhiBhajifinal': dropdown1,
          'Olibhajifinal': dropdown2,
          'rice': dropdown3,
          'price': dropdown4,
          'textFieldValue': textFieldValue,
          'timestamp': FieldValue.serverTimestamp(),
          'address': address,
          'location': location,
          'messon': messon,
          'rcnm': rcnm,
          'profileImageUrl': profileImageUrl,
          'upid': upid,
          'vegNonveg': vegNonveg,
          'uid': uid,
          'mess_name': messnm,
        });

        var myDataCollection2 = FirebaseFirestore.instance.collection("messvala").doc('messlist').collection('messlistcol');
        var existingDocument = await myDataCollection2.doc(uid).get();

        if (existingDocument.exists) {
          print('Document exists before update: true');
          await myDataCollection2.doc(uid).update({
            'special': textFieldValue,
          });
        } else {
          print('Document does not exist before update');
        }

        print('Selected values stored successfully');
      } else {
        print('User data not found');
      }
    } catch (e) {
      print('Error storing selected values: $e');
    }
  }

  Future<void> showConfirmationDialog(BuildContext context, String? dropdown1, String? dropdown2,
      String? dropdown3, String? dropdown4, String? textFieldValue, DocumentReference userRef) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to Confirm?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Selected Dropdown 1: $dropdown1'),
                Text('Selected Dropdown 2: $dropdown2'),
                Text('Selected Dropdown 3: $dropdown3'),
                Text('Selected Dropdown 4: $dropdown4'),
                Text('Text Field Value: $textFieldValue'),
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
                  _textFieldController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await storeSelectedValues(
                  dropdown1,
                  dropdown2,
                  dropdown3,
                  dropdown4,
                  _textFieldController.text,
                );
                setState(() {
                  selectedDropdown1 = null;
                  selectedDropdown2 = null;
                  selectedDropdown3 = null;
                  selectedDropdown4 = null;
                  _textFieldController.clear();
                });
                _handleNotificationButtonClick();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showConfirmationDialog2(BuildContext context, String? dropdown1) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please fill all the fields !!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Pls select all the fields'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {

                });
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  void _handleNotificationButtonClick() {
    DateTime now = DateTime.now();
    bool isWithinMorningRange = now.hour >= 9 && now.hour < 10 && now.minute >= 0 && now.minute < 60;
    bool isWithinEveningRange = now.hour >= 19 && now.hour < 20 && now.minute >= 0 && now.minute < 60;

    if (isWithinMorningRange || isWithinEveningRange) {
      LocalNotifications.cancel(1);
    } else {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Data updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff0dc),
      key: _scaffoldKey,
      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("messvala")
            .where("uid", isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data2 = snapshot.data!.docs[0];
            print("Document data: ${data2.data()}");

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
                      data['mess_name'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Update Today's Menu",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Oli Bhaji:'),
                    buildDropdown(
                      dropdown1Data,
                      selectedValue: selectedDropdown1,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDropdown1 = newValue;
                        });
                      },
                      hint: 'Select Oli Bhaji',
                      dropdownColor: Color.fromARGB(255, 255, 170, 55),
                    ),
                    Text('Sukhi Bhaji:'),
                    buildDropdown(
                      dropdown2Data,
                      selectedValue: selectedDropdown2,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDropdown2 = newValue;
                        });
                      },
                      hint: 'Select Sukhi Bhaji',
                      dropdownColor: Color.fromARGB(255, 255, 170, 55),
                    ),
                    Text('RICE:'),
                    buildDropdown(
                      dropdown3Data,
                      selectedValue: selectedDropdown3,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDropdown3 = newValue;
                        });
                      },
                      hint: 'Select Rice Type',
                      dropdownColor: Color.fromARGB(255, 255, 170, 55),
                    ),
                    Text('Price:'),
                    buildDropdown(
                      dropdown4Data,
                      selectedValue: selectedDropdown4,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDropdown4 = newValue;
                        });
                      },
                      hint: 'Select Dropdown 4',
                      dropdownColor: Color.fromARGB(255, 255, 170, 55),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        labelText: 'Enter additional information',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 170, 55)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 170, 55)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          bool isSubscriptionExpired = false;

                          if (selectedDropdown1 == null || selectedDropdown2 == null || selectedDropdown3 == null || selectedDropdown4 == null) {

                            showConfirmationDialog2(
                              context,
                              "PLs fill all fields",
                            );

                          } else if (isSubscriptionExpired) {
                            // showsubscriptiondialog();
                          } else {
                            showConfirmationDialog(
                              context,
                              selectedDropdown1,
                              selectedDropdown2,
                              selectedDropdown3,
                              selectedDropdown4,
                              _textFieldController.text,
                              data.reference,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 170, 55),
                        ),
                        child: Text("Submit"),

                      ),

                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => polluplode(),                          ),
                        );
                      },
                      child: Icon(
                        Icons.add,
                      ),

                    )
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
