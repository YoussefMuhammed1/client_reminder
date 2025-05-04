import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/auth/Login.dart';
import 'package:test/helper/apis.dart';
import 'package:test/models/chatUser.dart';

import 'Add_Medicien_Form.dart';
import 'DatabaseWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //________________________________FirebaseIntailized____________________________//
  final firebaseInstance = FirebaseFirestore.instance;
  //____________________________________Scaffold__________________________________//

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(APIs.user.uid);
  }

  List<chatUser> list = [];

  String user = APIs.user.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        elevation: 0,
        title: const Text(
          "Reminders",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.login_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddForm()));
        },
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        child: const Icon(Icons.add),
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
                          child: StreamBuilder<QuerySnapshot>(
                            stream: firebaseInstance
                                .collection('users')
                                .where('User ID', isEqualTo: APIs.user.uid)
                                // .limit(1)
                                .orderBy('Time')
                                .snapshots(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.none:
                                case ConnectionState.active:
                                // return Center(
                                //   child: Text("no Data"),
                                // );
                                case ConnectionState.done:
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var dataId =
                                            snapshot.data!.docs[index].id;
                                        DocumentSnapshot data =
                                            snapshot.data!.docs[index];
                                        //________________________________Send Data To DatabaseWidget_____________________________//
                                        return DatabaseWidget(
                                          documentSnapshot: data,
                                          id: dataId,
                                          formId: data['Id'],
                                          medicienName: data['Medicien Name'],
                                          dosage: data['Dosage'],
                                          note: data['Note'],
                                          reminder: data['Reminder'],
                                          date: data['Date'],
                                          time: data['Time'],
                                          nextReminderDatabase:
                                              data['Next Reminder'],
                                          userid: data['User ID'],
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                      "No Reminder !",
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
