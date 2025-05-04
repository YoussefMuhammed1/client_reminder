import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test/auth/Login.dart';
import 'package:test/components/defualt_button.dart';
import 'package:test/components/defualt_textfield.dart';
import 'package:test/dialogs/dialogs.dart';
import 'package:test/helper/apis.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var departController = TextEditingController();
  var passController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user => auth.currentUser!;
  bool isPasswordShow = true;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        elevation: 0,
        title: Text(
          "Doctor Register Form",
          style: TextStyle(fontSize: 20),
        ),
      ),
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
                                  height: 80,
                                ),
                                Text(
                                  "REGISTER",
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
                                    controller: nameController,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your Full Name";
                                      }
                                    },
                                    label: "Full Name",
                                    prefix: Icons.person,
                                    color: Color.fromARGB(255, 174, 73, 102)),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                    controller: departController,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your Department";
                                      }
                                    },
                                    label: "Department",
                                    prefix: Icons.dashboard,
                                    color: Color.fromARGB(255, 174, 73, 102)),
                                SizedBox(
                                  height: 20,
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
                                        signUp(emailController.text,
                                            passController.text, "Doctor");
                                      }
                                      Dialogs.showSnackbar(context,
                                          "Account Created Sucessfully!");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()));
                                    },
                                    text: "Register"),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already Have an Account ?"),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginScreen()));
                                        },
                                        child: Text(
                                          "LOGIN",
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

  void signUp(String email, String password, String rool) async {
    CircularProgressIndicator();

    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              APIs.CreateUserRool(nameController.text, emailController.text,
                  departController.text, rool, user.uid)
            });
  }
}
