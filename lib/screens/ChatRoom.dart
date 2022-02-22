import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Name"),
      ),
      body: Container(),
      bottomNavigationBar: Container(),
    );
  }
}
