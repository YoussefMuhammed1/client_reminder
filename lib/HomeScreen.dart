import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test/Chats/Chats.dart';

import 'reminder/Add_Medicien_Form.dart';
import 'reminder/HomePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    HomePage(),
    Chats(),
    AddForm(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined), label: "Reminder"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_information), label: "Treatment")
        ],
      ),
    );
  }
}
