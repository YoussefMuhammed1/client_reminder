import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/helper/apis.dart';
import 'package:test/models/chatUser.dart';

import '../Chats/Alldoctors.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn google = GoogleSignIn();
  List<chatUser> list = [];

  final List<chatUser> searchlist = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    // APIs.getFirebaseMessagingToken();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 174, 73, 102),
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
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searchlist.add(i);
                          }
                          setState(() {
                            searchlist;
                          });
                        }
                      },
                      autofocus: true,
                    )
                  : Text("All Doctors"),
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
            body: StreamBuilder(
              stream: APIs.getdoctors(),
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
                            ?.map((e) => chatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              isSearching ? searchlist.length : list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AllDoctors(
                                user: isSearching
                                    ? searchlist[index]
                                    : list[index]);
                          });
                    } else {
                      return isSearching
                          ? Center(
                              child: Text(
                              "No Results !",
                              style: TextStyle(fontSize: 20),
                            ))
                          : Center(
                              child: Text(
                              "No Doctors !",
                              style: TextStyle(fontSize: 20),
                            ));
                    }
                }
              },
            )),
      ),
    );
  }
}
