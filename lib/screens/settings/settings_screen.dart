import 'package:flutter/material.dart';
import 'package:CapstoneProject/theme/consts.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: MyTheme.backgroundImage),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(children: [
            SizedBox(height: 50),
            Text(
              "Profile",
              style: TextStyle(
                fontFamily: "DottiesChocolate",
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
                color: MyTheme.whiteColor,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Logout",
              style: TextStyle(
                fontFamily: "DottiesChocolate",
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
                color: MyTheme.whiteColor,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
