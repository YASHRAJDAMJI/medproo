import 'package:aashray_veriion3/UpiPaymentScreen.dart';
import 'package:aashray_veriion3/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:location/location.dart';

import 'FormPage.dart';
import 'LoginForm.dart';

enum SortOption { location, vegNonVeg, price }

class userpage extends StatefulWidget {
  const userpage({Key? key});

  @override
  State<userpage> createState() => _userpage();
}

class _userpage extends State<userpage> {
  int bhaji1Votes = 0;
  var visit=0;
  var bhaji1;

  int bhaji2Votes = 0;
  bool hasVoted = false;
  SortOption _currentSortOption = SortOption.location;

  LocationData? userLocation;
  bool isVoting = false;
  String pollId = '';
  List<String> options = [];
  String selectedOption = '';

  void _sortMessList(SortOption? option, List<DocumentSnapshot<Object?>> item) {
    if (option != null) {
      setState(() {
        _currentSortOption = option;
      });

      List<DocumentSnapshot<Object?>> sortedList = List.from(item);

      switch (option) {
        case SortOption.location:
        // Sort by location logic
        // Example: sortedList.sort((a, b) => a['location'].compareTo(b['location']));
          break;

        case SortOption.vegNonVeg:
          sortedList.sort((a, b) {
            String vegNonVegA = a['vegnonveg'] ?? '';
            String vegNonVegB = b['vegnonveg'] ?? '';
            print('Comparing $vegNonVegA with $vegNonVegB');
            if (vegNonVegA == vegNonVegB) {
              return 0;
            } else if (vegNonVegA == 'veg') {
              return -1;
            } else if (vegNonVegB == 'veg') {
              return 1;
            } else if (vegNonVegA == 'veg,nonveg') {
              return -1;
            } else {
              return 1;
            }
          });
          break;

        case SortOption.price:
        // Sort by price logic
        // Example: sortedList.sort((a, b) => a['price'].compareTo(b['price']));
          break;
      }

      setState(() {
        item = sortedList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
    // checkUserEnabledStatus();
    initializePoll();
  }

  Future<void> initializePoll() async {
    final pollDoc = await FirebaseFirestore.instance.collection('polls').add({
      'title': 'Bhaji Poll',
    });

    pollId = pollDoc.id;

    await pollDoc.collection('options').doc('bhaji1').set({'votes': 0});
    await pollDoc.collection('options').doc('bhaji2').set({'votes': 0});
  }

  Future<void> checkUserEnabledStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        bool isEnabled = userSnapshot.get('enable') ?? false;
        if (!isEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User is disabled. You can't access this page BRO 🔴🔴."),
            ),
          );


          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginForm(),
            ),
                (route) => false,
          );
        }
      }
    }
  }

  List<DocumentSnapshot<Object?>>? item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffff0dc),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messvala')
            .doc('messlist')
            .collection('messlistcol')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          item = snapshot.data!.docs;

          return ListView(
            children: item?.map((doc) {
              var title = doc['name'];
              var imageURL = doc['url'];
              var imglogo=doc["messpic"];
               var uid=doc["uid"];
              var food = doc['food'];
              var isVeg = doc['vegnonveg'] == 'Veg';
              var isNonVeg = doc['vegnonveg'] == 'Nonveg';
              var isVegNonVeg = doc['vegnonveg'] == 'Veg,Nonveg';
              var special = doc['special'];
              var messOn = doc['messon'] ?? false;

             // visit=doc?['visit']?? 0;
              //visit=visit+1;
              //updateFirebaseCounts(visit,uid);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsScreen(
                        title: title,
                        imageURL: imglogo,
                        food: food,
                        isVeg: isVeg,
                        isNonVeg: isNonVeg,
                        isVegNonVeg: isVegNonVeg,
                        special: special,
                        uid:uid,
                      ),
                    ),
                  );
                },
                child: Container(

                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageURL,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                  ],
                                ),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        if (isVeg)
                                          Text(
                                            '🟩 Veg',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.green,
                                            ),
                                          ),
                                        if (isNonVeg)
                                          Text(
                                            '⭕ Non Veg',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                            ),
                                          ),
                                        if (isVegNonVeg)
                                          Text(
                                            '⭕ Veg - Non Veg',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (special != null && special.isNotEmpty)
                                  Text(
                                    '✨Special: $special',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList() ?? [],
          );
        },
      ),
    );
  }

  double calculateDistance(double messLat, double messLon) {
    if (userLocation != null &&
        userLocation!.latitude != null &&
        userLocation!.longitude != null) {
      double userLat = userLocation!.latitude!;
      double userLon = userLocation!.longitude!;

      const double radius = 6371;
      double dLat = (messLat - userLat) * (math.pi / 180);
      double dLon = (messLon - userLon) * (math.pi / 180);
      double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
          (math.cos(userLat * (math.pi / 180)) *
              math.cos(messLat * (math.pi / 180)) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2));
      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      double distance = radius * c;

      return distance;
    } else {
      return double.maxFinite;
    }
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

  void updateFirebaseCounts(var count,var uid) {
    FirebaseFirestore.instance
        .collection('messvala')
        .doc('messlist')
        .collection('messlistcol')
        .doc(uid)
        .update({
      'visit':count
    });

  }
}





