import 'package:aashray_veriion3/LoadingScreen.dart';
import 'package:aashray_veriion3/askuser.dart';
import 'package:aashray_veriion3/loginmess.dart';
import 'package:aashray_veriion3/userpage.dart';
import 'package:aashray_veriion3/adminpage.dart';
import 'package:aashray_veriion3/userscreennew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'LoginForm.dart';
import 'disablepage.dart';
import 'home.dart';
import 'login.dart';

int flag=0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              User? user = FirebaseAuth.instance.currentUser;


              var kk = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  if (documentSnapshot.get('role') == "user") {
                    flag=1;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  UserScreen(),
                      ),
                    );
                    //return ;
                  }
                  else
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  DisabledPage(),
                        ),
                      );
                    }

                }
              });


              var kk2 = FirebaseFirestore.instance
                  .collection('messvala')
                  .doc(user!.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  if (documentSnapshot.get('role') == "mess" ) {
                    flag=1;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  Home(),
                      ),
                    );
                    //return ;
                  }
                  else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  DisabledPage(),
                      ),
                    );
                  }

                }
              });



              if(flag==1)
                {
                  return UserScreen();
                }
              else if(flag==2)
                {
                  return Home();
                }
              else
                {
                  return askuser();
                }

            } else {
             // var data=snapshot.data;
              //ScaffoldMessenger.of(context).showSnackBar(
                //  SnackBar(content: Text('data is before login bro $data'),duration: Duration(seconds: 5)));
              return askuser();
            }

            },

        ),routes: {
      //'register': (context) => LoginForm(),
      'login': (context) => LoginForm(),
      'loginmess':(context)=>LoginMess()

    });
  }
}
