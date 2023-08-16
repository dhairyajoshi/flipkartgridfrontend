// ignore_for_file: prefer_const_constructors

import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flipkartgridfrontend/screens/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBD',
      home: LoginScreen(),
    );
  }
}

