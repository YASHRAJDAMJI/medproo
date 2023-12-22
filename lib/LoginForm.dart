import 'package:flutter/material.dart';
import 'package:aashray_veriion3/authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String role='';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 224, 199),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 171, 0),

        elevation: 0,
        title: Text('User Login..'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ======== Full Name ========
              login 
                  ? Container()
                  : TextFormField(
                key: ValueKey('fullname'),
                decoration: InputDecoration(
                  hintText: 'Enter Full Name',
                ),
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

              // ======== Email ========
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please Enter valid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    role='user';
                    email = value!;
                  });
                },
              ),
              // ======== Password ========
              TextFormField(
                key: ValueKey('password'),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                ),
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
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 254, 171, 0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        login
                            ? AuthServices.signinUser(role,email, password, context)
                            : AuthServices.signupUser(role,
                            email, password, fullname, context);
                      }
                    },
                    child: Text(login ? 'Login' : 'Signup')),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(

                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                child: Text(
                  login
                      ? "Don't have an account? Signup"
                      : "Already have an account? Login",
                  style: TextStyle(
                    color: Colors.blue, // Change the color to your desired color
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}