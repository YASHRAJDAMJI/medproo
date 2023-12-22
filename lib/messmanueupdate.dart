import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:untitled/local_notifications.dart';

class messmanueupdate extends StatefulWidget {
  @override
  _messmanueupdate createState() => _messmanueupdate();
}

class _messmanueupdate extends State<messmanueupdate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser; // Declare currentUser here
  String? selectedDropdown1;
  String? selectedDropdown2;
  String? selectedDropdown3;
  String? selectedDropdown4;
  TextEditingController _textFieldController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    getCurrentUser();
    checkSubscriptionStatus();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  Future<void> checkSubscriptionStatus() async {
    bool isSubscriptionActive = prefs.getBool('isSubscriptionActive') ?? false;
    DateTime? subscriptionExpiryDate = prefs.containsKey('subscriptionExpiryDate')
        ? DateTime.parse(prefs.getString('subscriptionExpiryDate')!)
        : null;

    if (isSubscriptionActive &&
        subscriptionExpiryDate != null &&
        DateTime.now().isAfter(subscriptionExpiryDate)) {
      // Subscription has expired, show the renewal pop-up
      showSubscriptionDialog();
    }
  }

  // Showing subscription dialog
  Future<void> showSubscriptionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subscription Expired'),
          content: Text('Your subscription has expired. Renew to continue using the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Simulate subscription renewal (replace with actual payment logic)
                // SubscriptionManager.renewSubscription();
                Navigator.of(context).pop();
              },
              child: Text('Renew Subscription'),
            ),
          ],
        );
      },
    );
  }

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
    //  LocalNotifications.cancel(1);
    } else {
      // Schedule the periodic notifications for the morning and evening
      // LocalNotifications.showPeriodicNotifications(
      //   title: "Ashray",
      //   body: "Hey, user, update MessMenu",
      //   payload: "Your Payload",
      // );
    }
  }

  Widget buildDropdown(List<String> dropdownData,
      {String? selectedValue, required ValueChanged<String?> onChanged, required String hint}) {
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

  Future<void> storeSelectedValues(String? dropdown1, String? dropdown2, String? dropdown3,
      String? dropdown4, String? textFieldValue) async {
    try {
      // Retrieve user data using StreamBuilder
      var userSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where("uid", isEqualTo: currentUser?.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs[0];

        // Extract required fields from the user data
        var address = userData['address'];
        var location = userData['location'];
        var messon = userData['messon'];
        var profileImageUrl = userData['profileImageUrl'];
        var rcnm = userData['rcnm'];
        var upid = userData['upid'];

        var vegNonveg = userData['vegNonveg'];
        var uid = userData['uid'];


        // Add more fields as needed

        // Create a new collection at the top level
        var myDataCollection = FirebaseFirestore.instance.collection('foodlist');

        // Add a new document to the collection
        await myDataCollection.add({
          'dropdown1': dropdown1,
          'dropdown2': dropdown2,
          'dropdown3': dropdown3,
          'dropdown4': dropdown4,
          'textFieldValue': textFieldValue,
          'timestamp': FieldValue.serverTimestamp(),
          // Add the fields from the user data
          'address': address,
          'location': location,
          'messon':messon,
          'rcnm':rcnm,
          'profileImageUrl':profileImageUrl,
          'upid':upid,
          'vegNonveg':vegNonveg,
          'uid' : uid,

          // Add more fields as needed
        });

        print('Selected values stored successfully');
      } else {
        // Handle the case where no user data is found
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
                _handleNotificationButtonClick();
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
                    "Update Today's Menu",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('OLI BHAJI 1:'),
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
                  Text('OLI BHAJI 2:'),
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
                  Text('RICE:'),
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
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      labelText: 'Enter additional information',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isSubscriptionExpired = false;
                        if (isSubscriptionExpired) {
                          showSubscriptionDialog();
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