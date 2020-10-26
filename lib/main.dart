import 'package:flutter/material.dart';
//import 'authentication/signin.dart';
//import 'authentication/signup.dart';
//import 'customDatabase.dart';

import 'app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Conversation App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomNavigatorHomePage(),
    );
  }
}
