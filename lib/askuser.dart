import 'package:flutter/material.dart';
//import 'adminpage.dart';

class askuser extends StatefulWidget {
  const askuser({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<askuser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2B2A4C), // Set the background color here
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  'MEDPRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/home.png",
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                        color: Colors.white,
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/student.png",
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  'User',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF4C505B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'loginmess');
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/cook.png",
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  'Doctor',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF4C505B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
