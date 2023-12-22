import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Messonboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AdminPage(),
  ));
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    UsersPage(),
    MessOwnersPage(),
    SubscriptionTrackingScreen(),
    OnboardClientPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Mess Owners',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscription Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Add Mess',
          ),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final users = snapshot.data?.docs ?? [];

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userData = user.data() as Map<String, dynamic>;
            final name = userData['name'] ?? 'Name not available';
            final email = userData['email'] ?? 'Email not available';
            final enable = userData['enable'] ?? true;
            String role = userData['role'] ?? 'user';

            return Card(
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Enable User: '),
                      Switch(
                        value: enable,
                        onChanged: (bool value) {
                          FirebaseFirestore.instance.collection('users').doc(user.id).update({
                            'enable': value,
                            'role': value ? 'user' : 'disable',
                          });
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete User'),
                            content: Text('Are you sure you want to delete this user?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
class MessOwnersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messvala').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final messOwners = snapshot.data?.docs ?? [];

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
          ),
          itemCount: messOwners.length,
          itemBuilder: (context, index) {
            final messOwner = messOwners[index];
            final messOwnerData = messOwner.data() as Map<String, dynamic>;
            final name = messOwnerData['name'] ?? 'Name not available';
            final messName = messOwnerData['messname'] ?? 'Mess Name not available';
            final email = messOwnerData['email'] ?? 'Email not available';
            final address = messOwnerData['address'] ?? 'Address not available';
            final enable = messOwnerData['enable'] ?? true;
            String role = messOwnerData['role'] ?? 'mess';

            return Card(
              margin: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(name),
                    subtitle: Text(messName),
                  ),
                  ListTile(
                    title: Text('Email: $email'),
                    subtitle: Text('Address: $address'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Enable Mess: '),
                      Switch(
                        value: enable,
                        onChanged: (bool value) {
                          FirebaseFirestore.instance.collection('messvala').doc(messOwner.id).update({
                            'enable': value,
                            'role': value ? 'mess' : 'disable',
                          });
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete Mess Owner'),
                            content: Text('Are you sure you want to delete this mess owner?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('messvala').doc(messOwner.id).delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


class SubscriptionTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with the actual implementation of SubscriptionTrackingScreen
    return Center(
      child: Text('Subscription Tracking Screen'),
    );
  }
}

class MessRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with the actual implementation of MessRegistrationScreen
    return Center(
      child: Text('Mess Registration Screen'),
    );
  }
}


