import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/firebase_options.dart';
import 'root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
