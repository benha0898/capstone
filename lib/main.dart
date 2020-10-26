import 'package:flutter/material.dart';
import 'authentication/signin.dart';
import 'authentication/signup.dart';
import 'customDatabase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink[400] ,
            title: Text("Card Game App"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.view_carousel)),
                Tab(icon: Icon(Icons.message)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SignUp(),
              CustomData(),
              SignIn(),
              Text("Settings Tab"),
            ],
          ),
        ),
      ),
    );
  }
}
