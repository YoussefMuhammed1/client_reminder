import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test/auth/Login.dart';

import '../chatScreens/widget/chatCard.dart';
import '../helper/apis.dart';
import '../models/chatUser.dart';

class DoctorLogin extends StatefulWidget {
  const DoctorLogin({super.key});

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  final List<chatUser> searchlist = [];
  List<chatUser> list = [];

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        elevation: 0,
        title: isSearching
            ? TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Name, Email, ...',
                ),
                style: TextStyle(
                    fontSize: 17, letterSpacing: 1, color: Colors.white),
                onChanged: (val) {
                  searchlist.clear();

                  for (var i in list) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      searchlist.add(i);
                    }
                    setState(() {
                      searchlist;
                    });
                  }
                },
                autofocus: true,
              )
            : Text("Chats"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          child: Icon(Icons.logout_outlined),
          backgroundColor: Color.fromARGB(255, 81, 122, 152),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 249, 236),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: StreamBuilder(
                            stream: APIs.getAllUsers(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  list = data
                                          ?.map((e) =>
                                              chatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  if (list.isNotEmpty) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                      child: ListView.builder(
                                          // scrollDirection: Axis.horizontal,
                                          itemCount: isSearching
                                              ? searchlist.length
                                              : list.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return chatCard(
                                                user: isSearching
                                                    ? searchlist[index]
                                                    : list[index]);
                                          }),
                                    );
                                  } else {
                                    return isSearching
                                        ? Center(
                                            child: Text(
                                            "No Results !",
                                            style: TextStyle(fontSize: 20),
                                          ))
                                        : Center(
                                            child: Text(
                                            "No Chats !",
                                            style: TextStyle(fontSize: 20),
                                          ));
                                  }
                              }
                            },
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
