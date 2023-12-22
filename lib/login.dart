import 'package:flutter/material.dart';
import 'package:aashray_veriion3/authFunctions.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String role = 'user';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('User Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xffffa936), // Set the background color here
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              login
                  ? Container()
                  : TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffffa936),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(21, 0, 0, 245),
                        width: 19.28,
                        height: 14,
                        child: Image.network(
                          '[Image url]',
                          width: 19.28,
                          height: 14,
                        ),
                      ),
                      // Add your UI components here
                      // ...
                    ],
                  ),
                ),
              ),
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
                    return 'Please Enter a valid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
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
                    return 'Please Enter Password of minimum length 6';
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Please wait Processing Request')));
                      _formKey.currentState!.save();
                      login
                          ? AuthServices.signinUser(
                          role, email, password, context)
                          : AuthServices.signupUser(
                          role, email, password, fullname, context);
                    }
                  },
                  child: Text(login ? 'Login' : 'Signup'),
                ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserLoginPage(),
  ));
}
