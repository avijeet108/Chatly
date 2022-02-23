import 'package:chat_app/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:chat_app/constants/Colours.dart';
import 'package:google_fonts/google_fonts.dart';

class Reg extends StatefulWidget {
  @override
  _RegState createState() => _RegState();
}

class _RegState extends State<Reg> {
  final _formkey = GlobalKey<FormState>();

  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _secure = false;
  bool _passshow = true;

  showhide() {
    setState(() {
      _secure = !_secure;
      _passshow = !_passshow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    "Signup",
                    style: GoogleFonts.akayaTelivigala(
                        textStyle: TextStyle(
                            color: pink,
                            fontSize: 60,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          onSaved: (value) {
                            usernameController.text = value!;
                          },
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Name cannot be empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter a valid name(min 3 characters)");
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          decoration: InputDecoration(
                              fillColor: pink,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: purple,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              labelText: 'Name',
                              labelStyle: GoogleFonts.akayaTelivigala(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 22))),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          onSaved: (value) {
                            emailController.text = value!;
                          },
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
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          decoration: InputDecoration(
                              fillColor: pink,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.email,
                                color: purple,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              labelText: 'Email',
                              labelStyle: GoogleFonts.akayaTelivigala(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 22))),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required for login");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter valid password(min 6 characters)");
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          cursorHeight: 22.0,
                          autofocus: false,
                          obscureText: _passshow,
                          decoration: InputDecoration(
                            fillColor: pink,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: purple,
                            ),
                            suffixIcon: IconButton(
                              onPressed: showhide,
                              icon: Icon(
                                _secure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: purple,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.akayaTelivigala(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 22)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  SizedBox(
                    //width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 15.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: pink,
                      ),
                      onPressed: () {
                        signup(usernameController.text, emailController.text,
                            passwordController.text);
                        signin(emailController.text, passwordController.text);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 40,
                        color: purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.akayaTelivigala(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          ' Log In',
                          style: GoogleFonts.akayaTelivigala(
                              textStyle: TextStyle(
                            color: pink,
                            fontSize: 20,
                          )),
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

  void signup(String name, String email, String password) async {
    if (_formkey.currentState!.validate()) {
      UserCredential userCrendetial = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });

      userCrendetial.user!.updateDisplayName(name);

      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "unavailable",
      });
    }
  }

  void signin(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Account Created Successfully!"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
