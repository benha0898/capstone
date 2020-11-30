//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class LoginCreateAccount extends StatefulWidget {
  @override
  _LoginCreateAccountState createState() => _LoginCreateAccountState();
}

class _LoginCreateAccountState extends State<LoginCreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.mainColor,
        body: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Email"),
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Password"),
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Confirm Password"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blueGrey,
                    Colors.white54,
                    Colors.blueGrey
                  ]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Submit", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 50),
            ],
          ),
        ));
  }
}
