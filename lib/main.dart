import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'authentication/signin.dart';
import 'authentication/signup.dart';
import 'customDatabase.dart';
=======

import 'app.dart';
>>>>>>> 4affab761e12437b9dcf5622fc27e48a20c3cd38

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      title: "Conversation App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
>>>>>>> 4affab761e12437b9dcf5622fc27e48a20c3cd38
      ),
      home: CustomNavigatorHomePage(),
    );
  }
}
