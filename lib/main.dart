import 'package:flutter/material.dart';

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
            title: Text("Card Game App"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.view_carousel_rounded)),
                Tab(icon: Icon(Icons.message_rounded)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Text("Home Tab"),
              CustomData(),
              Text("Conversations Tab"),
              Text("Settings Tab"),
            ],
          ),
        ),
      ),
    );
  }
}
