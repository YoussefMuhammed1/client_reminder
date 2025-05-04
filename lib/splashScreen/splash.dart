import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test/HomeScreen.dart';
import 'package:test/auth/Login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10)).then((value) => setState(() {
          isLoaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/smartwatch.png'),
      title: Text(
        "Pill Reminder",
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 78, 141, 187),
      showLoader: true,
      loaderColor: Colors.white,
      loadingText: Text(
        "Loading...",
        style: TextStyle(color: Colors.white),
      ),
      navigator: (FirebaseAuth.instance.currentUser != null)
          ? HomeScreen()
          : LoginScreen(),
      durationInSeconds: 5,
    );
  }
}
