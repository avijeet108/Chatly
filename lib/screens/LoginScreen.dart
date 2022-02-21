//import 'package:blog_stack/views/home.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_app/screens/RegistrationScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //form key
  final _formkey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  bool _secure = false;
  bool _passshow = true;

  bool isLoading = false;

  showhide() {
    setState(() {
      _secure = !_secure;
      _passshow = !_passshow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please enter your email");
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                },
                                cursorColor: Colors.white,
                                cursorHeight: 22.0,
                                autofocus: false,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller: passwordController,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                cursorHeight: 22.0,
                                autofocus: false,
                                obscureText: _passshow,
                                validator: (value) {
                                  RegExp regex = new RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Password is required for login");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter valid password(min 6 characters)");
                                  }
                                },
                                onSaved: (value) {
                                  passwordController.text = value!;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.blue,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: showhide,
                                    icon: Icon(
                                      _secure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              elevation: 15.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              signin(emailController.text,
                                  passwordController.text);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Reg()));
                              },
                              child: Text(
                                ' Sign up',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void signin(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