class ItemDetailsScreen extends StatelessWidget {
  final String title;
  final String uid;
  final String imageURL;
  final String food;
  final bool isVeg;
  final bool isNonVeg;
  final bool isVegNonVeg;
  final String? special;

  var visit=0;

  ItemDetailsScreen({

    required this.title,
    required this.uid,
    required this.imageURL,
    required this.food,
    required this.isVeg,
    required this.isNonVeg,
    required this.isVegNonVeg,
    this.special,
  });
  var databro;
  Future<Map<String, dynamic>> fetchMessFoodDetails(String uid) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('messvala')
        .doc('messfooddetails')
        .collection('messfoods')
        .doc(uid)
        .get();

  print("uid is bro  ");

  print(uid);
print(documentSnapshot.get('Olibhajifinal'));
databro=documentSnapshot;
print(databro);
    // print("Fetched data: $documentSnapshot.data()");



    if (documentSnapshot.exists) {
      return {
        'address': documentSnapshot.get('address') ?? 'Address not found',
        'Olibhajifinal': documentSnapshot.get('Olibhajifinal') ?? 'Bhaji 1 not found',
        'SukhiBhajifinal': documentSnapshot.get('SukhiBhajifinal') ?? 'Bhaji 2 not found',
        'price': documentSnapshot.get('price') ?? 'price not found',
        'recnm': documentSnapshot.get('rcnm') ?? 'payment name not found',
        'upid': documentSnapshot.get('upid') ?? 'upi id not fund',
        'visit':documentSnapshot.get('visit')??0,
      };
    } else {
      return {
        'address': 'Address not found',
        'Olibhajifinal': 'Bhaji 1 not found',
        'SukhiBhajifinal': 'Bhaji 2 not found',
        'price': 'price not found',
        'recnm': 'reciver nam enot found',
        'upid': 'upi id not found'
      };
    }
  }

  // void incrementCounts() {
  //   if (selectedBhajiOption == bj1) {
  //     bhaji1Count += 1;
  //   } else  {
  //     bhaji2Count += 1;
  //   }
  //
  //   if (selectedOliBhajiOption == olibj1) {
  //     oli1Count += 1;
  //   } else if (selectedOliBhajiOption == olibj2) {
  //     oli2Count += 1;
  //   }
  //
  //   // Update Firebase counts when an option is selected
  //   updateFirebaseCounts(bhaji1Count, bhaji2Count, oli1Count, oli2Count);
  // }

  @override
  Widget build(BuildContext context) {
    void _showFormPage() {}

    void makePayment(double price, String recnm, String upid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpiPaymentScreen(price: price, recnm: recnm, upid: upid),
        ),
      );
      print('Payment of $price is initiated.');
    }

    print("uid at line 483");
    print(uid);

    print("passing the uid and title");
    print(title);
    print(uid);
    return Scaffold(
        backgroundColor: Color(0xfffff0dc),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 171, 0),
        title: Text('Item Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMessFoodDetails(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }



         // final data = snapshot.data;
          final data = databro;
          print("dataisbro");

          // print("Entire Data: $data");
          // print( data?['address'] );
          //
          // print("Entire Data: $data");
          // print( data?['address'] );
          print("data at the herechecking at");
          print(data);
          final address = data?['address'] ?? 'Address not found';
          final bhaji1 = data?['Olibhajifinal'] ?? 'Bhaji 1 not found';
          final bhaji2 = data?['SukhiBhajifinal'] ?? 'Bhaji 2 not found';
          final price = data?['price'] ?? 'price not declared';
         final rcnnn= data?['rcnm'];
         final upi=data?['upid'];

          if(bhaji1=="Bhaji 1 not found")
            {
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: Image.network(imageURL),
                  ),

                  SizedBox(height: 8.0),
                  Text(
                    "Pls Vote in the pole box by clicking on the follwwing buton",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),


                  FloatingActionButton(
                      backgroundColor: Color.fromARGB(255, 254, 171, 0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPage(messTitle: title,uid1: uid),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add,
                    ),
                  )
                ],
              ),);
            }


          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Image.network(imageURL),
                ),
                SizedBox(height: 16.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Address:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  address,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),

                Text(
                  'Rassa bhaji:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  bhaji1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Skhi bhaji:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  bhaji2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Price:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  price,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text('Address: $address, Bhaji 1: $bhaji1, Bhaji 2: $bhaji2, Price: $price'),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 254, 171, 0),
                    ),),
                  onPressed:(){
                    makePayment(double.parse(price), rcnnn, upi);
                  },
                  child: Text('Make Payment'),
                ),
                // FloatingActionButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => FormPage(messTitle: title,uid1:uid),
                //       ),
                //     );
                //   },
                //   child: Icon(
                //     Icons.add,
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: userpage(),
  ));
}
