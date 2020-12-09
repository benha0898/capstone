import 'package:CapstoneProject/models/user.dart';
import 'package:flutter/material.dart';
import 'package:CapstoneProject/theme/consts.dart';

class SettingsScreen extends StatefulWidget {
  final User me;

  const SettingsScreen({Key key, this.me}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: Center(
        child: Text("Hello ${widget.me.name}"),
      ),
    );
  }
}
