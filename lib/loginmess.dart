
import 'package:flutter/material.dart';
import 'package:aashray_veriion3/authFunction2.dart';

import 'doctorregister.dart';

class LoginMess extends StatefulWidget {
  const LoginMess({super.key});

  @override
  State<LoginMess> createState() => _LoginMessState();
}

class _LoginMessState extends State<LoginMess> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  String fullnamemess = '';
  String address = '';

  bool login = true; // Start with login mode

  String role = 'mess';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 224, 199),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 171, 0),
        elevation: 0,

        title: Text('Login:Doctor'),
      ),

      body: Form(


        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!login)
                TextFormField(
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
              if (!login)
                TextFormField(
                  key: ValueKey('Mess Name'),
                  decoration: InputDecoration(
                    hintText: 'Enter Mess Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Mase Name';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      fullnamemess = value!;
                    });
                  },
                ),
              if (!login)
                TextFormField(
                  key: ValueKey('address'),
                  decoration: InputDecoration(
                    hintText: 'Enter Mess Address',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Mess address';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      address = value!;
                    });
                  },
                ),

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
                    role = 'mess';
                    email = value!;
                  });
                },
              ),

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

                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      AuthServices.signinUser(role, email, password, context);
                    }
                  },style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 254, 171, 0)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change the text color to your desired color
                ),
                  child: Text('Login'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardClientPage(),
                    ),
                  );
                },
                child: Text("Don't have an Account? sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
