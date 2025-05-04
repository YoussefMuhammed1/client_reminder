import 'package:flutter/material.dart';
import 'package:test/auth/Register.dart';
import 'package:test/auth/RegisterPatient.dart';

class ChooseReg extends StatefulWidget {
  const ChooseReg({super.key});

  @override
  State<ChooseReg> createState() => _ChooseRegState();
}

class _ChooseRegState extends State<ChooseReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        elevation: 0,
        title: Text(
          "Register Form",
          style: TextStyle(fontSize: 20),
        ),
      ),
      // appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Please Choose You are Patient OR Doctor",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 174, 73, 102),
                                ),
                                width: 300,
                                height: 50,
                                child: MaterialButton(
                                  color: Color.fromARGB(255, 174, 73, 102),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => register()));
                                  },
                                  child: Text(
                                    "Doctor",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 300,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => registerDoc()));
                                  },
                                  child: Text("Patient",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                            ],
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
