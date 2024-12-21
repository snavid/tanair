import 'package:flutter/material.dart';
import 'screens/login_page.dart';
//import 'dart:convert';


void main() {
  runApp(TanairCargoApp());
}

class TanairCargoApp extends StatelessWidget {
  const TanairCargoApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'TANAIR CARGO',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}