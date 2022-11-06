import 'package:chat_app/constants/colours.dart';
import 'package:chat_app/screens/ChatRoom.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../group_chatting/group_chat_screen.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) < 0) {
      return "*$user2*";
    } else {
      return "*$user1*";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      //print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: background,
        title: Text(
          "Find Friends",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: blue,
              ),
              onPressed: () => logOut(context))
        ],
      ),
      body: isLoading == true
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(color: blue),
              ),
            )
          : Column(children: [
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                height: size.height / 14,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.15,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    cursorHeight: 22.0,
                    autofocus: false,
                    controller: _search,
                    decoration: InputDecoration(
                        fillColor: nav,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: IconButton(
                          onPressed: onSearch,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        labelText: 'Search',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              SizedBox(
                height: size.height / 30,
              ),
              userMap != null
                  ? ListTile(
                      onTap: () {
                        String roomId = chatRoomId(
                            _auth.currentUser!.displayName!, userMap!['name']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ));
                      },
                      leading: Icon(Icons.account_box, color: blue),
                      title: Text(
                        userMap!['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userMap!['email'],
                        style: TextStyle(color: grey),
                      ),
                      trailing: Icon(Icons.chat, color: blue),
                    )
                  : Container(),
            ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }
}

Future logOut(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login())));
  } catch (e) {
    print(e);
  }
}
