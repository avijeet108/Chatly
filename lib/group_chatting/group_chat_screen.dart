import 'package:chat_app/constants/colours.dart';
import 'package:chat_app/group_chatting/create_group/add_members.dart';
import 'package:chat_app/group_chatting/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        title: Text("Your Groups"),
      ),
      body: isLoading
          ? Container(
              color: background,
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: blue,
              ),
            )
          : Container(
              color: background,
              child: ListView.builder(
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupChatRoom(
                          groupName: groupList[index]['name'],
                          groupChatId: groupList[index]['id'],
                        ),
                      ),
                    ),
                    leading: Icon(
                      Icons.group,
                      color: blue,
                    ),
                    title: Text(
                      groupList[index]['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMembersInGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
