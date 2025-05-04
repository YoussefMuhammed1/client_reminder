import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/auth/Register.dart';
import 'package:test/auth/chooseReg.dart';
import 'package:test/helper/apis.dart';
import 'package:test/components/defualt_button.dart';
import 'package:test/components/defualt_textfield.dart';
import 'package:test/dialogs/dialogs.dart';
import '../DoctorWidget/DoctorLogin.dart';
import '../HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  bool isPasswordShow = true;
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        elevation: 0,
        title: Text(
          "Pill Reminder",
          style: TextStyle(fontSize: 22),
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
                    child: SingleChildScrollView(
                      child: Container(
                        child: Form(
                          key: formkey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 140,
                                ),
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 174, 73, 102),
                                      fontSize: 35),
                                ),
                                Text(
                                  "Create account now to Can Login",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                defaultFormField(
                                    controller: emailController,
                                    type: TextInputType.emailAddress,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your email address";
                                      }
                                    },
                                    label: "Email Address",
                                    prefix: Icons.email_outlined,
                                    color: Color.fromARGB(255, 174, 73, 102)),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                  controller: passController,
                                  type: TextInputType.visiblePassword,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter your Password";
                                    }
                                  },
                                  label: "Password ",
                                  prefix: Icons.lock,
                                  color: Color.fromARGB(255, 174, 73, 102),
                                  isPassword: isPasswordShow,
                                  suffixPressed: () {
                                    setState(() {
                                      isPasswordShow = !isPasswordShow;
                                    });
                                  },
                                  suffix: isPasswordShow
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                defualtButton(
                                    background:
                                        Color.fromARGB(255, 174, 73, 102),
                                    function: () async {
                                      if (formkey.currentState!.validate()) {
                                        setState(() {
                                          isloading = false;
                                        });

                                        try {
                                          UserCredential userCredential =
                                              await FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passController.text,
                                          );

                                          route();
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            print(
                                                'No user found for that email.');
                                            Dialogs.showSnackbar(
                                                context, "Email is InCorrect!");
                                            isloading = true;
                                          } else if (e.code ==
                                              'wrong-password') {
                                            Dialogs.showSnackbar(context,
                                                "Password is InCorrect!");
                                            isloading = true;
                                            print(
                                                'Wrong password provided for that user.');
                                          } else {
                                            Dialogs.showSnackbar(context,
                                                "Account is InCorrect!");
                                            setState(() {
                                              isloading = true;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    text: isloading ? "Login" : "Loading....."),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already Have an Account ?"),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ChooseReg()));
                                        },
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 174, 73, 102)),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('test')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Doctor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorLogin(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
