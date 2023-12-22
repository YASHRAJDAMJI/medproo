import 'package:flutter/material.dart';
import 'adminpage.dart';

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
        color: Color(0xffffa936), // Set the background color here
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child:
                Text(
                'Welcome\nBack',
                style: TextStyle(color: Color(0xffeae8e8), fontSize: 33),
              ),

            ),

            SingleChildScrollView(

              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Container(
                    child:
                    Image.asset(
                      "assets/aaharlogoanime.gif",
                      width: 450,
                      height: 450,
                      fit: BoxFit.cover,
                    ),
                  ),
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
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
                                      'Student',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
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
                                      'Mess Owner',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Admin',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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
