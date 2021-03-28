import 'package:flutter/material.dart';
import 'package:vybe_2/Views/SplashScreen/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      )
    );
  }
}

