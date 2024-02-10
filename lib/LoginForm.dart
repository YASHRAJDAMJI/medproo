import 'package:flutter/material.dart';
import 'authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String role = '';
  String password = '';
  bool enable = true;
  String fullname = '';
  int adharNumber = 0; // Updated Aadhar number variable
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medpro')),
      backgroundColor: Color(0xFFEEE2DE),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "MedPro",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                      height: 62 / 39,
                      letterSpacing: 0,
                      color: Color(0xFF2B2A4C),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEA906C),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(53.0),
                        topRight: Radius.circular(53.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Login to your account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2B2A4C),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  login ? Container() : TextFormField(
                                    key: ValueKey('fullname'),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Full Name',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color(0xFF2B2A4C),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: Color(0xFF2B2A4C)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Full Name';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        fullname = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    key: ValueKey('email'),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color(0xFF2B2A4C),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: Color(0xFF2B2A4C)),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please Enter valid Email';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        role = 'user';
                                        email = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    key: ValueKey('password'),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color(0xFF2B2A4C),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: Color(0xFF2B2A4C)),
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return 'Please Enter Password of min length 6';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        password = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  // Show Aadhar number field only when signing up
                                  Visibility(
                                    visible: !login, // Show when not login (signup)
                                    child: TextFormField(
                                      key: ValueKey('aadhar'),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Aadhar Number',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF2B2A4C),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(color: Color(0xFF2B2A4C)),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length != 12) {
                                          return 'Please Enter a 12-digit Aadhar Number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          adharNumber = int.parse(value!);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    height: 55,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Color(0xFFB31312),
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          login
                                              ? AuthServices.signinUser(
                                              role,
                                              email,
                                              password,
                                              context)
                                              : AuthServices.signupUser(
                                              role,
                                              email,
                                              password,
                                              fullname, adharNumber,
                                              context);
                                        }
                                      },
                                      child: Text(
                                        login ? 'Login' : 'Signup',
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xFF2B2A4C),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        login = !login;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          login
                                              ? "Don't have an account? "
                                              : "Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          login
                                              ? "Signup"
                                              : "Login",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 246, 158, 40),
                                          ),
                                        ),
                                        login ? SizedBox(height: 10,) : Container(),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
