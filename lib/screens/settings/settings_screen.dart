import 'dart:async';

import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final User me;

  const SettingsScreen({Key key, this.me}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello ${widget.me.name}",
              style: TextStyle(
                fontFamily: "DottiesChocolate",
                fontSize: 32,
                color: MyTheme.yellowColor,
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: size.width * 0.7,
              child: RaisedButton(
                onPressed: () {
                  Timer(
                    Duration(milliseconds: 100),
                    () {
                      print("Logging Out");
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/'),
                      );
                    },
                  );
                },
                color: MyTheme.whiteColor,
                splashColor: MyTheme.yellowColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text("Log out",
                    style: TextStyle(
                      color: MyTheme.yellowColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
