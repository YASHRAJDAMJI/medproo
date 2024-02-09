import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  final String messTitle;
  final String uid1;
  final currentUser = FirebaseAuth.instance;

  FormPage({required this.messTitle,required this.uid1});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String selectedBhajiOption = ''; // Store the selected option for Bhaji
  String selectedOliBhajiOption = ''; // Store the selected option for Oli Bhaji
  int bhaji1Count = 0; // Store the count for Option 1 (Bhaji)
  int bhaji2Count = 0; // Store the count for Option 2 (Bhaji)
  int oli1Count = 0; // Store the count for Option 1 (Oli Bhaji)
  int oli2Count = 0; // Store the count for Option 2 (Oli Bhaji)

  var bj1=null;
  var bj2=null;
  var olibj1=null;
  var olibj2=null;
  @override
  void initState() {
    super.initState();
    // Fetch the current counts from Firestore when the widget initializes
    print("uid is ");
    print(widget.uid1);
    //fetchFirebaseCounts();
  }

  Future<void> fetchFirebaseCounts() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('messvala')
          .doc('messfooddetails')
          .collection('messfoods')
          .doc(widget.uid1)
          .get();

      if (doc.exists) {
        setState(() {
          bhaji1Count = doc['sukhibhaji1count'] ?? 0;
          bhaji2Count = doc['sukhibhaji2count'] ?? 0;
          oli1Count = doc['olibhaji1count'] ?? 0;
          oli2Count = doc['olibhaji2count'] ?? 0;
        });
      } else {
        // Handle the case where the document does not exist
      }
    } catch (error) {

      print('Error fetching Firebase counts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E8D8),
        //title: Text('Aahar '),
        title: Text('Vote',
          style: TextStyle(
              color: Color(0xFF9F5D06)
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF9F5D06), // Set the color of the back button
        ),

      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messvala')
            .doc('messfooddetails')
            .collection('messfoods')
            .doc(widget.uid1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bhaji1 = snapshot.data?.get('bhaji1') ?? 'Option 1 (Bhaji)';
          bj1=bhaji1;
          final bhaji2 = snapshot.data?.get('bhaji2') ?? 'Option 2 (Bhaji)';
          bj2=bhaji2Count;

          final oli1 = snapshot.data?.get('bhajioli1') ?? 'Option 1 (Olibhaji)';
          olibj1=oli1;

          final oli2 = snapshot.data?.get('bhajioli2') ?? 'Option 2 (Olibhaji)';
          olibj2=oli2;

          return Container(
            color: Color(0xfff5e8d8), // Set the background color here
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select a Sukhi Bhaji:',
                    style: TextStyle(fontSize: 18, color: Color(0xFF9F5D06)), // Set the text color here
                  ),
                ),
                RadioListTile(
                  title: Text(bhaji1),
                  value: bhaji1,
                  groupValue: selectedBhajiOption,
                  onChanged: (value) {
                    setState(() {
                      selectedBhajiOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(bhaji2),
                  value: bhaji2,
                  groupValue: selectedBhajiOption,
                  onChanged: (value) {
                    setState(() {
                      selectedBhajiOption = value.toString();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select a Oli Bhaji:',
                    style: TextStyle(fontSize: 18, color: Color(0xFF9F5D06)), // Set the text color here
                  ),
                ),
                RadioListTile(
                  title: Text(oli1),
                  value: oli1,
                  groupValue: selectedOliBhajiOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOliBhajiOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text(oli2),
                  value: oli2,
                  groupValue: selectedOliBhajiOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOliBhajiOption = value.toString();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedBhajiOption.isNotEmpty ||
                        selectedOliBhajiOption.isNotEmpty) {
                      // An option for Bhaji or Oli Bhaji is selected
                      incrementCounts();
                    } else {
                      // Show a validation message if no option is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select an option for Bhaji or Oli Bhaji.'),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );

        },
      ),
    );
  }


  void incrementCounts() {
    if (selectedBhajiOption == bj1) {
      bhaji1Count += 1;
    } else  {
      bhaji2Count += 1;
    }

    if (selectedOliBhajiOption == olibj1) {
      oli1Count += 1;
    } else if (selectedOliBhajiOption == olibj2) {
      oli2Count += 1;
    }

    // Update Firebase counts when an option is selected
    updateFirebaseCounts(bhaji1Count, bhaji2Count, oli1Count, oli2Count);
  }

  void updateFirebaseCounts(int bhaji1Count, int bhaji2Count, int oli1Count, int oli2Count) {
    FirebaseFirestore.instance
        .collection('messvala')
        .doc('messfooddetails')
        .collection('messfoods')
        .doc(widget.uid1)
        .update({
      'sukhibhaji1count': bhaji1Count,
      'sukhibhaji2count': bhaji2Count,
      'olibhaji1count': oli1Count,
      'olibhaji2count': oli2Count,
    });
  }
}

void main() => runApp(MaterialApp(
  home: Scaffold(
    body: FormPage(messTitle: 'YourMessTitle',uid1: 'uidhere'), // Replace with your mess title
  ),
));
