import 'package:flutter/material.dart';

class BrowseDecksScreen extends StatefulWidget {
  @override
  _BrowseDecksScreenState createState() => _BrowseDecksScreenState();
}

class _BrowseDecksScreenState extends State<BrowseDecksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse Decks"),
      ),
      body: Center(
        child: Text("Browse Decks"),
      ),
    );
  }
}
