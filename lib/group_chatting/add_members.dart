import 'package:chat_app/constants/colours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupChatId, name;
  final List membersList;
  const AddMembersINGroup(
      {required this.name,
      required this.membersList,
      required this.groupChatId,
      Key? key})
      : super(key: key);

  @override
  _AddMembersINGroupState createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends State<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
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

  void onAddMembers() async {
    membersList.add(userMap);

    await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupChatId)
        .set({"name": widget.name, "id": widget.groupChatId});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              color: background,
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                color: background,
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      labelText: 'Search',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    color: background,
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(blue),
                    ),
                    onPressed: onSearch,
                    child: Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onAddMembers,
                    leading: Icon(
                      Icons.account_box,
                      color: blue,
                    ),
                    title: Text(
                      userMap!['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      userMap!['email'],
                      style: TextStyle(color: grey),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
