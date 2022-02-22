import 'package:chat_app/screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Home Screen"),
          actions: [
            IconButton(
                icon: Icon(Icons.logout), onPressed: () => logOut(context))
          ],
        ),
        body: isLoading == true
            ? Center(
                child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator(),
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
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          // String roomId = chatRoomId(
                          //     _auth.currentUser!.displayName!,
                          //     userMap!['name']);

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => ChatRoom(
                          //       chatRoomId: roomId,
                          //       userMap: userMap!,
                          //     ),
                          //   ),
                          // );
                        },
                        leading: Icon(Icons.account_box, color: Colors.white),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.chat, color: Colors.white),
                      )
                    : Container(),
              ]));
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
