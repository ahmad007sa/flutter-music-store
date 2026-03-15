// Flutter Music Store
// A demo e-commerce style music app built with Flutter and Firebase.
// Features: Authentication, Admin management, Cart, Checkout and Invoice.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:musicstore/widgets/checklog.dart';

void main() async {
  //Firebase initializing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckLog(),
    );
  }
}
